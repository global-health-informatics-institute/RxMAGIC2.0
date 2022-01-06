class HomeController < ApplicationController
  def index
  end

  def dashboard
  end

  def about
  end

  def contact
    @item = GeneralInventory.last
  end

  def faq
  end

end
