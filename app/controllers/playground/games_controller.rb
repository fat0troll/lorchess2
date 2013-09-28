require 'digest/md5'

class Playground::GamesController < ApplicationController
  def index
  end

  def new_game
  end

  def create
    if Games.last != nil
      number = Games.last.id + 1
    else
      number = 1
    end
    token = Digest::MD5.hexdigest(rand.to_s)
    Games.create(id: number, time: params[:time]*60, fischer: params[:fischer])
    if params[:player] == "black"
      Games.find(number).update_attributes(:black => token)
    elsif params[:player] == "white"
      Games.find(number).update_attributes(:white => token)
    end
    cookies[:token] = token
    redirect_to "/playground/games/" + number.to_s
  end

  def show
    @id = Games.find(params[:id])
  end
end
