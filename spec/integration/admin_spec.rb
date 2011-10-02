#encoding: utf-8
require 'spec_helper'
require 'ruby-debug'

describe 'admin page' do
  it 'saves facotry item', :focus => true do
    Factory(:order)

    Order.all.size.should == 1
  end

  it 'displays the form' do
    visit '/admin'
    page.should have_content('Wyświetl rekordy typu')
    #making sure it has a selector
    page.should have_selector('form input')
    #making sure all results are on the page

  end

  it 'shows recent results when search' do
    8.times { Factory.create(:order) }
    5.times { Factory.create(:report) }
    1.times { Factory.create(:preport) }

    get '/admin/search'

    Order.all.size.should == 8
    Guaranteereport.all.size.should == 5
    Postguaranteereport.all.size.should == 1

    assigns(:elements).should_not be_nil
    assigns(:elements).size.should == 14
    response.should be_success
  end

  it 'shows up to 20 results based on creation date' do
    i = 1
    30.times do
      i += 1
      Factory(:order, :created_at => i.hours.ago)
    end

    get 'admin/search'

    Order.all.size.should == 30

    @recent = Order.order('created_at desc').limit(20)

    assigns(:elements).should_not be_nil
    assigns(:elements).size.should == 20

    @recent.each do |e|
      assigns(:elements).find { |ce| ce.id == e.id }.should_not be_nil
    end
  end

  it 'shows elements that match search criteria' do
    order1 = Factory(:order, :name => 'searched artweger test')
    order2 = Factory(:order, :producer => 'artweger')
    order3 = Factory(:order, :order_description => 'suszarka artweger')
    order4 = Factory(:order, :order_description => 'brak firmy')

    get 'admin/search?q=artweger'

    assigns(:elements).size.should == 3
    assigns(:elements).find { |oe| oe.id == order1.id }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == order2.id }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == order3.id }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == order4.id }.should be_nil
  end

  it 'shows elements that match search and type' do
    order1 = Factory(:order, :name => 'searched artweger test')
    order2 = Factory(:order, :producer => 'artweger')
    guarantee1 = Factory(:report, :description => 'suszarka artweger')
    pguatantee1 = Factory(:preport, :description => 'costam artweger')

    get 'admin/search?q=artweger&type=order'

    assigns(:elements).size.should == 2
    assigns(:elements).find { |oe| oe.id == order1.id }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == order1.id }.should be_an(Order)

    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should be_nil
  end

  it 'shows elements filtered by date' do
    current_time = Time.now.strftime("%d/%m/%Y")
    day_after_tomorrow = 2.days.since.strftime('%d/%m/%Y')

    order1 = Factory(:order, :name => 'searched artweger test', :created_at => 2.days.ago)
    order2 = Factory(:order, :producer => 'artweger', :created_at => 1.day.ago)
    guarantee1 = Factory(:report, :description => 'suszarka artweger', :created_at => 1.day.since)
    pguatantee1 = Factory(:preport, :description => 'costam artweger', :created_at => 3.days.since)

    get "admin/search?q=artweger&from=#{current_time}"

    assigns(:elements).size.should == 2
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should_not be_nil

    get "admin/search?q=artweger&to=#{current_time}"

    assigns(:elements).size.should == 2
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should be_nil

    get "admin/search?q=artweger&from=#{current_time}&to=#{day_after_tomorrow}"

    assigns(:elements).size.should == 1
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should be_nil

  end

  it 'shows elements filtered by date in polish format as well' do
    current_time = Time.now.strftime("%d.%m.%Y")
    day_after_tomorrow = 2.days.since.strftime('%d.%m.%Y')

    order1 = Factory(:order, :name => 'searched artweger test', :created_at => 2.days.ago)
    order2 = Factory(:order, :producer => 'artweger', :created_at => 1.day.ago)
    guarantee1 = Factory(:report, :description => 'suszarka artweger', :created_at => 1.day.since)
    pguatantee1 = Factory(:preport, :description => 'costam artweger', :created_at => 3.days.since)

    get "admin/search?q=artweger&from=#{current_time}"

    assigns(:elements).size.should == 2
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should_not be_nil

    get "admin/search?q=artweger&to=#{current_time}"

    assigns(:elements).size.should == 2
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should be_nil

    get "admin/search?q=artweger&from=#{current_time}&to=#{day_after_tomorrow}"

    assigns(:elements).size.should == 1
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should be_nil

 end

end
