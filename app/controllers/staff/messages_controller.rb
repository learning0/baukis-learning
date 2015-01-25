class Staff::MessagesController < ApplicationController
  before_action :reject_non_xhr, only: [ :count ]
  
  # GET
  def count
    render text: CustomerMessage.unprocessed.count
  end
end
