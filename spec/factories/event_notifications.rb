# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_notification do
    message "MyText"
    read false
  end
end
