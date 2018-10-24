require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Jacob", email: "jacob@test.com")
    @recipe = Recipe.create(name: "Veggies and Beef", description: "lots of beef and a bit of veggies", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "Chicken and Rice", description: "Lots of chicken and a bit of rice")
    @recipe2.save
  end
  
  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end
  
  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end
end
