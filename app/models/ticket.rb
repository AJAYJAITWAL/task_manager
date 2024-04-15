class Ticket < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user

  enum status: {
    new_unassigned: 'new_unassigned',
    open_assigned: 'open_assigned',
    in_progress: 'in_progress',
    pending: 'pending',
    resolved: 'resolved',
    closed: 'closed',
    reopened: 'reopened'
  }

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
end
