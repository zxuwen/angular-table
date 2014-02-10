task :default => [:compile]

task :compile do

  require File.expand_path("gem/lib/angular-table/version")

  require "coffee-script"
  require "uglifier"

  script = CoffeeScript.compile collect_coffees("coffee")

  prepend_author_notice(script)

  File.open("angular-table.js", "w") { |file| file.write(script) }
  File.open("gem/app/assets/javascripts/angular-table.js", "w") { |file| file.write(script) }
  File.open("angular-table.min.js", "w") { |file| file.write(prepend_author_notice(Uglifier.new.compile(script))) }

end

def collect_coffees src
  files = [
    "atTable", "atImplicit", "atPagination",
    "table", "table_setup", "table_configuration",
    "column_configuration", "declarative_table",
    "standard_table_setup", "pagination_table_setup"
  ]
  script = ""
  files.each do |file|
    script << File.read("#{src}/#{file}.coffee") << "\n"
  end
  script
end

def prepend_author_notice script
  comments = ""
  comments << "// author:   Samuel Mueller \n"
  comments << "// version:  #{AngularTable::VERSION} \n"
  comments << "// license:  MIT \n"
  comments << "// homepage: http://github.com/samu/angular-table \n"

  script.prepend comments
  script
end

task :dev do
  require "listen"
  puts "listening!"

  Listen.to!("coffee", :force_polling => true) do |modified, added, removed|
    puts "recompiling source!"
    `rake compile`
  end
end