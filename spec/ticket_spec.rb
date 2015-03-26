require './ticket'
fd = Ticket.new ENV['FRESHDESK_API_KEY']

describe 'Freshdesk  tickets' do
  it 'should return number of open tickets' do
    expect(fd.open_count.inspect).to be_a(Fixnum)
  end
end
