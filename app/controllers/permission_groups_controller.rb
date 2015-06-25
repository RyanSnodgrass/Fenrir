require "net/http"
require "json"
require "open-uri"
require "httparty"
require "will_paginate/array"

class PermissionGroupsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_permission_group, only: [:show, :update, :destroy]
  before_action :authenticate, only: [:create, :destroy, :update]

  # def index
  #   logger.debug("Querying Muninn...")
  #   page =params[:page]
  #   json_string = Muninn::CustomSearchAdapter.create_search_string( params[:q], session[:cas_user], session[:cas_pgt] )
  #   @results= Muninn::CustomSearchAdapter.custom_query(json_string, params[:page], 15, session[:cas_user], session[:cas_pgt] )
  #   @results_= @results.select { |k| "#{k[:type]}" =="permission_group"}
  #   @results = @results.sort_by { |k| "#{k[:sort_name]}"}
  #   @results =@results.paginate(:page=> page, :per_page => 15)
  # end
  
  def show
  end

  def update
    if @permission_group.update(permission_group_params)
      render status: response.code, json: response.body
      head :ok
    end
  end

  def create
    @permission_group = PermissionGroup.new(permission_group_params)  
    if @permission_group.save
      render status: response.code, json: response.body
      head :ok
    end
  end

  def destroy
    @permission_group.destroy
    head :ok
  end

 # def partial_search
 #    page =params[:page]
 #    json_string = Muninn::CustomSearchAdapter.create_search_string( params[:q] )
 #    @results= Muninn::CustomSearchAdapter.custom_query(json_string, params[:page], 15, session[:cas_user], session[:cas_pgt] )
 #    @results_count = @results.select { |k| "#{k[:type]}" =="count"}
 #    @results_count = @results_count[0][:totalcount]
 #    @results_hash = {}
 #    @results_count.each do |hash|
 #      @results_hash[hash["term"]] = hash["count"]
 #    end

 #    @results = @results.select { |k| "#{k[:type]}" == "office"}
 #    @results = @results.sort_by { |k| "#{k[:sort_name]}"}
 #    @results = @results.paginate(:page=> page, :per_page => 15)
 #      respond_to do |format|
 #      format.json {render :json => @results, layout: false}
 #      format.html {render partial: "partial_search", layout: false }
 #    end
 #  end

  private

  def set_permission_group
    @permission_group = PermissionGroup.find_by(name: params[:id])
  end

  def permission_group_params
    params.require(:permission_group).permit(:name)
  end
end
