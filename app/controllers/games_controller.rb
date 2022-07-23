require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = generate_grid(9).join(" ")
  end

  def score
    input = params[:answer]
    @grid = params[:letters]

    url = "https://wagon-dictionary.herokuapp.com/#{input}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    if word["found"] == true && check_against_grid(input)
      @score = 10
      @message = "Congratulations"
    elsif word["found"] == false
      @score = 0
      @message = "Sorry, try again"
    else
      @score = 0
      @message = "The word can’t be built out of the original grid"
    end
  end
end

private
def generate_grid(grid_size)
  # TODO: generate random grid of letters
  Array.new(grid_size) { ('A'..'Z').to_a.sample }
end

def check_against_grid(input)
  letters = input.split(//)
  letters.each do |letter|
    return false if @grid.include?(letter.upcase) == false
  end
end
