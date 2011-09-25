#encoding: utf-8
require 'spec_helper'

describe 'home page' do
  it 'displays the home page' do
    visit '/'
    page.should have_content('Od 1994')
    page.should have_content('ElektroJan')
  end

end
