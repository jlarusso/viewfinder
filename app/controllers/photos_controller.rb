class PhotosController < ApplicationController
  skip_before_filter :login_required, :only => "index"

  # GET /photos
  # GET /photos.json
  def index
    Instagram.configure do |config|
      config.client_id = ENV['INSTAGRAM_APP_ID']
      config.access_token = ENV['INSTAGRAM_TOKEN']
    end

    user_id = 305166995

    @recent_media = Instagram.user_recent_media(user_id)
    @popular_media = Instagram.media_popular
    @popular_media_with_locations = @popular_media.collect { |item| item if !item.location.nil? }

    @location_media = Instagram.media_search('40.734771', '-73.990722')
    @location_media_query = @location_media.collect do |pic|
      unless Photo.find_by_instagram_id(pic.id).nil?
        @photo = Photo.new({
          :image => pic.images.standard_resolution.url,
          :latitude => pic.location.latitude,
          :longitude => pic.location.longitude,
          :user_name => pic.user.full_name,        
          :location => pic.location.name,
          :link => pic.link,
          :instagram_id => pic.id
          })
        @photo.caption = pic.caption.text unless pic.caption.nil?
        @photo.save
      end
      Photo.find_by_instagram_id(pic.id) || @photo
    end

    binding.pry
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(params[:photo])

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end
end
