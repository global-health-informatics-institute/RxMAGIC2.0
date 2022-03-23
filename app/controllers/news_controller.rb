class NewsController < ApplicationController
    def destroy
        news_item = News.where(:news_id => params[:id]).update(:resolved => true,:resolution => "Ignored",:date_resolved => Date.today)
        if news_item.blank?
            flash[:errors] = {title: "Failed to Delete Alert", message: "News alert could not be found"}
        else
            flash[:success] = {title: "Successfully deleted record", message: "News item was successfully deleted."}
            #logger.info "#{current_user.username} voided general inventory item #{params[:general_inventory][:gn_id]}"
        end
        redirect_to "/"
    end

    def delete
        @news = News.find(params[:id])
        respond_to do |format|
            format.js {render layout: false}
            format.html { render 'delete'} # I had to tell rails to use the index by default if it's a html request. 
        end
    end
end
