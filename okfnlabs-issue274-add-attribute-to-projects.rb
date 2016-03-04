require 'fileutils'
require 'yaml'
require 'pry'

projects_dir = ENV['HOME'] + "/webdev/okfn.github.com/projects/_posts/"

new_attribute = "maturity_status"
new_attribute_default = ""
# hash of project => new_attribute
project_attr_hash = {}
Dir.glob(projects_dir + "*.*") do |pfile|
  yfile = YAML.load(File.read(pfile))
  project_attr_hash[File.basename(pfile)] = yfile.has_key?(new_attribute) ? yfile[new_attribute] : "--empty--"
end

no_attr_projects = project_attr_hash.select{ |k,v| v == "--empty--"}
no_attr_projects.each do |proj,attr_value|
  dash_line_count = 0
  full_file = IO.readlines(projects_dir + proj).map do |line|
    dash_line_count += 1 if line.strip == "---"
    if dash_line_count == 2
      dash_line_count = 99
      new_line = new_attribute + ":" + new_attribute_default + "\n---"
    else
      new_line = line
    end
    new_line
  end
  
  File.open(projects_dir + proj, 'w') do |file|
    file.puts full_file
  end

end
