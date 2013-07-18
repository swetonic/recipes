if node[:name] == 'reports'

  file_to_fetch = "http://community.jaspersoft.com/sites/default/files/releases/jasperreports-server-cp-4.7.0-linux-x64-installer.run" 
    
  execute "fetch #{file_to_fetch}" do
    cwd "/tmp"
    command "wget #{file_to_fetch}"
    not_if { FileTest.exists?("/tmp/jasperreports-server-cp-4.7.0-linux-x64-installer.run") }
  end

  execute "untar /tmp/#{@node[:mongo_name]}.tgz" do
    command "cd /tmp; chmod 755 jasperreports-server-cp-4.7.0-linux-x64-installer.run; ./jasperreports-server-cp-4.7.0-linux-x64-installer.run < #{File.join(File.dirname(__FILE__), "..", "templates", "installer_script")}"
    not_if { FileTest.directory?("/opt/jasperreports-server-cp-4.7.0") }
  end

end

