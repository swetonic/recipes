#############################################
# Sample recipe for emerging packages
# 
# Search the Engine Yard portage tree to find
# out package versions to install
#
# EXAMPLE:
#
# Ensure local package index is synced with tree
# $ eix-sync
#
# Search for libxml2
# $ eix libxml2
#############################################

# Unmask version 2.7.6 of libxml2
enable_package "media-gfx/imagemagick" do
   version "6.7.8.8-r1"
 end
 package "media-gfx/imagemagick" do
   version "6.7.8.8-r1"
   action :install
 end

enable_package "dev-libs/libxml2" do
 version "2.7.8"
end

# Install the newly unmasked version
package "dev-libs/libxml2" do
   version "2.7.8"
   action :install
end

enable_package 'net-print/cupsddk' do
  version '1.2.3'
end

package "net-print/cupsddk" do
  version "1.2.3"
  action :install
end

# Unmask ffmpeg
enable_package "media-video/ffmpeg" do
  version "0.4.9_p20090201"
end

package "media-video/ffmpeg" do
  version "0.4.9_p20090201"
  action :install
end

package "app-crypt/gnupg" do
  version "1.4.9"
  action :install
end

