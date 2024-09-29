class GamesController < ApplicationController
  before_action :set_game, only: %i[ show update destroy ]

  # GET /games
  def index
    @games = Game.all
    render json: @games
  end

  # GET /games/1
  def show
    render json: @game
  end

  # POST /games
  def create
    @game = Game.new(game_params)

    if @game.save
      render json: @game, status: :created, location: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /games/1
  def update
    @current_frame = @game.frames.find_by(frame_nth: params[:frame_nth])

    unless @current_frame
      @current_frame = Frame.new(game: @game, frame_nth: params[:frame_nth])
      @current_frame.save
    end

    @max_throws = (@current_frame.is_strike || @current_frame.is_spare) && params[:throw_nth].to_i == 2 ? 3 : 2

    if params[:throw_nth].to_i <= @max_throws
      @current_throw = Throw.new(frame: @current_frame, score: params[:score], throw_nth: params[:throw_nth])
      @current_throw.save

      if @current_throw.score == 10 && params[:throw_nth].to_i == 1
        @current_frame.is_strike = true
        @current_frame.save
      end

      if @current_throw.score == 10 && params[:throw_nth].to_i == 2 && @current_frame.is_strike == false
        @current_frame.is_spare = true
        @current_frame.save
      end
    end

    @current_frame.total_score = @current_frame.throws.sum(:score)
    @current_frame.save

    @game.total_score = @game.frames.sum(:total_score)
    @game.save

    if @game.update(game_params)
      render json: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # DELETE /games/1
  def destroy
    @game.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:id)
    end
end
