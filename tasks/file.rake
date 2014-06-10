# encoding: UTF-8

desc "file"
task :file => :environment do
	 #從檔案開啟
    File.open("/Users/teinakayuu/Desktop/projects/crawler_103_6/input2.txt","r").each_line do |line|	
	#input
    #第一行公司行號 第二行年度 第三行季 第四行公司名稱
    array = line.split(' ')
    
    #存檔
    target_dir = array[2]
    #target_dir = '華南金'

	profile = Selenium::WebDriver::Firefox::Profile.new
	download_dir = File.join(Rails.root, "./download/#{target_dir}")
	profile['browser.download.folderList'] = 2 # custom location
	profile['browser.download.dir'] = download_dir
	profile['browser.helperApps.neverAsk.saveToDisk'] = "application/msword"

	browser = Watir::Browser.new :firefox, :profile => profile

	#公開資料庫前往
	browser.goto 'http://mops.twse.com.tw/mops/web/t57sb01_q5'
	
	#公司代號 年 季別
	browser.text_field(:name => 'co_id').set array[0]
    browser.text_field(:name => 'year').set array[1]
    #season = array[2]

    # Enter
	browser.input(:onclick => "showsh2('quicksearch9','showTable9');document.form1.step.value='4';action='/mops/web/ajax_quickpgm';ajax1(this.form,'quicksearch9');").click
	browser.input(:value => " 搜尋 ").click
	#開新頁面必做
	sleep 10

	browser.windows.last.use
	count = 1
	count2 = 1
	fnum = 1
	tnum = 1
	tnumbegin = 1
	filename = {}
	time = {}

=begin
	#特殊案例 開始
	browser.windows.last.use
	if  browser.input(:src => "/image/t56sf26.gif").exists?  
		browser.inputs.each do |input|
			if input.src.include? "/image/t56sf26.gif"
				input.click
				sleep 3
				#download
				browser.as.each do |a|
					if a.text[5] == season
						if fnum == 1
							tnumbegin = count	
						end
						filename[fnum] = a.text 
						fnum = fnum + 1
					end
					count = count + 1
				end

				#拿到時間
				browser.tds.each do |td| 	
					if td.align == 'cetern' 
						count2 = count2 + 1
					end

					if count2 > tnumbegin && tnum < fnum && td.align == 'cetern'
						time[tnum] = td.text 
						tnum = tnum + 1
					end
				end
	
				#建立檔案
	   			path = "/Users/teinakayuu/Desktop/projects/crawler/download/#{target_dir}/file_time"
  				dir = File.dirname(path)

  				unless File.directory?(dir)
    				FileUtils.mkdir_p(dir)
  				end

  				File.open("/Users/teinakayuu/Desktop/projects/file_check.txt",'a') do |f2|
					f2.puts target_dir

		  		File.open(path,'a') do |f3|			
				#Download
					num = 1
					browser.as.each do |a|
						if a.text[5] == season
						# For PDF file
							if a.text.include? 'pdf'
								a.click
								sleep 3
				
								#save file
								browser.windows.last.use
								browser.as.each do |a|
									agent = Mechanize.new
									file = File.basename(a.href)
									agent.pluggable_parser.default = Mechanize::Download
									agent.get(a.href).save("#{download_dir}/#{file}")
								end
								browser.windows[-2].use
								browser.windows.last.close
								sleep 3
							# For doc
							elsif a.text.include? 'doc' or a.text.include? 'zip' 
								a.click
								sleep 10
							end 
							#寫入檔案成功	check
							f2.puts "#{filename[num]}"+ ' yes'
							#寫入 file_time
							f3.puts "#{filename[num]}" + ' ' + "#{time[num]}"
							num = num + 1
						end	#season
					end #each a
				end  #open f3
				end  #open f2

				browser.back
				sleep 3
			end
		end

		#part2
			tag={}
			num=1
			i=1
			#自己建表格讓網頁回去時找到下一個網址
			if 	browser.img(:src => "/image/t56sf26.gif").exists?
				browser.as.each do |a|
					tag[num] = a.href
					num = num + 1
				end
			end

			if 	browser.img(:src => "/image/t56sf26.gif").exists?
				for j in 1..num
					browser.as.each do |a|
						if a.href == tag[i]
							a.click
							#download
							count = 1
							count2 = 1
							fnum = 1
							tnum = 1
							tnumbegin = 1
							filename = {}
							time = {}
							
							browser.as.each do |a|
								if a.text[5] == season
									if fnum == 1
										tnumbegin = count	
									end
									filename[fnum] = a.text 
									fnum = fnum + 1
								end
								count = count + 1
							end

							#拿到時間
							browser.tds.each do |td| 	
								if td.align == 'cetern' 
									count2 = count2 + 1
								end

								if count2 > tnumbegin && tnum < fnum && td.align == 'cetern'
									time[tnum] = td.text 
									tnum = tnum + 1
								end
							end
	
							#建立檔案
	   						path = "/Users/teinakayuu/Desktop/projects/crawler/download/#{target_dir}/file_time"
  							dir = File.dirname(path)

  							unless File.directory?(dir)
    							FileUtils.mkdir_p(dir)
  							end

  							File.open("/Users/teinakayuu/Desktop/projects/file_check.txt",'a') do |f2|
								f2.puts target_dir
		  					File.open(path,'a') do |f3|			
								#Download
								num = 1
								browser.as.each do |a|
									if a.text[5] == season
										# For PDF file
										if a.text.include? 'pdf'
											a.click
											sleep 3
											#save file
											browser.windows.last.use
											browser.as.each do |a|
												agent = Mechanize.new
												file = File.basename(a.href)
												agent.pluggable_parser.default = Mechanize::Download
												agent.get(a.href).save("#{download_dir}/#{file}")
											end
												browser.windows[-2].use
												browser.windows.last.close
												sleep 3

											# For doc
										elsif a.text.include? 'doc' or a.text.include? 'zip' 
											a.click
											sleep 10
										end 
										#寫入檔案成功 check
										f2.puts "#{filename[num]}"+ ' yes'
										#寫入 file_time
										f3.puts "#{filename[num]}" + ' ' + "#{time[num]}"
										num = num + 1
									end	#season
								end #each a
							end  #open f3
							end  #open f2

							#自己建表格讓網頁回去時找到下一個網址
							i = i + 1  
							sleep 3
							browser.back
							sleep 3
							j = j + 1
							break
						end #if
					end #each a
				end #for
				#關網站
    			browser.windows.last.close
				sleep 3
			end #if
	#特殊案例 結束
