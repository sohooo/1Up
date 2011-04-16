1Up
===
version: v0.2
by: Sven Sporer

This little script helps you share your pictures by doing the following:

* take image from imagebox (a folder you specify)
* convert to max. 800px dimensions
* strip profiles/EXIF data
* upload image to remote dir via ssh (create config.yaml)
* copy url to clipboard
* send growl notification
* backup original image

# Enhancements
The scripts works fine in standalone mode, but for there are some helful tools
for additional pleasure:

1. `growlnotify` utility for nice growl notifications
2. a Hazel job which watches the imagebox and automatically starts the script


