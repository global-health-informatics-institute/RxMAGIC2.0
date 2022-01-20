class HomeController < ApplicationController
  def index
  end

  def dashboard
  end

  def about
  end

  def contact
    @item = GeneralInventory.last
    @mfns = Manufacturer.select(["mfn_id", "name"])
  end

  def faq
  end

  def drug_name_suggestions
    items = Rxnconso.where("STR like ? and TTY in ('PSN', 'SCD')", "#{params[:query]}%").limit(10).collect{|x| x.STR.humanize.gsub(/\b('?[a-z])/) { $1.capitalize }}.uniq
    respond_to do |format|
      format.html
      format.json {render json: items}       
    end
  end

  def provider_suggestions
    providers = Provider.where("first_name like ? OR last_name like ?", "#{params[:query]}%","#{params[:query]}%").limit(15).collect{|x| "#{x.first_name.squish rescue ''} #{x.last_name.squish  rescue ''}"}.uniq
    respond_to do |format|
      format.html
      format.json {render json: providers}       
    end
  end
  
end
