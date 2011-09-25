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


end
