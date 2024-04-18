class TicketsController < ApplicationController
  before_action :authorize_request
  before_action :set_ticket, only: [:show, :update, :destroy]

  def index
    query = params[:search]
    @tickets = query.present? ? query_search(query) : current_user.tickets

    render json: @tickets
  end

  def show
    render json: @ticket
  end

  def create
    @ticket = current_user.tickets.new(ticket_params)

    if @ticket.save
      render json: @ticket, status: :created
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  def update
    if @ticket.update(ticket_params)
      render json: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket.destroy
  end

  private

  def query_search(query)
    search_query = {
      query: {
        bool: {
          must: [
            { match: { user_id: current_user.id } },
            {
              bool: {
                should: [
                  { match_phrase: { title: query } },
                  { match_phrase: { description: query } },
                  { match: { status: query } }
                ]
              }
            }
          ]
        }
      }
    }

    Ticket.search(search_query).records
  end

  def set_ticket
    @ticket = current_user.tickets.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :status)
  end
end
