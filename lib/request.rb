require './database_connection_setup'
require_relative 'database_connection'

class Request

  attr_reader :id, :date, :guest_id, :space_id, :approved

  def initialize(id, date, guest_id, space_id)
    @id = id
    @date = date
    @guest_id = guest_id
    @space_id = space_id
    @approved = 0
  end

  def self.create(date, guest_id, space_id)
    DatabaseConnection.setup('airbnb_test')

    result = DatabaseConnection.query("INSERT INTO bookings (date, guest_id, space_id, approved) VALUES ('#{date}', '#{guest_id}', '#{space_id}', '0') RETURNING id;") #the BIT data type allows us to use 1 for true and 0 for false.
    Request.new(result[0]['id'], date, guest_id, space_id)
  end
end