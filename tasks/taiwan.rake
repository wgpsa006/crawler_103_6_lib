# encoding: UTF-8

desc "taiwan"
task :taiwan => :environment do
	browser = Watir::Browser.new 	
	browser.goto 'http://kmw.ctgin.com'
	puts browser.title

	# Enter 
	
	browser.a(:style => 'COLOR: #0055ca').click

	# LOOP 003 ~ 005 007 008
	browser.td(:id => 'Menu1-menuItem000').click
	browser.td(:id => 'Menu1-menuItem000-subMenu-menuItem003').click
	sleep 20

	browser.a(:id => 'tvTreet56').click
	sleep 20

	puts browser.title
	browser.close
end