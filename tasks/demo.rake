# encoding: UTF-8

desc "demo"
task :demo => :environment do

  #for num in 1..4

  a = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'}

num =1
      # get input
      case num 
      when 1  
        input = '頭條'
      when 2
        input = '台股'
      when 3  
        input = '時事'
      else
        input = '黃金'
      end

      #time
      day=0
      num = 0

      for day in 14..30
        if day < 10
          timestart = '2013070'+day.to_s                                                   
        else 
          timestart = '201307'+day.to_s
        end
        #timestart = '20130711' 
      timeend = timestart
        #timeend = '20131230'
      #pagenumber = 20
      pagenumber = 20

    #File.open(path+'.rb', 'w') do |f2| 

      if input == '頭條' 
      final = "http://news.cnyes.com/headline/sonews_#{timestart}#{timeend}_"

      elsif input == '快報'
      final = "http://news.cnyes.com/express/sonews_#{timestart}#{timeend}_"  

      elsif input == '宏觀'
      final = "http://news.cnyes.com/MACRO/sonews_#{timestart}#{timeend}_"

      elsif input == '指標'
      final ="http://news.cnyes.com/INDEX/sonews_#{timestart}#{timeend}_"

      elsif input == '時事'
      final ="http://news.cnyes.com/EVENT/sonews_#{timestart}#{timeend}_"

      elsif input == '深度'
      final ="http://news.cnyes.com/deep/sonews_#{timestart}#{timeend}_"

      elsif input == '台股'
      final ="http://news.cnyes.com/tw_stock/sonews_#{timestart}#{timeend}_"

      elsif input == '興櫃'
      final ="http://news.cnyes.com/eme/sonews_#{timestart}#{timeend}_"

      elsif input == '美股'
      final ="http://news.cnyes.com/us_stock/sonews_#{timestart}#{timeend}_"

      elsif input == 'A股'
      final ="http://news.cnyes.com/sh_stock/sonews_#{timestart}#{timeend}_"

      elsif input == '港股'
      final ="http://news.cnyes.com/hk_stock/sonews_#{timestart}#{timeend}_"

      elsif input == '國際股'
      final ="http://news.cnyes.com/wd_stock/sonews_#{timestart}#{timeend}_"

      elsif input == '外匯'
      final ="http://news.cnyes.com/forex/sonews_#{timestart}#{timeend}_"    

      elsif input == '期貨'
      final ="http://news.cnyes.com/future/sonews_#{timestart}#{timeend}_" 

      elsif input == '能源'
      final ="http://news.cnyes.com/energry/sonews_#{timestart}#{timeend}_" 

      elsif input == '黃金'
      final ="http://news.cnyes.com/gold/sonews_#{timestart}#{timeend}_" 

      elsif input == '基金'
      final ="http://news.cnyes.com/fund/sonews_#{timestart}#{timeend}_" 

      elsif input == '房產'
      final ="http://news.cnyes.com/cnyeshouse/sonews_#{timestart}#{timeend}_"    

      elsif input == '產業'
      final ="http://news.cnyes.com/industry/sonews_#{timestart}#{timeend}_"       
      end

#改成用search 
final = URI::escape("http://news.cnyes.com/search.aspx?q=#{input}&D=8&P=")
      for i in 1..pagenumber 
       a.get(final+i.to_s+'.htm') do |page|
  	       doc = Nokogiri::HTML(page.body)

  	        title_text = ''
  	        news_text = ''
            date = ''
            article_title = ''
            relative_address = ''
            count = 0

  	        doc.xpath('.//title').each do |title|
               title_text = title.inner_text
             

  	            #f2.puts title_text
            end

  	        doc.xpath('.//ul').each do |ul|
                if ul['class'] && ul['class'].index('list_1') && ul['class'].index('bd_dbottom')
                      if ul.xpath('.//strong').count > 2  #can stop if 
                        ul.xpath('.//a').each do |a|
                          
                          count = count+1
                          if count%2==0
                              article_title = a.inner_text
                              relative_address = a['href']
                              absolute_address = "http://news.cnyes.com#{relative_address}"
                    
                              title = ''
                              content = ''
                              authorize_at = nil

                              b = Mechanize.new { |agent|
                                      agent.user_agent_alias = 'Mac Safari'}

                              b.get(absolute_address) do |page|
                                      article_doc = Nokogiri::HTML(page.body)

                              article_doc.xpath('.//title').each do |t|
                              title = t.inner_text
                              end
                    
                              #write in dir
                              path = './'+input+'/'+timestart+'/'+ title
                              dir = File.dirname(path)
                              #exit or not
                              unless File.directory?(dir)
                              FileUtils.mkdir_p(dir)
                              end
                              #open file
                              num = num + 1
                              File.open(path, 'w') do |f2|

                              f2.puts title

                              article_doc.xpath('.//span').each do |span|
                              if span['class'] == 'info'
                                    authorize_at_array = span.inner_text.split(' ')
                                    authorize_at_date = authorize_at_array[0][-10..-1]
                                    authorize_at_time = authorize_at_array[1][0..8]
                                    #authorize_at = DateTime.parse("#{authorize_at_date}/#{authorize_at_time}" )
                                    authorize_at = "#{authorize_at_date}/#{authorize_at_time}"
                                    f2.puts authorize_at
                                end
                              end
                
                              article_doc.xpath('.//div').each do |div|
                              if div['id'] == 'newsText'
                                  content = div.inner_text
                                  f2.puts content
                                end  
                              end
                              #puts title 
                              #puts authorize_at
                              #puts content
                              #puts '--------------------------------------'
                              end  
                          end 

                        end
                    end  
                end
            end
        end      
      end
      end
    end
#   end
end
