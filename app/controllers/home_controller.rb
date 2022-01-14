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
  
end
