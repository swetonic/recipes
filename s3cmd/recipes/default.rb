
Chef::Log.info "creating directory"
directory "/usr/lib/s3cmd" do
    owner "root"
    group "root"
    action :create
    mode 0755
    not_if { ::FileTest.exists?("/usr/lib/s3cmd") }
end

s3cmd_tar_gz = "/usr/lib/s3cmd/s3cmd-1.5.0-alpha1.tar.gz"

Chef::Log.info "downloading file"

remote_file s3cmd_tar_gz do
  checksum "e7acc1f6c4716da3aa1302620de1b007"
  source "http://sourceforge.net/projects/s3tools/files/s3cmd/1.5.0-alpha1/s3cmd-1.5.0-alpha1.tar.gz"
end


Chef::Log.info "installing"
bash "install s3cmd 1.5.0" do
  cwd "/usr/lib/s3cmd/"
  code <<-EOH
    tar -zxf #{s3cmd_tar_gz}
    cd /usr/lib/s3cmd && sudo ln -nfs $PWD/s3cmd /usr/local/bin/s3cmd
  EOH
  not_if { ::FileTest.exists?("/usr/local/bin/s3cmd") }
end

