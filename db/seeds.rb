# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Group.delete_all
Status.delete_all
Project.delete_all

u1 = User.create!(:email => 'maloney.liu@gmail.com', :first_name => 'Maloney', :last_name => 'Liu', :username => 'maloney', :password => 'maloney', :password_confirmation => 'maloney')
u1.confirmed_at = u1.created_at + 2.seconds

u2 = User.create!(:email => 'm@thinkmaloney.com', :first_name => 'M', :last_name => 'Baloney', :username => 'missbaloney', :password => 'maloney', :password_confirmation => 'maloney')
u2.confirmed_at = u2.created_at + 2.seconds

u3 = User.create!(:email => 'thinkmaloney@gmail.com', :first_name => 'Think', :last_name => 'Maloney', :username => 'thinkmaloney', :password => 'maloney', :password_confirmation => 'maloney')
u3.confirmed_at = u3.created_at + 3.seconds

g1 = Group.create!(:name => 'Test Group 1', :owner_id => u1.id)
g1.users << u1
g1.users << u2

g2 = Group.create!(:name => 'Test Group 2', :owner_id => u2.id)
g2.users << u2
g2.users << u3

g3 = Group.create!(:name => 'Test Group 3', :owner_id => u3.id)
g3.users << u3
g3.users << u1
g3.users << u2
