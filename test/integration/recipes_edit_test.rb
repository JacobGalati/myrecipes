require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Jacob", email: "jacob@test.com",
                        password: 'password', password_confirmation: 'password')
    @recipe = Recipe.create(name: "Veggies and Beef", description: "lots of beef and a bit of veggies", chef: @chef)
  end
  
  test "reject invalid recipe update" do
    sign_in_as(@chef, "password")
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: { recipe: { name: " ", description: "some description" } }
    assert_template 'recipes/edit'
    assert_select 'h2.card-title'
    assert_select 'div.card-body'
  end
  
  test "successfully edit a recipe" do
    sign_in_as(@chef, "password")
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    updated_name = "Chicken and Beef"
    updated_description = "Yum Yum Yum"
    patch recipe_path(@recipe), params: { recipe: { name: updated_name, description: updated_description } }
    assert_redirected_to @recipe
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end
end
