class TweetTransformer
  def self.replace_links(text, urls)
    urls.each do |u|
      text.gsub!(u.url.to_s, u.expanded_url.to_s)
    end
    text
  end

  def self.replace_mentions(text)
    twitter_mention_regex = /(\s|^.?)(@[A-Za-z0-9_]+)(?=[^A-Za-z0-9_@]|$)/
    text.gsub(twitter_mention_regex, '\1\2@twitter.com')
  end

  def self.detect_cw(text)
    format = /^([CT]W:?|TW\s*[\/,]\s*CW[:,]?|CW\s*[\/,]\s*TW[:,]?)\s+(?<cw>[^\n\r]+)[\n\r]+(?<text>.*)/im
    rt_format = /^([CT]W:?|TW\s*[\/,]\s*CW[:,]?|CW\s*[\/,]\s*TW[:,]?)\s+(?<cw>.+) (?<text>https:\/\/twitter\.com.*)/im

    m = format.match(text)
    return [m[:text], m[:cw]] if m

    m = rt_format.match(text)
    return ["RT: #{m[:text]}", m[:cw]] if m

    return [text, nil]
  end
end
