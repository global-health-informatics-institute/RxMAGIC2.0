class GeneralInventoriesController < ApplicationController
    

    def index
        @items = GeneralInventory.where("current_quantity > 0")
        #@aboutToExpire = aboutToExpire_items.length
        #@underStocked = underStocked.length
        #@expired = expired_items.length
        #@wellStocked = wellStocked.length
    end

    def edit
        @item = GeneralInventory.find(params[:id])
       # @mfns = Manufacturer.select(["manufacturer_id", "name"])
        respond_to do |format|
          format.js {render layout: false}
          format.html { render 'edit'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def new
       @drug_names = Rxnconso.where("TTY in ('SBD', 'SCD')")
       # @mfns = Manufacturer.select(["manufacturer_id", "name"])
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'edit'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end
    

    def print
        
        entry = GeneralInventory.where("gn_identifier = ?", params[:id]).first 
        print_string = entry.create_bottle_label(entry.drug_name,params[:id],entry.expiration_date,entry.lot_number,"General", nil)
        send_data(print_string,:type=>"application/label; charset=utf-8", :stream=> true, :filename=>"#{entry.lot_number}#{rand(10000)}.lbl", :disposition => "inline")
        
    end

    def delete
    end

    def create
    end

    def update
    end

    def mfn_suggestions

        @companies = Manufacturer.where("name like ? ", "#{params[:term]}%").limit(10).collect{|x| x.name.humanize.gsub(/\b('?[a-z])/) { $1.capitalize }}
    
        render :text => @companies
    end
end
