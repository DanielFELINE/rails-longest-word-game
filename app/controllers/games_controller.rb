require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @start_time = params[:start_time].to_time
    @letters = params[:letters]
    @attempt = params[:attempt]
    @end_time = Time.now
    @result = @start_time - @end_time
    if included?(@attempt, @letters)
      @answer = 'good'
      if english_word?(@attempt)
        @answer = "#{@attempt.upcase} est un excellent mot, vous avez #{(compute_score(@attempt) * 2 * (1.0 - (@result / 10))).round(2)} points"
      else
        @answer = "#{@attempt.upcase} does not exist ! Zéro point gros nul !!!"
      end
    else
      @answer = "You can't do #{@attempt.upcase} with #{@letters}. Zéro point dans ta face "
    end
  end

  def included?(attempt, letters)
    attempt.upcase.chars.all? do |letter|
      letters.include?(letter)
    end
  end

  def compute_score(attempt)
    attempt.size
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
