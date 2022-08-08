require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ("A".."Z").to_a.sample }
    @letters
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def calculate_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def score
    @included = included?(params[:word].upcase, params[:grid_token])
    @english = english?(params[:word])
    @time_finished = Time.now
    @score_time = @time_finished - params[:time_token].to_datetime
    @score = calculate_score(params[:word], @score_time)
  end
end
