require 'fileutils'
require 'yaml'
require 'pry'

projects_dir = ENV['HOME'] + "/webdev/okfn.github.com/projects/_posts/"

projects = {}
Dir.glob(projects_dir + "*.*") do |fullpath|

  pfile = File.basename(fullpath)
  projects[pfile] = {}

  file = File.open(fullpath, "rb")
  contents = file.read
  # split file into two, the first portion with the project metadata, the second with the content
  split_contents = contents.split("\n---")
  if split_contents.length == 2
    projects[pfile]['metadata_yaml'] = split_contents[0] + "\n---"
    projects[pfile]['content'] = split_contents[1] || ""
  else
    puts "Project file layout not as expected!"
  end
end

# parse metadata and collect column names
csv_columns = {}
projects.each do |pkey,pval|
  projects[pkey]['metadata'] = YAML.load(pval["metadata_yaml"])
  projects[pkey]['metadata'].each do |mkey,mval|
    # csv_columns and count occurrences
    csv_columns.has_key?(mkey) ? csv_columns[mkey] += 1 : csv_columns[mkey] = 1
  end
end

csv_column_names = csv_columns.map{ |k,v| k }

File.open("output/okfnlabs-projects-csv-liquid-template.csv", 'w') do |file|
   file.write("---\n---\n")
   csv_column_names.each do |col|
     if col == csv_column_names.last
       file.write(col + "\n")
     else
       file.write(col + ',')
     end
   end
   file.write("{% for project in site.categories.projects %}")
   csv_column_names.each do |col|
     if col == csv_column_names.last
       file.write('"{{project.' + col + '}}"' + "\n")
     else
       file.write('"{{project.' + col + '}}",')
     end
   end
   file.write("{% endfor %}")
 end