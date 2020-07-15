require "kindle_highlights"

WORK_NAME = "ABODO"
WORK_URL = "https://abodo.com/about"
PERSONAL_WEBSITE_URL = "https://harrisjt.com"
PERSONAL_EMAIL = "harris@harrisjt.com"
TWITTER_URL = "https://twitter.com/harrisjt_"
HIGHLIGHTS_LIMIT = 10

DEFAULT_QUOTES = [
    {
        text: "All of humanity's problems stem from man's inability to sit quietly in a room alone.",
        title: "Pensées",
        author: "Blaise Pascal"
    },{
        text: "The meaning of life is just to be alive. It is so plain and so obvious and so simple. And yet, everybody rushes around in a great panic as if it were necessary to achieve something beyond themselves.",
        title: "The Culture of Counter-Culture",
        author: "Alan Watts"
    },{
        text: "If you want to be given everything, give everything up.",
        title: "Tao Te Ching",
        author: "Lao Tzu"
    },{
        text: "The universe is not here to please you.",
        title: "Do you mind if I rant a minute?",
        author: "Charles Murtaugh"
    },{
        text: "If you want to improve, be content to be thought foolish and stupid.",
        title: "Lectures",
        author: "Epicetus"
    },
]

kindle = KindleHighlights::Client.new(
    email_address: ENV["AMAZON_USER"],
    password: ENV["AMAZON_PASS"]
)

File.open("README.md", "w") do |file|
  file.puts("Currently working on [#{WORK_NAME}](#{WORK_URL}), read my [website](#{PERSONAL_WEBSITE_URL}) or [twitter](#{TWITTER_URL}), reach me: [#{PERSONAL_EMAIL}](mailto:#{PERSONAL_EMAIL}).\n\n")

  highlights = []

  kindle.books.each do |book|
    next if book.asin.blank?

    kindle.highlights_for(book.asin).each do |highlight|
      if highlight.text.present?
        formatted_highlight = {
            title: book.title,
            author: book.author,
            asin: book.asin,
            text: highlight.text,
            location: highlight.location,
        }
        highlights << formatted_highlight
      end
    end
  end

  if highlights.length.positive?
    file.puts("Here are my latest kindle highlights:\n")

    highlights.slice(0, HIGHLIGHTS_LIMIT)&.each do |highlight|
      file.puts("> [#{highlight[:text]}](kindle://book?action=open&asin=#{highlight[:asin]}&location=#{highlight[:location]}) ―<cite>#{highlight[:title]}</cite>, #{highlight[:author]}\n\n")
    end
  else
    file.puts("Here are my latest favorite quotes:\n")

    DEFAULT_QUOTES.slice(0, HIGHLIGHTS_LIMIT)&.each do |highlight|
      file.puts("> #{highlight[:text]} ―<cite>#{highlight[:title]}</cite>, #{highlight[:author]}\n\n")
    end
  end

  file.puts("<a href='https://github.com/HarrisJT/HarrisJT/actions'><img src='https://github.com/HarrisJT/HarrisJT/workflows/Build%20README/badge.svg' align='right' alt='Build README'></a> <a href='https://github.com/HarrisJT/HarrisJT/blob/master/index.rb'>How this works</a>")
end