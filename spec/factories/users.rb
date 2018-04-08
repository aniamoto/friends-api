FactoryBot.define do
  factory :user do
    email { "#{rand(36**8).to_s(36)}@example.com" }
  end
end
