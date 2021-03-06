class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :like]
  before_action :require_user, except: [:index, :show, :like]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def new
    @recipe = Recipe.new
  end  
  
  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    @comment = Comment.new
    @comments = @recipe.comments.paginate(page: params[:page], per_page: 5)
    @current_chef = current_chef
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = current_chef
    if @recipe.save
      flash[:success] = "Recipe was created successfully!"
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end
  
  def edit

  end
  
  def update

    if @recipe.update(recipe_params)
      flash[:success] = "Recipe was updated successfully"
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end
  
  def destroy
    Recipe.find(params[:id]).destroy
    flash[:success] = "Recipe deleted successfully"
    redirect_to recipes_path
  end

  def like
    @like = Like.find_by(chef: current_chef, recipe: @recipe)
    if @like 
      if @like.update!(like: params[:like])
        redirect_to recipe_path(@recipe)
      else
        flash.now[:danger] = "Error"
      end
    else 
      @like = Like.new(like: params[:like], chef: current_chef, recipe: @recipe)      
      if @like.save
        redirect_to recipe_path(@recipe)
      else
        flash[:danger] = "You must be logged in to do that"
        redirect_to recipe_path(@recipe)
      end
    end
  end
  
  private
    def require_same_user
      if current_chef != @recipe.chef and !current_chef.admin?
        flash[:danger] = "You can only edit or delete your own recipes"
        redirect_to recipes_path
      end
    end
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
    
    def recipe_params
      params.require(:recipe).permit(:name, :description, :image, ingredient_ids: [])
    end

end