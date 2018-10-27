require 'test_helper'

class ChefsTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Jacob", email: "jacob@test.com",
                        password: 'password', password_confirmation: 'password')
    @chef2 = Chef.create!(chefname: "Frank", email: "frank@test.com",
                          password: 'passwords', password_confirmation: 'passwords')
    @admin_user = Chef.create!(chefname: "Frank1", email: "frank1@test.com",
                              password: 'passwords', password_confirmation: 'passwords', admin: true)                          
  end  
  
  test "should get chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef), @chef.chefname
    assert_select "a[href=?]", chef_path(@chef2), @chef2.chefname
  end
  
  test "should delete chef" do
    sign_in_as(@admin_user, "passwords")
    get chefs_path
    assert_template 'chefs/index'
    assert_difference 'Chef.count', -1 do
      delete chef_path(@chef2)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
end
