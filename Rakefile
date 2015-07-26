require_relative 'lib/files_surface'
extend FilesSurface
require_relative 'lib/query'



task :default => :test

task :test do
  system "rake clean"
  system "rake scan\[lib]"
  #system "rake query:name\[stuff]"
  #system "rake query\['name stuff']"
  system "rake query\['time 26.07.2015']"
end


desc 'scans given area (or /) and fills files db'

task :scan, [:at] => :clean do |t,params|
  at = params[:at] || '/'

  scan_files at: at do |file|
    remember_file file
  end
end

task :clean do
  forget_files
end

desc 'run queries on the scan db'

task :query, :query do |t, params|
  params[:query] or raise 'param expected!'
  query = Query.new params[:query]
    
  query_files query
end

