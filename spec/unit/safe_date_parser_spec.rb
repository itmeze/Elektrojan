#encoding: utf-8
require 'spec_helper'
require 'components/safe_date_parser'

describe 'safe date parser' do

  it 'correctly parses date' do
    parser = SafeDateParser.new ['%d.%m.%Y']

    dt = parser.parse('10.12.2034')

    dt.should_not be_nil
    dt.month.should == 12
    dt.day.should == 10
    dt.year.should == 2034
  end

  it 'correctly parses date from th secind option' do
    parser = SafeDateParser.new ['%d.%m.%Y', '%d/%m/%Y']

    dt = parser.parse('10/12/2034')

    dt.should_not be_nil
    dt.month.should == 12
    dt.day.should == 10
    dt.year.should == 2034
  end

  it 'returns nil if invalid' do
    parser = SafeDateParser.new ['%d.%m.%Y', '%d/%m/%Y']

    dt = parser.parse('10/12.2034')

    dt.should be_nil
  end
end
