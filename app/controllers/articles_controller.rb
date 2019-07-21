class ArticlesController < ApplicationController
  SOURCE = 'en'
  RANK = 3
  MAX_WORDS = 10

  def create
    session[:client_id] = SecureRandom.hex(10)

    article
    phrases
    translated_words
    images

    words = phrases.each_with_index.map do |word, index|
      Word.new(
        source: word,
        translation: translated_words[index],
        image_url: images[index],
        target: 'ru',
        rank: RANK,
        client_id: session[:client_id]
      )
    end

    ActiveRecord::Base.transaction do
      Word.where(client_id: session[:client_id]).delete_all
      Word.import(words)
    end

    redirect_to articles_path
  end

  def index
    @words = Word.where(client_id: session[:client_id]).where.not(rank: nil).where('rank > ?', 0)
    @word = @words.sample
    p @word
    @word_id = @word.id
    @word_size = @word.translation.size
  end

  def show
  end

  private

  def article
    @article ||= begin
      response = Unirest.get('https://lexper.p.rapidapi.com/v1.1/extract?media=1&url=' + params[:url],
        headers:{
          'X-RapidAPI-Host' => 'lexper.p.rapidapi.com',
          'X-RapidAPI-Key' => '769a941146msh2d8bcd500ef3f42p19b6a3jsndf27f1cc622c'
        })
      JSON.parse(response.raw_body)['article']['text']
    end
  end

  def phrases
    @phrases ||= begin
      response = Unirest.post('https://textanalysis.p.rapidapi.com/spacy-noun-chunks-extraction',
        headers:{
          'X-RapidAPI-Host' => 'textanalysis.p.rapidapi.com',
          'X-RapidAPI-Key' => '769a941146msh2d8bcd500ef3f42p19b6a3jsndf27f1cc622c',
          'Content-Type' => 'application/x-www-form-urlencoded'
        },
        parameters:{ 'text' => article })
      JSON.parse(response.raw_body)['result'].map do |phrase|
        phrase.gsub(/[^\w\s]/, '').downcase
      end.compact.uniq[0..MAX_WORDS]
    end
  end

  def translated_words
    @translated_words ||= begin
      phrases.map do |phrase|
        response = Unirest.get("https://systran-systran-platform-for-language-processing-v1.p.rapidapi.com/translation/text/translate?source=#{SOURCE}&target=#{target}&input=#{phrase}",
          headers:{
            'X-RapidAPI-Host' => 'systran-systran-platform-for-language-processing-v1.p.rapidapi.com',
            'X-RapidAPI-Key' => '769a941146msh2d8bcd500ef3f42p19b6a3jsndf27f1cc622c'
          })
        JSON.parse(response.raw_body)['outputs'].first['output'][0..10]
      end
    end
  end

  def images
    @images ||= phrases.map { |word| image(word) }
  end

  def image(word)
    response = Unirest.get("https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/ImageSearchAPI?autoCorrect=false&pageNumber=1&pageSize=10&q=#{word}&safeSearch=true",
      headers:{
        'X-RapidAPI-Host' => 'contextualwebsearch-websearch-v1.p.rapidapi.com',
        'X-RapidAPI-Key' => '769a941146msh2d8bcd500ef3f42p19b6a3jsndf27f1cc622c'
      })
    JSON.parse(response.raw_body)['value'].first['thumbnail']
  rescue URI::InvalidURIError
    nil
  end

  def target
    params[:target]
  end
end