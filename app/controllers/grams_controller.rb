class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def destroy 
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) if @gram.user != current_user
    if @gram.user != current_user
      return render plain: 'Forbidden', status: :Forbidden
    end
    @gram.destroy
    redirect_to root_path
  end

  def new
    @gram = Gram.new
  end

  def update
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) if @gram.user != current_user

    if @gram.user != current_user
      return render plain: 'Forbidden :(', status: :Forbidden
    end

    @gram.update_attributes(gram_params)
    
    if @gram.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def index
    @grams = Gram.all
  end

  def show
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_not_found(:forbidden) if @gram.user != current_user
  end

  def edit
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    if @gram.user != current_user
      render plain: 'Forbidden :(', status: :Forbidden
    end
  end

  def create 
    @gram = current_user.grams.create(gram_params)
    if @gram.valid?
      redirect_to root_path
    else 
      render :new, status: :unprocessable_entity
    end
  end

  private 

  def gram_params
    params.require(:gram).permit(:message, :picture)
  end
end
