require 'pry'
require 'fileutils'

projects_dir = ENV['HOME'] + "/webdev/okfn/okfn.github.com/_projects"
tmp_dir = ENV['HOME'] + "/webdev/okfn/okfn.github.com/ttmm/"
html_files = Dir.glob(projects_dir + "/*.*")

html_files.each do |h|
  newfile = tmp_dir + h.split("/").last.slice(11..-1)
  puts newfile
  FileUtils.copy(h,newfile)
end

binding.pry
FileUtils()