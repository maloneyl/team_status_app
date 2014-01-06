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

u1 = User.create!(:email => 'maloney@maloney.com', :first_name => 'Maloney', :last_name => 'Liu', :username => 'maloney', :password => 'maloney', :password_confirmation => 'maloney')
# u1.confirmed_at = u1.created_at + 2.seconds

u2 = User.create!(:email => 'belle@belle.com', :first_name => 'Belle', :last_name => 'Beans', :username => 'belle', :password => 'belle', :password_confirmation => 'belle')
# u2.confirmed_at = u2.created_at + 2.seconds

u3 = User.create!(:email => 'wouter@wouter.com', :first_name => 'Wouter', :last_name => 'DL', :username => 'wouter', :password => 'wouter', :password_confirmation => 'wouter')
# u3.confirmed_at = u3.created_at + 3.seconds

u4 = User.create!(:email => 'mitchell@mitchell.com', :first_name => 'Mitchell', :last_name => 'Pritchett', :username => 'mitchell', :password => 'mitchell', :password_confirmation => 'mitchell')

u5 = User.create!(:email => 'cameron@cameron.com', :first_name => 'Cameron', :last_name => 'Tucker', :username => 'cameron', :password => 'cameron', :password_confirmation => 'cameron')

u6 = User.create!(:email => 'john@john.com', :first_name => 'John', :last_name => 'Exo', :username => 'john', :password => 'john', :password_confirmation => 'john')

g1 = Group.create!(:name => 'Beans Group', :owner_id => u2.id)
g1.users << u1
g1.users << u2
g1.users << u3
g1.users << u6
g1.save!

g2 = Group.create!(:name => 'Team Modern', :owner_id => u1.id)
g2.users << u1
g2.users << u4
g2.users << u5
g2.save!

#g1
s1 = Status.create!(:body => "@all I need to leave a couple hours early today so grab me earlier if you need me!", :tracking => false, :tracked => false, :user_id => u2.id, :group_id => g1.id)
s2 = Status.create!(:body => "@belle Most likely won't have wireframes done until EOD. Will just Basecamp you then.", :tracking => false, :tracked => false, :user_id => u1.id, :group_id => g1.id)
s3 = Status.create!(:body => "Stepping out for a bit.", :tracking => false, :tracked => false, :user_id => u3.id, :group_id => g1.id)
s4 = Status.create!(:body => "@maloney LPH staging is up - could you check the copy when you get the chance?", :tracking => false, :tracked => false, :user_id => u6.id, :group_id => g1.id)
a1 = Agenda.create!(:body => "Launch LPH", :group_id => g1.id, :user_id => u6.id)
a2 = Agenda.create!(:body => "Research and write proposal for XYZ", :group_id => g1.id, :user_id => u2.id)

# g2
s5 = Status.create!(:body => "@maloney Thanks for setting up the new group!", :tracking => false, :tracked => false, :user_id => u4.id, :group_id => g2.id)
