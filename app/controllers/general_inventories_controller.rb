class GeneralInventoriesController < ApplicationController
    
    def index
        @items = GeneralInventory.where("current_quantity > ? and voided = ? ", 0, false)
        @aboutToExpire = GeneralInventory.aboutToExpire_items.length
        #@underStocked = underStocked.length
        @expired = GeneralInventory.expired_items.length
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
            flash[:success] = {title: "Inventory Item Added", message: "#{params[:general_inventory][:name]} was successfully added to inventory."}
            print_and_redirect("/general_inventories/print/#{new_item.bottle_id}", "/general_inventories")
        else
            flash[:errors] = {title: "Failed to Create Record", message: new_item.errors}
            redirect_to "/general_inventories"
        end
    end

    def edit
        @item = GeneralInventory.find(params[:id])
        @mfns = Manufacturer.select(["mfn_id", "name"])
        respond_to do |format|
          format.js {render layout: false}
          format.html { render 'edit'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def update
        
        item = GeneralInventory.find(params[:id])
        if item.blank?
            flash[:errors] = {title: "Failed to Update Record", message: "Item could not be found"}
        else
            item.lot_number = params[:general_inventory][:lot_number].upcase
            item.expiration_date = params[:general_inventory][:expiration_date].to_date rescue nil
            item.received_quantity = params[:general_inventory][:received_quantity].to_i + (item.received_quantity - item.current_quantity)
            item.current_quantity = params[:general_inventory][:received_quantity].to_i
            item.mfn_id = params[:general_inventory][:manufacturer]
            item.save
            if item.errors.blank?
                flash[:success] = {title: "Successfully deleted record", message: "#{item.drug_name} #{item.lot_number} was successfully deleted."}
                news = News.where("refers_to = ? AND resolved = ?", item.bottle_id, false).update({
                    :resolved => true,
                    :resolution => "Item was voided",
                    :date_resolved => Date.today
                })
            else
                flash[:errors] = {title: "Failed to Update Record", message: "Item could not be found"}
            end
            #logger.info "#{current_user.username} voided general inventory item #{params[:general_inventory][:gn_id]}"
        end

        redirect_to "/general_inventories"
    end

    def delete
        @item = GeneralInventory.find(params[:id])
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'delete'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end

    def destroy
        item = GeneralInventory.where(:gn_identifier => params[:id]).update(gn_params)
        if item.blank?
            flash[:errors] = {title: "Failed to Delete Record", message: "Item with bottle id #{params[:id]} could not be found"}
        else
            flash[:success] = {title: "Successfully deleted record", message: "#{item.first.drug_name} #{item.first.lot_number} was successfully deleted."}
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
