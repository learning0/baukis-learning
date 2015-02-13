module ApplicationHelper
  include HtmlBuilder
  
  def document_title
    if @title.present?
      "#{@title} - Baukis"
    else
      'Baukis'
    end
  end
  
  def current_staff_member
    if session[:staff_member_id]
      @current_staff_member ||= 
      StaffMember.find_by(id: session[:staff_member_id])
    end
  end
  
  def current_customer
    if customer_id = cookies.signed[:customer_id] || session[:customer_id]
      @current_customer ||=
        Customer.find_by(id: customer_id)
    end
  end
  
end
