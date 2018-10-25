require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Jacob", email: "jacob@test.com",
                        password: 'password', password_confirmation: 'password')
  end
  
  test "reject an invalid edit" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "jacob@test.com" } }
    assert_template 'chefs/edit'
    assert_select 'h2.card-title'
    assert_select 'div.card-body'
  end
  
  test "accept valid edit" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "Bob", email: "jacob1@test.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Bob", @chef.chefname
    assert_match "jacob1@test.com", @chef.email
  end
end
