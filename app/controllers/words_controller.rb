class WordsController < ApplicationController
  def check
    word = Word.where(id: params[:word_id], translation: params[:translation]).first
    word.update(rank: word.rank - 1) if word
    render json: { error: !word }
  end

  def translation
    word = Word.where(id: params[:word_id], translation: params[:translation]).first
    word.update(rank: word.rank - 1) if word
    render json: { error: !word }
  end

  def source
    word = Word.where(id: params[:word_id], source: params[:source]).first
    word.update(rank: word.rank - 1) if word
    render json: { error: !word }
  end
end
