require 'rails_helper'

RSpec.feature "UserCanViewPastOrders", type: :feature do
  scenario "they can see past orders as a logged in user" do
    user = User.create(username: "someguy", password: "password")
    order = user.orders.create(status: "ordered")

    visit login_path
    fill_in "Username", with: "someguy"
    fill_in "Password", with: "password"
    click_button "Login"

    expect(page).to have_content("Welcome, someguy")

    visit orders_path

    expect(page).to have_content("Past Orders")
    expect(page).to have_content(order.id)
  end

  scenario "they are redirected to login page if they are not logged in" do
    visit orders_path

    expect(page).to have_no_content("Past Orders")
    expect(page).to have_content("Please log in or create an account.")
  end

  scenario "they can view a past order with order details" do
    category = Category.create(name: "Big Cats")
    tiger = category.animals.create(id: "1", name: "Tiger", description: "Stalker in the night", price: 3000, image_path: "http://wildaid.org/sites/default/files/photos/iStock_000008484745Large%20%20tiger%20-%20bengal.jpg")
    lion = category.animals.create(id: "2", name: "Lion", description: "Lazy during the day", price: 7000, image_path: "http://wildaid.org/sites/default/files/photos/iStock_000008484745Large%20%20tiger%20-%20bengal.jpg")
    user = User.create(username: "someguy", password: "password")

    visit "/animals/#{tiger.id}"
    click_on "Add to Cart"
    visit cart_path
    click_on "+"

    expect(page).to have_content('6,000')

    visit "/animals/#{lion.id}"
    click_on "Add to Cart"
    visit cart_path

    expect(page).to have_content('7,000')
    expect(page).to have_content('13,000')

    click_on "Login or Create Account to Checkout"
    fill_in "Username", with: "someguy"
    fill_in "Password", with: "password"
    click_button "Login"
    click_on "Checkout"

    order = Order.last

    expect(page).to have_content(order.id)
    expect(page).to have_content("All Orders")
    expect(current_path).to eq(order_path(order))
    expect(page).to have_content(order.status)
    expect(page).to have_content("Tiger")
    expect(page).to have_content("2")
    expect(page).to have_content('6,000')
    expect(page).to have_content("1")
    expect(page).to have_content("Lion")
    expect(page).to have_content('7,000')
    expect(page).to have_content("Total")
    expect(page).to have_content('13,000')
    expect(page).to have_content(order.created_at)
  end
end
