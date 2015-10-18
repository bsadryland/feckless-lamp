class MentionsController < ApplicationController
  before_action :set_mention, only: [:show, :edit, :update, :destroy]

  # GET /mentions
  # GET /mentions.json
  def index
    @mentions = Mention.all
    # logger.debug "MENTIONS INDEX #{@mentions.count}"
  end

  # GET /mentions/fetch
  def fetch
    # logger.debug "ARGUMENTS #{fetch_params}"
    new_mentions = TwitterClient.mentions_timeline(fetch_params)
    @new_mentions = []
    new_mentions.each_index do |i|
      @new_mentions[i] = create new_mentions[i]
    end
    # logger.debug "NEW_MENTIONS #{@new_mentions}"
  end

  # GET /mentions/1
  # GET /mentions/1.json
  def show
  end

  # GET /mentions/new
  def new
    @mention = Mention.new
  end

  # GET /mentions/1/edit
  def edit
  end

  # POST /mentions
  # POST /mentions.json
  def create new_mention
    mention = Mention.new({ tweet_id: new_mention.id,
      user_id: new_mention.user.id,
      name: new_mention.user.name,
      screen_name: new_mention.user.screen_name,
      text: new_mention.text,
      mentioned_at: new_mention.created_at,
      profile_image_url: new_mention.user.profile_image_url.to_s })
    mention.save
    return mention
  end

  # PATCH/PUT /mentions/1
  # PATCH/PUT /mentions/1.json
  def update
    respond_to do |format|
      if @mention.update(mention_params)
        format.html { redirect_to @mention, notice: 'Mention was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mention.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mentions/1
  # DELETE /mentions/1.json
  def destroy
    @mention.destroy
    respond_to do |format|
      format.html { redirect_to mentions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mention
      @mention = Mention.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mention_params
      params.require(:mention).permit(:body)
    end

    def fetch_params
      params.permit(:since_id)
    end
end
