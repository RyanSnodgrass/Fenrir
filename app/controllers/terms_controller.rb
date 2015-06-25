require 'net/http'
require 'json'
require 'open-uri'
require 'httparty'
require 'will_paginate/array'
require 'logger'

class TermsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_term,     only: [:show, :update, :destroy]
  before_action :authenticate, only: [:create, :destroy, :update]

  def update
    perm_group = PermissionGroup.find_by(name: term_params[:perm_group])
    if @term.update(term_params)
      @term.permission_group = perm_group
      @term.save
      render status: response.code, json: response.body
      head :ok
    end
  end

  def create
    @term = Term.new(term_params) 
    # @term.permission_group =  PermissionGroup.new(PermissionGroup.find_by(name: params[:perm_group])) 
    if @term.save
      render status: response.code, json: response.body
      head :ok
    end
  end

  def destroy
    @term.destroy
    head :ok
  end

  def show
    @permission_groups = PermissionGroup.all
    # GET OFFICES
    # GET PERMISSION GROUPS
    # GET TERM
    # GET STAKEHOLDERS FOR TERM
  end

  # def search_string(search_s)
  #   if !search_s.blank?
  #     json_string = '{"query":{"match": {"_all": {"query": "' + "#{search_s}" +'","operator": "and" }}},"size":"999","sort":[{"name":{"order":"asc"}}]}'
  #     #2json_string ='{"query":{"multi_match":{"query": "*' + "#{search_s}" +'*","fields":["name^3","definition"],"type":"phrase","zero_terms_query": "none"}},"from":"0","size":"999","highlight": { "pre_tags": ["<FONT style=\"BACKGROUND-COLOR:yellow\">"],"post_tags": ["</FONT>"],"fields" : {"name" :{},"definition" :{}}}}'
  #     #1json_string = '{"query":{"query_string": {"query": "*' + "#{search_s}" +'*","fields":["name","definition"],"highlight": { "fields": { "name": {}}}}},"sort":[{"name.raw":{"order":"asc"}}],"from":"0","size":"999"}'
  #   else
  #     json_string = '{"query":{"match_all":{}},"from":"0","size":"999"}'
  #   end
  #     #json_string = '{"query":{"query_string": {"query": "*' + "#{search_s}" +'*","fields":["name","definition"],"highlight": {"fields": {"name": {"fragment_size" : 150,"number_of_fragments": 5}}},,"sort":[{"name.raw":{"order":"asc"}}],"from":"0","size":"999"}'
  #     muninn_response_render(json_string)
  # end

  # def index
  #   @terms = Term.all
  
  #  page =params[:page]
  #  if params.has_key?(:tags)
  #   search_s = params[:tags][:search1]

  #   json_string = Muninn::CustomSearchAdapter.create_search_string(search_s)
  #   @results  = Muninn::CustomSearchAdapter.custom_query(json_string, params[:page], 15, session[:cas_user], session[:cas_pgt] )

  #  else
  #   json_string = '{"query":{"match_all":{}}, "facets": {"tags":{ "terms" : {"field" : "_type"}}},"from":"0","size":"999"}'
  #   @results = Muninn::CustomSearchAdapter.custom_query(json_string, params[:page], 15, session[:cas_user], session[:cas_pgt] )

  #  end
  #   @results_count = @results.select { |k| "#{k[:type]}" =="count"}
  #   @results_hash = {}
  #   @results_count.each do |hash|
  #      @results_hash[hash["term"]] = hash["count"]
  #   end
  #   @results = @results.select { |k| "#{k[:type]}" =="term"}
  #   @results = @results.sort_by { |k| "#{k[:sort_name]}"}
  #   @results = @results.paginate(:page=> page, :per_page => 15)
     
  # end

  # def partial_search
  #   page =params[:page]
  #   json_string = Muninn::CustomSearchAdapter.create_search_string( params[:q], session[:cas_user], session[:cas_pgt] )
  #   @results  = Muninn::CustomSearchAdapter.custom_query(json_string, params[:page], 15, session[:cas_user], session[:cas_pgt] )
  #   @results_count = @results.select { |k| "#{k[:type]}" =="count"}
  #   @results_count = @results_count[0][:totalcount]
  #   @results_hash = {}
  #   @results_count.each do |hash|
  #      @results_hash[hash["term"]] = hash["count"]
  #   end

  #   @results = @results.select { |k| "#{k[:type]}" =="term"}
  #   @results = @results.sort_by { |k| "#{k[:sort_name]}"}
  #   @results =@results.paginate(:page=> page, :per_page => 15)
  #   respond_to do |format|
  #     format.json {render :json => @results, layout: false}
  #     format.html {render partial: "partial_search", layout: false }
  #   end
  # end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_term
    @term = Term.find_by(name: params[:id])
  end

  def term_params
    params.require(:term).permit(
      :name,
      :definition,
      :source_system,
      :possible_values,
      :notes,
      :data_availability,
      :sensitivity_classification,
      :access_designation,
      :sensitivity_access_notes,
      :permission_group,
      :perm_group)
  end
end
