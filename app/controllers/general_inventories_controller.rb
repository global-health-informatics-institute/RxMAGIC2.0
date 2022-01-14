class GeneralInventoriesController < ApplicationController
    

    def index
        @items = GeneralInventory.where("current_quantity > ? and voided = ? ", 0, false)
        #@aboutToExpire = aboutToExpire_items.length
        #@underStocked = underStocked.length
        #@expired = expired_items.length
        #@wellStocked = wellStocked.length
    end

    def new
        @mfns = Manufacturer.select(["mfn_id", "name"])
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'edit'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end
    
    def create
        new_item = GeneralInventory.create(gn_params)
        if new_item.errors.blank?
            flash[:success] = "#{params[:general_inventory][:name]} was successfully added to inventory."
            print_and_redirect("/general_inventories/print/#{new_item.bottle_id}", "/general_inventories")
        else
            flash[:errors] = new_item.errors
            redirect_to "/general_inventories"
        end
    end

    def edit
        @item = GeneralInventory.find(params[:id])
        @mfns = Manufacturer.select(["manufacturer_id", "name"])
        respond_to do |format|
          format.js {render layout: false}
          format.html { render 'edit'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def update
    end

    def delete
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'delete'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def destroy
        item = GeneralInventory.where(:gn_inventory_id => params[:id]).update(gn_params)
        if item.blank?
            flash[:errors] = ["Item with bottle id #{params[:general_inventory][:gn_id]} could not be found"]
        else
            flash[:success] = "#{item.first.drug_name} #{item.first.lot_number} was successfully deleted."
            news = News.where("refers_to = ? AND resolved = ?", item.first.bottle_id, false).update({
                :resolved => true,
                :resolution => "Item was voided",
                :date_resolved => Date.today
            })
            #logger.info "#{current_user.username} voided general inventory item #{params[:general_inventory][:gn_id]}"
        end

        redirect_to "/general_inventories"
    end
    
    def print
        entry = GeneralInventory.where("gn_identifier = ?", params[:id]).first 
        print_string = entry.create_bottle_label(entry.drug_name,params[:id],entry.expiration_date,entry.lot_number,"General", nil)
        send_data(print_string,:type=>"application/label; charset=utf-8", :stream=> true, :filename=>"#{entry.lot_number}#{rand(10000)}.lbl", :disposition => "inline")
        
    end  

    private

    def gn_params
      params.require(:general_inventory).permit(:voided_by,:void_reason, :voided,:rxaui, :mfn_id,:name, :lot_number, :expiration_date, :date_received, :received_quantity, :gn_inventory_id)
    end
end
