class TicketSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :created_at, :updated_at

  def created_at
    object.created_at.strftime('%d %B %Y %H:%M')
  end

  def updated_at
    object.updated_at.strftime('%d %B %Y %H:%M')
  end
end
