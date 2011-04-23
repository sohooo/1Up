1Up
===

version: v0.2
by: Sven Sporer

This little script helps you share your pictures by doing the following:

* create tmpfile of specified image
* convert to max. 800px dimensions
* strip profiles/EXIF data
* upload image to remote dir via ssh (create config.yaml; see sample)
* copy url to clipboard
* send growl and sound notification


# Usage

The scripts works fine if you call it from commandline, but really shines
if you define it as a Service for image files. This way you can start it from
any place Services are available (Finder, iPhoto, ...).


## Define Service

* start Automator > create a Service
* Service receives Images from any program
* add the module to execute a shell script
* shell script text: `/path/to/script/1up/1up.rb "$@"`


## Use with Quicksilver

This handy script really shines in combination with [Quicksilver](http://qsapp.com/)
and its [Services Menu Module](http://qsapp.com/plugins/), which converts
services to Quicksilver actions. Now, you can load an image (get current selection),
hit TAB, and choose the 1Up service you defined earlier. Sweet.


# TODO

* Post with images to explain usage
* Rakefile to generate Automator workflow/Service?
* Logging
