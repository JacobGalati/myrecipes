require 'test_helper'

class ChefsTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Jacob", email: "jacob@test.com",
                        password: 'password', password_confirmation: 'password')
    @chef2 = Chef.create!(chefname: "Frank", email: "frank@test.com",
                          password: 'passwords', password_confirmation: 'passwords')
  end  
  
  test "should get chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef), @chef.chefname
    assert_select "a[href=?]", chef_path(@chef2), @chef2.chefname
  end
end
