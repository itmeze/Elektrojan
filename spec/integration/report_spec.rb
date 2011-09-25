#encoding: utf-8
require 'spec_helper'

describe 'report page' do

  it 'displays the report form' do
    visit '/serwis'
    page.should have_content('W celu zgłoszenia usterki')
  end


end
