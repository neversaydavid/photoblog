require 'liquid'
require 'fleakr'

Fleakr.api_key = ENV['FLICKR_API_KEY']
Fleakr.shared_secret = ENV['FLICKR_SHARED_SECRET']
Fleakr.auth_token = ENV['FLICKR_AUTH_TOKEN']

CACHED_IMAGES = {}

module Flickr

  def flickr_responsive_image(url)
    image = image_object(url)
    "<figure class='flickr-image align-center' #{image[:sizes].map{|s| "data-media#{s.first}='#{s.last}'"}.join(" ")} alt='#{image[:title]}' title='#{image[:title]}'>
    <noscript>
      <img class='flickr-image align-center' alt='#{image[:title]}' src='#{image[:sizes][1024]}'>
    </noscript>
    </figure>
    "
  end

  def flickr_image(url)
    "<img alt='#{image_object(url)[:title]}' src='#{image_object(url)[:sizes][800]}'>"
  end

  def flickr_medium_image(url)
    "<img alt='#{image_object(url)[:title]}' src='#{image_object(url)[:sizes][1024]}'>"
  end

  private

  def image_object(url)
    CACHED_IMAGES[url] ||= fleakr_to_hash(url)
  end

  def fleakr_to_hash(url)
    fleakr_image = Fleakr.resource_from_url(url)
    image = {:sizes => {}}

    image[:sizes][nil] = fleakr_image.medium.url unless fleakr_image.medium.nil?
    image[:sizes][fleakr_image.small_320.width.to_i] = fleakr_image.small_320.url unless fleakr_image.small_320.nil?
    image[:sizes][fleakr_image.medium.width.to_i] = fleakr_image.medium.url unless fleakr_image.medium.nil?
    image[:sizes][fleakr_image.medium_640.width.to_i] = fleakr_image.medium_640.url unless fleakr_image.medium_640.nil?
    image[:sizes][fleakr_image.medium_800.width.to_i] = fleakr_image.medium_800.url unless fleakr_image.medium_800.nil?
    image[:sizes][fleakr_image.large.width.to_i] = fleakr_image.large.url unless fleakr_image.large.nil?
    image[:sizes][fleakr_image.large_1600.width.to_i] = fleakr_image.large_1600.url unless fleakr_image.large_1600.nil?
    image[:sizes][fleakr_image.large_2048.width.to_i] = fleakr_image.large_2048.url unless fleakr_image.large_2048.nil?

    image[:title] = fleakr_image.title

    image
  end
end

Liquid::Template.register_filter(Flickr)