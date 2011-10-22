#encoding: utf-8
require 'spec_helper'
require 'ruby-debug'
#require 'rack/test'

describe AdminController do

  def visit_with_credentials path
    get path, nil, { 'HTTP_AUTHORIZATION' => valid_credentials}
  end

  def post_with_credentials(path, param_data=nil)
    post path, param_data, { 'HTTP_AUTHORIZATION' => valid_credentials}
  end

  def delete_with_credentials path, param_data=nil
    delete path, param_data, { 'HTTP_AUTHORIZATION' => valid_credentials}
  end

  def valid_credentials
    ActionController::HttpAuthentication::Basic.encode_credentials MyConfiguration.admin_username, MyConfiguration.admin_password
  end

  before(:each) do
  end

  it 'prevents entrance for unauthenticated user' do
    get '/admin'
    response.status.should == 401
  end

  it 'saves facotry item', :focus => true do
    Factory(:order)

    Order.all.size.should == 1
  end

  it 'displays the form' do
    visit_with_credentials '/admin'
    response.body.should have_content('Wyświetl rekordy typu')
    #making sure it has a selector
    response.body.should have_selector('form input')
    #making sure all results are on the page
    response.body.should have_selector("form select[name='type']")
  end

  it 'shows recent results when search' do
    8.times { Factory.create(:order) }
    5.times { Factory.create(:report) }
    1.times { Factory.create(:preport) }

    visit_with_credentials '/admin/search'

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

    visit_with_credentials 'admin/search'

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

    visit_with_credentials 'admin/search?q=artweger'

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

    visit_with_credentials 'admin/search?q=artweger&type=order'

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

    visit_with_credentials "admin/search?q=artweger&from=#{current_time}"

    assigns(:elements).size.should == 2
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should_not be_nil

    visit_with_credentials "admin/search?q=artweger&to=#{current_time}"

    assigns(:elements).size.should == 2
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should be_nil

    visit_with_credentials "admin/search?q=artweger&from=#{current_time}&to=#{day_after_tomorrow}"

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

    visit_with_credentials "admin/search?q=artweger&from=#{current_time}"

    assigns(:elements).size.should == 2
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should_not be_nil

    visit_with_credentials "admin/search?q=artweger&to=#{current_time}"

    assigns(:elements).size.should == 2
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should be_nil

    visit_with_credentials "admin/search?q=artweger&from=#{current_time}&to=#{day_after_tomorrow}"

    assigns(:elements).size.should == 1
    assigns(:elements).find { |oe| oe.id == order1.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == order2.id && oe.instance_of?(Order) }.should be_nil
    assigns(:elements).find { |oe| oe.id == guarantee1.id && oe.instance_of?(Guaranteereport) }.should_not be_nil
    assigns(:elements).find { |oe| oe.id == pguatantee1.id && oe.instance_of?(Postguaranteereport) }.should be_nil
  end

  it 'shows message when item not found' do
    Factory(:order, :name => 'searched artweger test', :created_at => 2.days.ago)

    visit_with_credentials '/admin/details?type=guaranteereport&id=12'

    assigns(:element).should be_nil

    response.body.should have_content('Nie znaleziono')
  end

  it 'displays the element when found and shows add/edit comment form' do
    order = Factory(:order, :id => 12, :name => 'searched artweger test', :created_at => 2.days.ago)

    visit_with_credentials '/admin/details/12?type=order'
    assigns(:element).should_not be_nil

    response.body.should have_content(order.name)
    response.body.should have_selector('form')

    report = Factory(:report, :id => 19, :name => 'simple guarantee report', :created_at => 1.day.ago)

    visit_with_credentials '/admin/details/19?type=guaranteereport'

    assigns(:element).should_not be_nil
    response.body.should have_content(report.name)

    preport = Factory(:preport, :id => 21, :name => 'simple guarantee report', :created_at => 1.day.ago)

    visit_with_credentials '/admin/details/21?type=postguaranteereport'

    assigns(:element).should_not be_nil
    response.body.should have_content(preport.name)

  end

  it 'removes selected element' do
    Factory(:order, :id => 12, :name => 'searched artweger test', :created_at => 2.days.ago)

    Order.where(:id => 12).first.should_not be_nil

    delete_with_credentials 'admin/delete/12?type=order'

    Order.where(:id => 12).first.should be_nil
    flash[:notice].should =~ /Rekord usunięty/
  end

  it 'edits comment for element' do
    Factory(:report, :id => 121, :name => 'whatever', :created_at => 4.days.ago)

    comment = 'this is my comment'
    post_with_credentials '/admin/add_comment/121?type=guaranteereport', { :comment => comment }

    content = /Komentarz dodany poprawnie/

    flash[:notice].should =~ content
    response.should redirect_to({ :action => 'details', :id => 121, :type => 'guaranteereport' })

    report = Guaranteereport.where(:id => 121).first
    report.id.should == 121
    report.comment.should == comment

  end
end
