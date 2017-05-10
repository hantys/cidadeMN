puts "############## USERS 1"

user_1 = User.create(username: 'admin', :name => 'admin', :email => 'admin@admin.com.br', :password => '12345678')
user_1.save(:validate => false)


categories = Category.create!([
  { :name => 'Transporte', :icon => File.open('app/assets/images/pings/marker1.png') },
  { :name => 'Falta de água', :icon => File.open('app/assets/images/pings/marker2.png') },
  { :name => 'Barulho', :icon => File.open('app/assets/images/pings/marker3.png') },
  { :name => 'Esgoto', :icon => File.open('app/assets/images/pings/marker4.png') },
  { :name => 'Meio Ambiente', :icon => File.open('app/assets/images/pings/marker5.png') },
  { :name => 'Segurança', :icon => File.open('app/assets/images/pings/marker6.png') },
  { :name => 'Buraco', :icon => File.open('app/assets/images/pings/marker7.png') },
  { :name => 'Educação', :icon => File.open('app/assets/images/pings/marker8.png') },
  { :name => 'Saúde', :icon => File.open('app/assets/images/pings/marker9.png') },
  { :name => 'Esporte', :icon => File.open('app/assets/images/pings/marker10.png') },
  { :name => 'Limpeza', :icon => File.open('app/assets/images/pings/marker11.png') },
  { :name => 'Iluminação', :icon => File.open('app/assets/images/pings/marker12.png') },
  { :name => 'Lazer', :icon => File.open('app/assets/images/pings/marker13.png') },
])

(1..400).each do |i|
  puts "Causa #{i}"
  pin = rand(1..13)
  status = 0
  if pin == 1
    status = 0
  else
    status = 1
  end

  Cause.create! :user_id => 1, :category_id => pin, :text => "Seed nº #{i}", :latitude => -4.800042-(rand(0.030242..0.557242)), :longitude => (-42.00 - (rand(0.501805..0.991805))), status: status, start_date: (Time.now + (rand(0..5)).days) - (rand(0..10).days), end_date: (Time.now + (rand(0..5)).days) - (rand(0..10).days), address: "Rua #{i}"
end
