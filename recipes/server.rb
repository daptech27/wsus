#
# Cookbook Name:: wsus
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

powershell_script "install wsus prereqs" do
	code <<-EOH
	"web-server", "Web-Asp-Net", "Web-Windows-Auth", "Web-Metabase", "File-Services" | foreach {if (!(Get-WindowsFeature $_)){add-windowsfeature $_}}
	 EOH
end

# old code
# powershell_script "install wsus prereqs" do
# 	code <<-EOH
# 	 add-windowsfeature web-server
# 	 add-windowsfeature Web-Asp-Net
# 	 add-windowsfeature Web-Windows-Auth
# 	 add-windowsfeature Web-Metabase
# 	 add-windowsfeature File-Services
# 	 EOH
# end


# windows feature dump in case server is completely blank:
# File-Services
# FS-FileServer
# Web-Server
# Web-WebServer
# Web-Common-Http
# Web-Static-Content
# Web-Default-Doc
# Web-Dir-Browsing
# Web-Http-Errors
# Web-App-Dev
# Web-Asp-Net
# Web-Net-Ext
# Web-ISAPI-Ext
# Web-ISAPI-Filter
# Web-Health
# Web-Http-Logging
# Web-Request-Monitor
# Web-Security
# Web-Windows-Auth
# Web-Filtering
# Web-Performance
# Web-Stat-Compression
# Web-Mgmt-Tools
# Web-Mgmt-Console
# Web-Mgmt-Compat
# Web-Metabase
# NET-Framework
# NET-Framework-Core
# RSAT
# RSAT-Role-Tools
# RSAT-Web-Server
# Windows-Internal-DB

remote_file "c:/chef/WSUS30-KB972455-x64.exe" do
  action :create
  source "http://download.microsoft.com/download/B/0/6/B06A69C3-CF97-42CF-86BF-3C59D762E0B2/WSUS30-KB972455-x64.exe"
end


windows_package "WSUS30-KB972455-x64.exe" do
	# default logs go to C:\Users\Opscode\AppData\Local\Temp\WSUSSetup.log - doesnt seem to be a way to change it
	# notes http://technet.microsoft.com/en-us/library/dd939814(WS.10).aspx
	# notes http://technet.microsoft.com/en-us/library/dd939811(v=ws.10).aspx#wssetup
	action :install
	installer_type :custom
	source 'c:/chef/WSUS30-KB972455-x64.exe'
    options "/q CONTENT_LOCAL=1 CONTENT_DIR=C:\\WSUS DEFAULT_WEBSITE=0 CREATE_DATABASE=1 PREREQ_CHECK_LOG=C:\\chef\\bob.txt MU_ROLLUP=0"
	# options with SQL "/q CONTENT_LOCAL=1 CONTENT_DIR=C:\\WSUS SQLINSTANCE_NAME=%COMPUTERNAME% DEFAULT_WEBSITE=0 CREATE_DATABASE=1 PREREQ_CHECK_LOG=C:\\chef\\bob.txt MU_ROLLUP=0"
	# other stuff CONSOLE_INSTALL=0 ? ENABLE_INVENTORY ? 
	
	# does not seem to work at the moment.
	not_if "type C:\\Users\\Opscode\\AppData\\Local\\Temp\\WSUSSetup.log |grep -i 'Windows Server Update Services setup completed successfully'"
	# require 'pry';binding.pry
end
