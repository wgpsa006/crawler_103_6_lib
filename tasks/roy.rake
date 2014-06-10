# encoding: UTF-8

desc "roy"
task :roy => :environment do
	#從檔案開啟
    File.open("/Users/teinakayuu/Desktop/projects/input5.txt","r").each_line do |line|

	profile = Selenium::WebDriver::Firefox::Profile.new
	#input
    #第一行公司行號 第二行年度 第三行公司名稱
    array = line.split(' ')

    #存檔
    target_dir = array[3]

	download_dir = File.join(Rails.root, "download/#{target_dir}")
	profile['browser.download.folderList'] = 2 # custom location
	profile['browser.download.dir'] = download_dir
	profile['browser.helperApps.neverAsk.saveToDisk'] = "application/msword,application/csv,text/csv"

	browser = Watir::Browser.new :firefox, :profile => profile
	

	#公開資料庫前往
	browser.goto 'http://mops.twse.com.tw/mops/web/t57sb01_q1'
	
	#公司代號 年 季別
	browser.text_field(:name => 'co_id').set array[0]
    browser.text_field(:name => 'year').set array[1]
    season = array[2]
    
    # Enter
	browser.input(:onclick => "showsh2('quicksearch9','showTable9');document.form1.step.value='4';action='/mops/web/ajax_quickpgm';ajax1(this.form,'quicksearch9');").click
	browser.input(:value => " 搜尋 ").click
	#開新頁面必做
	sleep 3

	browser.windows.last.use
	browser.as.each do |a|
		#puts a.text[5]
		if a.text[5] == season
		if a.text.include? 'pdf'
			# For PDF file
			a.click
			sleep 3
			browser.windows.last.use
			browser.as.each do |a|

				agent = Mechanize.new
				filename = File.basename(a.href)
				agent.pluggable_parser.default = Mechanize::Download
				agent.get(a.href).save("#{download_dir}/#{filename}")
			end
			browser.windows[-2].use
			browser.windows.last.close
			sleep 3
		elsif a.text.include? 'doc'
			# For doc
			#puts a.href
			a.click
			sleep 3
		end
	end
	end
	#關網站
    browser.windows.last.close
	sleep 3
	
	browser.close
	sleep 3
	end
end