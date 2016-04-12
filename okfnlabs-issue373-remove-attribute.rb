require 'fileutils'

blog_dir = ENV['HOME'] + "/webdev/okfn/okfn.github.com/blog/_posts/"
members_dir = ENV['HOME'] + "/webdev/okfn/okfn.github.com/members/_posts/"

def remove_att(dir,starts_with)
  Dir.glob(dir + "*.*") do |fullpath|
    open(fullpath, 'r') do |f|
      open(fullpath + "_new", 'w') do |f2|
        f.each_line do |line|
           f2.write(line) unless line.start_with? starts_with
        end
      end
    end
    FileUtils.mv fullpath + "_new", fullpath
  end
end

remove_att(blog_dir,"layout:")
remove_att(members_dir,"layout:")
