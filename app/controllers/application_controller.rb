class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end
  # Removes specified item by id
  delete '/reviews/:id' do
    review = Review.find(params[:id])
    review.destroy
    review.to_json
  end

  # add new review to the db
  post '/reviews' do
    new_review = Review.create("comment": params[:comment], "score": params[:score], "game_id": params[:game_id], "user_id":params[:user_id])
    new_review.to_json
  end 
  patch '/reviews/:id' do
    new_review = Review.update("comment": params[:comment], "score": params[:score])
    Review.find(params[:id]).to_json
  end

end
