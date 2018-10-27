require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Jacob", email: "jacob@test.com",
                        password: 'password', password_confirmation: 'password')
    @chef2 = Chef.create!(chefname: "Frank", email: "frank@test.com",
                          password: 'passwords', password_confirmation: 'passwords')
    @admin_user = Chef.create!(chefname: "Frank4", email: "frank4@test.com",
                              password: 'passwords', password_confirmation: 'passwords', admin: true)
  end
  
  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "jacob@test.com" } }
    assert_template 'chefs/edit'
    assert_select 'h2.card-title'
    assert_select 'div.card-body'
  end
  
  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "Bob", email: "jacob1@test.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Bob", @chef.chefname
    assert_match "jacob1@test.com", @chef.email
  end
  
  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "passwords")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "Bob2", email: "jacob2@test.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Bob2", @chef.chefname
    assert_match "jacob2@test.com", @chef.email    
  end
  
  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, "passwords")
    updated_name = "Joe"
    updated_email = "joe@gmail.com"
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "Jacob", @chef.chefname
    assert_match "jacob@test.com", @chef.email
  end
end
