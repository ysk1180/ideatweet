class PostsController < ApplicationController
  before_action :set_post, only: [:confirm, :edit, :update]
  before_action :new_post, only: [:show, :new]

  def show
    @post.id = params[:id]
    render :new
  end

  def new
  end

  def edit
  end

  def create
    @post = Post.new
    if Post.last.present?
      next_id = Post.last.id + 1
    else
      next_id = 1
    end
    make_picture(next_id)
    if @post.save
      redirect_to confirm_path(@post)
    else
      render :new
    end
  end

  def update
    make_picture(@post.id)
    redirect_to confirm_path(@post)
  end

  def confirm
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def new_post
    @post = Post.new
  end

  def make_picture(id)
    @post.seed1_id = rand(Seed.last.id) + 1
    @post.seed2_id = rand(Seed.last.id) + 1
    while @post.seed1_id == @post.seed2_id
      @post.seed2_id = rand(Seed.last.id + 1)
    end
    sentense1 = @post.seed1.content + "\n\n" + @post.seed2.content
    sentense2 = "×"
    pointsize1 = 140
    pointsize2 = 100
    color1 = "yellow"
    color2 = "white"
    draw1 = "text 0,0 '#{sentense1}'"
    draw2 = "text 0,0 '#{sentense2}'"
    font = ".fonts/GenEiGothicN-U-KL.otf"
    base = "app/assets/images/black.jpg"
    image = MiniMagick::Image.open(base)
    image.combine_options do |i|
      i.font font
      i.fill color1
      i.gravity 'center'
      i.pointsize pointsize1
      i.draw draw1
    end
    image.combine_options do |i|
      i.font font
      i.fill color2
      i.gravity 'center'
      i.pointsize pointsize2
      i.draw draw2
    end
    storage = Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1'
    )
    # ⑨-13 開発環境or本番環境でS3のバケット（フォルダのようなもの）を分ける
    case Rails.env
      when 'production'
        bucket = storage.directories.get('ideatweet-production2')
        png_path = 'images/' + id.to_s + '.png'
        image_uri = image.path
        file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
        @post.picture = 'https://s3-ap-northeast-1.amazonaws.com/ideatweet-production2' + "/" + png_path
      when 'development'
        bucket = storage.directories.get('ideatweet-development2')
        png_path = 'images/' + id.to_s + '.png'
        image_uri = image.path
        file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
        @post.picture = 'https://s3-ap-northeast-1.amazonaws.com/ideatweet-development2' + "/" + png_path
    end
  end
end