=end
	#else
	#拿到檔名
	count = 1
	count2 = 1
	fnum = 1
	tnum = 1
	tnumbegin = 1
	filename = {}
	time = {}
=begin	
	#排班
	browser.as.each do |a|
		if a.text[5] == season
				if fnum == 1
					tnumbegin = count	
				end
				filename[fnum] = a.text 
				fnum = fnum + 1
		end
		count = count + 1
	end
=end
	#拿到時間
	browser.trs.each do |tr| 	
		#if td.align == 'cetern'
		#	puts td.text
		#	count2 = count2 + 1
		#end
		tr.tds.each do |td|    	#抓股東欄位
			if td.align == 'center'
				if td.text == '股東會年報' || td.text == '股東會年報(股東會後修訂本)'
					tr.tds.each do |td|
						if td.align == 'cetern'  #抓日期
							time[tnum]= td.text
							tnum = tnum + 1
						end
					end
					tr.as.each do |a|			#抓網址
						filename[fnum] = a.text
						fnum = fnum + 1
					end
				end
			#count2 = count2 + 1
			end
		end
	end
	
		#建立檔案
	   	path = "/Users/teinakayuu/Desktop/projects/crawler_103_6/download/#{target_dir}/file_time"
  		dir = File.dirname(path)

  		unless File.directory?(dir)
    		FileUtils.mkdir_p(dir)
  		end

  		File.open("/Users/teinakayuu/Desktop/projects/crawler_103_6/file_check.txt",'a') do |f2|
				f2.puts array[2]

  		File.open(path,'a') do |f3|			
		#Download
		num = 1
		browser.trs.each do |tr| 	
		#if td.align == 'cetern'
		#	puts td.text
		#	count2 = count2 + 1
		#end
		tr.tds.each do |td|    	#抓股東欄位
			if td.align == 'center'
				if td.text == '股東會年報' || td.text == '股東會年報(股東會後修訂本)'
					tr.as.each do |a|	
						if a.text.include? 'pdf'
							a.click
							sleep 3
				
							#save file
							browser.windows.last.use
							browser.as.each do |a|
						agent = Mechanize.new
						file = File.basename(a.href)
						agent.pluggable_parser.default = Mechanize::Download
						agent.get(a.href).save("#{download_dir}/#{file}")
							end
					browser.windows[-2].use
					browser.windows.last.close
					sleep 3
					# For doc
						elsif a.text.include? 'doc' or a.text.include? 'zip'
						#puts a.href
						a.click
						sleep 10
						end 

				#寫入檔案成功 check
				f2.puts "#{filename[num]}"+ ' yes'
				#寫入 file_time
				f3.puts "#{filename[num]}" + ' ' + "#{time[num]}"
				num = num + 1
					end	#tr.as.each do |a|
				end #if td.text == '股東會年報' || td.text == '股東會年報(股東會後修訂本)'
			end #if td.align == 'center'
		end #tr.tds.each do |td| 
	end#browser.trs.each do |tr| 
		end  #open f3
		end  #open f2
	#關網站
    browser.windows.last.close
	sleep 3
	#end #else
	browser.close
	sleep 3
	end #file
end