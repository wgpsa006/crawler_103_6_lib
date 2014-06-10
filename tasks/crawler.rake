# encoding: UTF-8

desc "crawler"
task :crawler => :environment do


 	a = Mechanize.new { |agent|
    	agent.user_agent_alias = 'Mac Safari'} 

  # get input  
  input = '台積電'
  pagenumber = 5
  article_save_count = 0

  # translate  
  final = URI::escape("http://news.cnyes.com/search.aspx?q=#{input}&D=8&P=")

  # Save Keyword in model
  keyword = Keyword.new(:name => input)
  keyword.save

  #get address
  for i in 1..pagenumber 
    a.get(final+i.to_s+'&1=1') do |page|
      doc = Nokogiri::HTML(page.body)

      article_title = ''
      relative_address = ''

      doc.xpath('.//ul').each do |ul|
        if ul['class'] && ul['class'].index('list_1') && ul['class'].index('bd_dbottom')
          ul.xpath('.//a').each do |a|
            if a['target'] && a['target'].index('_blank')
              article_title = a.inner_text
              relative_address = a['href']
              absolute_address = "http://news.cnyes.com#{relative_address}"

              # Save ArticleEntry in model
              article_entry = ArticleEntry.new(:title => article_title, :url => absolute_address)
              article_entry.keyword = keyword
              article_entry.save

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
              end             

              # Save Article in model
              article = Article.new(:title => title, :content => content, :authorize_at_string => authorize_at)
              article.article_entry = article_entry
              article.save
              article_save_count = article_save_count + 1

              puts article_save_count
            end
          end
        end
      end
    end
  end
  puts 'Okay complete...'
end