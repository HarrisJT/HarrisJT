require "kindle_highlights"

WORK_NAME = "ABODO"
WORK_URL = "https://abodo.com/about"
PERSONAL_WEBSITE_URL = "https://harrisjt.com"
PERSONAL_EMAIL = "harris@harrisjt.com"
TWITTER_URL = "https://twitter.com/harrisjt_"
HIGHLIGHTS_LIMIT = 10

kindle = KindleHighlights::Client.new(
    email_address: ENV["AMAZON_USER"],
    password: ENV["AMAZON_PASS"]
)

highlights = []

kindle.books.each do |book|
  asin = book.asin
  next if asin.blank?

  kindle.highlights_for(asin).each do |highlight|
    if highlight.text.present?
      formatted_highlight = {
          title: book.title,
          author: book.author,
          asin: asin,
          text: highlight.text,
          location: highlight.location,
      }
      highlights << formatted_highlight
    end
  end
end

if highlights.length.positive?
  File.open("README.md", "w") do |file|
    file.puts("Currently working at [#{WORK_NAME}](#{WORK_URL}), writing on my [personal website](#{PERSONAL_WEBSITE_URL}) or [twitter](#{TWITTER_URL}). Reach me: [#{PERSONAL_EMAIL}](mailto:#{PERSONAL_EMAIL}).\n\n")

    file.puts("Here are my latest kindle highlights:\n")

    highlights.slice(0, HIGHLIGHTS_LIMIT)&.each do |highlight|
      file.puts("> [#{highlight[:text]}](kindle://book?action=open&asin=#{highlight[:asin]}&location=#{highlight[:location]}) ―<cite>#{highlight[:title]}</cite>, #{highlight[:author]}\n\n")
    end

    file.puts("<a href='https://github.com/HarrisJT/HarrisJT/actions'><img src='https://github.com/HarrisJT/HarrisJT/workflows/Build%20README/badge.svg' align='right' alt='Build README'></a> <a href='https://github.com/HarrisJT/HarrisJT/blob/master/index.rb'>How this works</a>")
  end
end