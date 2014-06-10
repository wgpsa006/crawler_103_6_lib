# encoding: UTF-8

desc "my first robot"
task :my_robot => :environment do


  a = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'}

      # get input  
      input = '深度' 
      timestart = '20131106'                                                   
      timeend = '20131111'
      pagenumber = 5

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
  	           puts title_text
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

                              article_doc.xpath('.//span').each do |span|
                              if span['class'] == 'info'
                                    authorize_at_array = span.inner_text.split(' ')
                                    authorize_at_date = authorize_at_array[0][-10..-1]
                                    authorize_at_time = authorize_at_array[1][0..8]
                                    #authorize_at = DateTime.parse("#{authorize_at_date}/#{authorize_at_time}" )
                                    authorize_at = "#{authorize_at_date}/#{authorize_at_time}"
                                end
                              end
                
                              article_doc.xpath('.//div').each do |div|
                              if div['id'] == 'newsText'
                                  content = div.inner_text
                                end  
                              end
                              puts title 
                              puts authorize_at
                              puts content
                              puts '--------------------------------------'
                              end  
                          end 

                        end
                    end  
                end
            end
        end      
      end
end
