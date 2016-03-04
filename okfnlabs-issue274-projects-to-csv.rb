require 'csv'
require 'fileutils'
require 'yaml'
require 'pry'

projects_dir = ENV['HOME'] + "/webdev/okfn.github.com/projects/_posts/"

# Create a projects hash with one key per project. Each key will map to another
# hash containing the projects metadata and its content
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

# build csv array of arrays
csvgrid = []
projects.each do |pkey,pval|

  row = [pkey]
  csv_columns.each do |colname,colcount|
    if pval["metadata"].has_key?(colname)
      if pval["metadata"][colname].class == Array
        row << pval["metadata"][colname].join(', ')
      else
        row << pval["metadata"][colname]
      end
    else
      row << ""
    end
  end

  pval.has_key?("content") ? row << pval["content"] : row << ""
  csvgrid << row

end

sorted_csvgrid = csvgrid.sort_by { |e| e[0] }

# write to csv file
CSV.open("output/okfnlabs-projects-metadata.csv","wb") do |csv|
  # write csv header line
  csv << ["project"] + csv_columns.keys + ["content"]


  sorted_csvgrid.each do |csvrow|
    csv << csvrow
  end  
end
