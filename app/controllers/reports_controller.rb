require "net/http"
require "json"
require "open-uri"
require "httparty"
require "will_paginate/array"

class ReportsController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter, :only => :authenticated_show
  skip_before_action :verify_authenticity_token

  def update
    response = MuninnAdapter.put( "/reports/#{URI.encode(params[:id])}", params[:reportJSON] )
    render status: response.code, json: response.body
  end

  def create

    response = MuninnAdapter.post( '/reports/', params[:report])
    render status: response.code, json: response.body
  end

  def destroy
    response = MuninnAdapter.delete( "/reports/id/#{URI.encode(params[:id])}" )
    render status: response.code, json: response.body
  end

  def show
    logger.debug("Querying Muninn...")
    reports_resp = MuninnAdapter.get( "/reports/" + URI::encode(params[:id]) )
    @report = JSON.parse(reports_resp.body)  
    @report_embed = JSON.parse(@report["report"]["embedJSON"])
    
   
   
 end


  def authenticated_show

   muninn_response = MuninnAdapter.get( "/reports/" + URI::encode(params[:id]), session[:cas_user], session[:cas_pgt] )
   @report = JSON.parse(muninn_response.body)
   @report["huginn_user"] = session[:cas_user].to_s

  end

  def partial_search
    page =params[:page]
    json_string = MuninnCustomSearchAdapter.create_search_string( params[:q] )
    @results  = MuninnCustomSearchAdapter.custom_query(json_string, params[:page], 15 )
    @results_count = @results.select { |k| "#{k[:type]}" =="count"}
    @results_count = @results_count[0][:totalcount]
    @results_hash = {}
    @results_count.each do |hash|
       @results_hash[hash["term"]] = hash["count"]
    end

    @results = @results.select { |k| "#{k[:type]}" =="report"}
    @results = @results.sort_by { |k| "#{k[:sort_name]}"}
    @results =@results.paginate(:page=> page, :per_page => 15)
    respond_to do |format|
      format.json {render :json => @results, layout: false}
      format.html {render partial: "partial_search", layout: false }
    end
  end

 
  
end
