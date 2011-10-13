#encoding: utf-8
require 'spec_helper'

describe 'order page' do

  it 'displays the order form' do
    visit '/zamow-czesci'
    page.should have_content('Aby')
  end

  it 'displays the order form element' do
    visit '/zamow-czesci'
    page.should have_content('form')
  end

  it 'displays captcha depending on configuration' do
    MyConfiguration.display_captcha = true

    visit '/zamow-czesci'

    page.should have_selector('div#recaptcha_image')

    MyConfiguration.display_captcha = false

    visit 'zamow-czesci'

    page.should_not have_selector('#recaptcha_image')
  end

  it 'displays hidden field protection depending on configuration' do
    MyConfiguration.display_spam_hidden_field = true
    MyConfiguration.spam_hidden_field_name = 'nick_name'
    visit '/zamow-czesci'

    page.should have_selector('input[name=nick_name]')

    MyConfiguration.display_spam_hidden_field = false

    visit '/zamow-czesci'

    page.should_not have_selector('input[name=nick_name]')
  end

  it 'validates spam hiden field if configured' do
    spam_field_name = 'hutnik'

    MyConfiguration.display_captcha = false
    MyConfiguration.display_spam_hidden_field = true
    MyConfiguration.spam_hidden_field_name = spam_field_name

    order_count = Order.count

    visit '/zamow-czesci'

    page.should have_selector("input[name=#{spam_field_name}]")

    fill_in 'order[name]', :with => 'moje imie'
    fill_in 'order[address]', :with => 'moj adres'
    fill_in 'order[phone]', :with => 'moj numer telefonu'
    fill_in 'order[email]', :with => 'moj@numer.te'
    select 'Duschy', :from => 'order[producer]'
    fill_in 'order[product_name]', :with => 'Duschy whatever'
    fill_in 'order[order_description]', :with => 'opis krotki...'

    #critical part
    fill_in spam_field_name, :with => 'i am a spam!!'

    #clicking submit button
    page.find('form input[type=submit]').click

    Order.count.should == order_count

    page.should have_selector "body"
    page.should have_selector "input[name=#{spam_field_name}]"

    #now following 'good' pattern
    visit '/zamow-czesci'

    page.should have_selector("input[name=#{spam_field_name}]")

    fill_in 'order[name]', :with => 'moje imie'
    fill_in 'order[address]', :with => 'moj adres'
    fill_in 'order[phone]', :with => 'moj numer telefonu'
    fill_in 'order[email]', :with => 'moj@numer.te'
    select 'Duschy', :from => 'order[producer]'
    fill_in 'order[product_name]', :with => 'Duschy whatever'
    fill_in 'order[order_description]', :with => 'opis krotki...'

    #critical part

    page.find('form input[type=submit]').click

    Order.count.should == (order_count + 1)
    page.should have_selector "body"
    page.should_not have_selector "input[name=#{spam_field_name}]"

  end
end
