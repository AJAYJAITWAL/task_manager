class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :email, :role, :ticket_count

  def ticket_count
    object.tickets.count
  end
end
