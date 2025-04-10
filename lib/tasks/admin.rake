# lib/tasks/admin.rake
namespace :admin do
  desc "Create admin user"
  task create: :environment do
    Admin.create!(
      email: ENV["ADMIN_EMAIL"],
      password: ENV["ADMIN_PASSWORD"]
    )
    puts "Admin created"
  end
end
