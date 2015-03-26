require 'freshdesk'
require 'xmlsimple'

class Ticket
  def initialize(api_key)
    @companyname = 'gratipay'
    @client = Freshdesk.new("http://#{@companyname}.freshdesk.com/", api_key, "X")
  end

  def open_count
    response = XmlSimple.xml_in @client.get_tickets
    response['helpdesk-ticket'].size
  end
end
