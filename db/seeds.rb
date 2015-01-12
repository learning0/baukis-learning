# table_names = %w(allowed_sources)
table_names = %w(administrators customers staff_members
  staff_events allowed_sources programs entries)
table_names.each do |table_name|
  path = Rails.root.join('db', 'seeds', Rails.env, "#{table_name}.rb")
  if File.exist?(path)
    puts "Creating #{table_name}...."
    require(path)
  end
end
