class InstagramWrapper

  def self.acts_as_locatable(query)
    define_method "filter_#{query}" do |options|
      location_images = self.send(query, options).delete_if { |i| i.location.nil?}
      location_images
    end
  end

  acts_as_locatable :tag_recent_media
  acts_as_locatable :media_search
  acts_as_locatable :user_recent_media
  acts_as_locatable :media_popular

  def tag_recent_media(options)
    tag = options[:tag] ? options[:tag] : nil
    Instagram.tag_recent_media(tag)
  end

  def media_search(options)
    lat = options[:lat] ? options[:lat] : nil
    lon = options[:lon] ? options[:lon] : nil
    dis = options[:distance] ? options[:distance] : 1000
    Instagram.media_search(lat, lon, :distance => dis)
  end

  def media_popular(options)
    Instagram.media_popular(options)
  end

  def user_recent_media(options)
    instagram_user = options[:user] ? options[:user] : nil
    Instagram.user_recent_media(instagram_user)
  end

end