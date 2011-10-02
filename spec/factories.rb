FactoryGirl.define do
  factory :order do
    sequence :name do |n|
      'tester#{n}'
    end
    address 'ciagle ten sam'
    phone 'ten same'
    producer 'Duschy'
    product_name 'nazwa produktu - ta sama'
    order_description 'jak to desc'
    sequence :email do |n|
      'test#{n}@gmail.com'
    end
    created_at Time.now
    updated_at Time.now
  end

  factory :report, :class => 'Guaranteereport' do
    sequence :name do |n|
      'tester#{n}'
    end
    address 'ciagle ten sam'
    phone 'ten same'
    producer 'Duschy'
    purchase_date 'ta sama'
    purchase_place 'to samo'
    sequence :purchase_id do |n|
      'id #{n}'
    end
    sequence :purchase_guarantee_id do |n|
      'guarantee id #{n}'
    end
    rodzaj 'zwykly'
    pin 'jak to pin'
    description 'jak to desc'
    sequence :email do |n|
      'test#{n}@gmail.com'
    end
    created_at Time.now
    updated_at Time.now
  end

  factory :preport, :class => 'Postguaranteereport' do
    sequence :name do |n|
      'tester#{n}'
    end
    address 'ciagle ten sam'
    phone 'ten same'
    producer 'Duschy'
    rodzaj 'zwykly'
    description 'jak to desc'
    sequence :email do |n|
      'test#{n}@gmail.com'
    end
    created_at Time.now
    updated_at Time.now

  end

end
