require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    result = {}
    @word = params[:word]
    @grid = params[:grid]

    if in_grid?(@word.upcase, @grid)
      if english?(@word)
        result[:score] = score_calc(@word)
        result[:message] = "Congratulations! #{@word} is a valid english word"
      else
        result[:score] = 0
        result[:message] = "#{@word} is not an english word!"
      end
    else
      result[:score] = 0
      result[:message] = "Sorry but #{@word} can't be built out of #{@letters}"
    end
    @message = result[:message]
  end

  def in_grid?(word, grid)
    word.split('').each do |letter|
      if word.count(letter) <= grid.count(letter)
        return true
      end
    end
  end

  def english?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def score_calc(attempt)
    @score = (attempt.length * 100)
  end
end
