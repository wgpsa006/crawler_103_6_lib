#encoding UTF-8

desc "twse"
task :twse => :environment do
=begin
	輸入：公司行號
	年份：抓取一整年
	
	輸出
	月年份 公司名稱 公司代號  日期 成交股數 成交金額 開盤 
	最高 最低 收盤 漲跌價差 成交筆數
=end
	
#使用靜態網頁爬文
a = Mechanize.new { |agent|
    	agent.user_agent_alias = 'Mac Safari'} 

#input
input = '2330'  #輸入公司代號
year = '2013'	#輸入年份  一定要西元	

#month from 01~12
for i in 1..12
	if i<10
		month = '0'+i.to_s
	else
		month = i.to_s 
	end
		#puts month
					#http://www.twse.com.tw/ch/trading/exchange/STOCK_DAY/genpage/Report201312/201312_F3_1_8_2330.php?STK_NO=2330&myear=2013&mmon=12
					#http://www.twse.com.tw/ch/trading/exchange/STOCK_DAY/genpage/Report201301/201301_F3_1_8_2330.php?STK_NO=2330&myear=2013&mmon=01
final = URI::escape("http://www.twse.com.tw/ch/trading/exchange/STOCK_DAY/genpage/Report#{year}#{month}/#{year}#{month}_F3_1_8_#{input}.php?STK_NO=#{input}&myear=#{year}&mmon=#{month}")
					#http://www.twse.com.tw/ch/trading/exchange/STOCK_DAY/genpage/Report201303/201303_F3_1_8_2330.php?STK_NO=2330&myear=2013&mmon=03

#output
Company_name=''			#公司名稱 
Company_code=input      #公司代號
year_month=''			#年月
date=''   				#日期
Turnover='' 			#成交股數
Transaction_amount='' 	#成交金額
Opening=0 				#開盤 
Highest=0 				#最高 
Lowest=0 				#最低 
Close=0  				#收盤 
Change_spreads=0 		#漲跌價差 
Traded_items=0 			#成交筆數
temp={}

	a.get(final) do |page|
      doc = Nokogiri::HTML(page.body)

      doc.xpath(".//table").each do |table|
      	if table['class'] && table['class'].index('board_trad') 
			
			#時間 公司名稱
			table.xpath(".//div").each do |div|	
				if div['class'] && div['class'].index('til_2') && div['align'] && div['align'].index('center') 
					year_month = div.inner_text[0..6]
					#Company_code = div.inner_text[8..11]
					Company_name = div.inner_text[13..15]	
				end
			end

			#日期 成交股數 成交金額 開盤 最高 最低 收盤 漲跌價差 成交筆數
			
			table.xpath(".//tr").each do |tr|
				if tr['class'] && tr['class'].index('basic2') && tr['bgcolor'] && tr['bgcolor'].index('#FFFFFF')
					tr.xpath(".//div").each do |div|
						if div['align'] && div['align'].index('center')	
							date = div.inner_text #日期 
						end
						#puts date
					end

					count=1
					tr.xpath(".//td").each do |td|
						if td['align'] && td['align'].index('right')
							#puts td.inner_text
							temp[count] = td.inner_text
							count = count + 1
						end
					end
					Turnover=temp[1] 			#成交股數
					Transaction_amount=temp[2] 	#成交金額
					Opening=temp[3] 			#開盤 
					Highest=temp[4] 			#最高  
					Lowest=temp[5] 				#最低 
					Close=temp[6]  				#收盤 
					Change_spreads=temp[7] 		#漲跌價差 
					Traded_items=temp[8] 		#成交筆數
					#puts Turnover 
      				#puts Transaction_amount 
      				#puts Opening 
      				#puts Highest 
      				#puts Lowest 
      				#puts Close 
      				#puts Change_spreads 
      				#puts Traded_items	
				end 
			end	
			
      		#puts year_month
			#puts Company_code
			#puts Company_name
      		#puts date
      		#puts Turnover 
      		#puts Transaction_amount 
      		#puts Opening 
      		#puts Highest 
      		#puts Lowest 
      		#puts Close 
      		#puts Change_spreads 
      		#puts Traded_items
      	end

      end	
	end

	end
end


