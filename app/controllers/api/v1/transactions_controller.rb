module Api
  module V1

class TransactionsController < ApplicationController

  def index
    if logged_in?
      render json: @current_user.transactions.order(day: :desc).to_json
    end
  end

# params[:transaction][:month].to_i

  def create
    if logged_in?
      value = transaction_params[:value].to_f
      transaction = Transaction.new(name: transaction_params[:name], day: transaction_params[:day], value: value,  expense_id: transaction_params[:expense_id])
      transaction.user = current_user
      transaction.save

      selected_month = (params[:transaction][:month].to_i + 1)
      user_transaction = Transaction.where(user_id: @current_user)
      transactions_month = user_transaction.where('day >= ? AND day <= ?', DateTime.new(2017,selected_month,1).beginning_of_month, DateTime.new(2017,selected_month,1).end_of_month)

      render json: transactions_month.order(day: :desc).to_json
    end
  end

  def update
    if logged_in?
      value = transaction_params[:value].to_f
      transaction = Transaction.find(transaction_params[:id])
      transaction.update(name: transaction_params[:name], day: transaction_params[:day], value: value, expense_id: transaction_params[:expense_id])
      transaction.save


      selected_month = (params[:transaction][:month].to_i + 1)
      user_transaction = Transaction.where(user_id: @current_user)
      transactions_month = user_transaction.where('day >= ? AND day <= ?', DateTime.new(2017,selected_month,1).beginning_of_month, DateTime.new(2017,selected_month,1).end_of_month)

      render json: transactions_month.order(day: :desc).to_json
    end
  end

  def delete
    if logged_in?
      transaction = Transaction.find(params[:transaction][:id])
      transaction.destroy

      selected_month = (params[:transaction][:month].to_i + 1)
      user_transaction = Transaction.where(user_id: @current_user)
      transactions_month = user_transaction.where('day >= ? AND day <= ?', DateTime.new(2017,selected_month,1).beginning_of_month, DateTime.new(2017,selected_month,1).end_of_month)

      render json: transactions_month.order(day: :desc).to_json
    end
  end

  def month
    if logged_in?
      selected_month = (params[:month_id].to_i + 1)
      transaction = Transaction.where(user_id: @current_user)
      transactions = transaction.where('day >= ? AND day <= ?', DateTime.new(2017,selected_month,1).beginning_of_month, DateTime.new(2017,selected_month,1).end_of_month)
      render json: transactions.order(day: :desc).to_json
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :value, :day, :id, :expense_id, :month)
  end

end

  end
end
