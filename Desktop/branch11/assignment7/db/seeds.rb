# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Post.destroy_all
User.destroy_all

(1..5).to_a.each do |p|
  User.create(password:"#{p}",name:"#{p}",email:"#{p}")
end

(1..5).to_a.each do |p|
  User.find(p).posts.create(msg:"#{p}")
end
