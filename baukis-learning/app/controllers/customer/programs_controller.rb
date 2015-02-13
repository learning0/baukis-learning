class Customer::ProgramsController < ApplicationController
  def index
    @programs = Program.published.page(params[:pgae])
  end
  
  def show
    @program = Program.published.find(params[:id])
  end
end
