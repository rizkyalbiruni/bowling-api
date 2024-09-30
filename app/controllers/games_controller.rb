class GamesController < ApplicationController
  before_action :set_game, only: %i[show update destroy]

  # GET /games
  def index
    @games = Game.all
    # rendering all game instances in json format
    render json: @games
  end

  # GET /games/1
  def show
    # this will scope the one specific game and all its children
    # pro : to provide developer more infos
    # con : will slow down the response time
    render json: @game, include: '**'
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

  # PATCH/PUT /games/:id
  def update
    # set_game
    # soal : the attribute of game which is current_game(int) is not used insted we use game.frames.find_by ???
    # soal : perlu  kita bataskan integer sesuai dgn peraturan game?
    @current_frame = @game.frames.find_by(frame_nth: params[:frame_nth])

    unless @current_frame
      @current_frame = Frame.new(game: @game, frame_nth: params[:frame_nth])
      @current_frame.save
    end

    # soal : is_strike and is_spare is both false, why use it as condition?
    # the first throw will always be false and result 2
    @max_throws = (@current_frame.is_strike || @current_frame.is_spare) && params[:throw_nth].to_i <= 3 ? 3 : 2

    if params[:throw_nth].to_i <= @max_throws
      @current_throw = Throw.new(frame: @current_frame, score: params[:score], throw_nth: params[:throw_nth])
      @current_throw.save

      if @current_throw.score == 10 && params[:throw_nth].to_i == 1
        @current_frame.is_strike = 1 # true
        @current_frame.save
      end

      if @current_throw.score == 10 && params[:throw_nth].to_i == 2 && @current_frame.is_strike == false
        @current_frame.is_spare = 1 # true
        @current_frame.save
      end
    end

    @current_frame.total_score = @current_frame.throws.sum(:score)
    @current_frame.save

    @game.total_score = @game.frames.sum(:total_score)

    if @game.save
      render json: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @game.destroy!
  end

  private

  # setting the game for show, update and destroy
  def set_game
    @game = Game.find(params[:id])
  end

  # strongg params
  def game_params
    params.require(:game).permit(:total_score, :current_frame)
  end
end
