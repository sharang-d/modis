$LOAD_PATH.unshift('.')
require 'benchmark/bench'

class User
  include Modis::Model

  attribute :name, :string
  attribute :age, :integer
  attribute :percentage, :float
  attribute :created_at, :timestamp
  attribute :flag, :boolean
  attribute :array, :array
  attribute :hash, :hash
  attribute :string_or_hash, [:string, :hash]

  index :name
end

def create_user
  User.create!(name: 'Test', age: 30, percentage: 50.0, created_at: Time.now,
               flag: true, array: [1, 2, 3], hash: { k: :v }, string_or_hash: "an string")
end

user = create_user

n = 10_000

Bench.run do |b|
  b.report(:find) do
    n.times do
      User.find(user.id)
    end
  end

  b.report(:where) do
    n.times do
      User.where(name: user.name)
    end
  end
end

i = 20
STDOUT.write "\n* Creating #{i} users for :where_multiple... "
STDOUT.flush
i.times { create_user }
puts "✔\n\n"

Bench.run do |b|
  b.report(:where_multiple) do
    n.times do
      User.where(name: 'Test')
    end
  end
end
