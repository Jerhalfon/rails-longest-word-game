require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      letter = ('a'..'z').to_a.sample
      @letters << letter
    end
  end

  def score
    @word = params[:word]
    @grid = params[:letters].split(' ')
    if !word_is_included?(@word)
      @message = "Sorry but #{@word} can't be built out of #{@grid}"
    elsif !english_word?(@word)
      @message = "Sorry but #{@word} does not seem to be a valid English word"
    else
      @message = "CONGRATULATIONS! #{@word} is a valid English word"
    end
  end

  def word_is_included?(word)
    result = true
    word.split('').each do |letter|
      if @grid.include?(letter)
        @grid.delete_at(@grid.index(letter))
        result = true
      else
        return false
      end
    end
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end
end
