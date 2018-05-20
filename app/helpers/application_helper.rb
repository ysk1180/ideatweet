module ApplicationHelper
  def get_twitter_card_info(post)
    twitter_card = {}
    if post.present?
      if post.id.present?
        twitter_card[:url] = "https://ideatweet.herokuapp.com/posts/#{post.id}"
        twitter_card[:image] = "https://s3-ap-northeast-1.amazonaws.com/ideatweet-production2/images/#{post.id}.png"
      else
        twitter_card[:url] = 'https://ideatweet.herokuapp.com/'
        twitter_card[:image] = "https://raw.githubusercontent.com/ysk1180/ideatweet/master/app/assets/images/top.png"
      end
    else
      twitter_card[:url] = 'https://ideatweet.herokuapp.com/'
      twitter_card[:image] = "https://raw.githubusercontent.com/ysk1180/ideatweet/master/app/assets/images/top.png"
    end
    twitter_card[:title] = "アイデアtweet"
    twitter_card[:card] = 'summary_large_image'
    twitter_card[:description] = '全てのアイデアは組み合わせ！2つのランダムなキーワードから発想したアイデアをツイートできるサービスです'
    twitter_card
  end
end
