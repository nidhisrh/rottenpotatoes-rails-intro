class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort, :direction)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if(!(Movie.column_names.include?(params[:sort]) &&%w[asc desc].include?(params[:direction]) && params[:ratings].present?))
      redirect_to movies_path(sort: sort_column,direction: sort_direction, ratings: filter_ratings)
    end
    @movies = Movie.order('lower('+sort_column+')' + " " + sort_direction)
    @movies = @movies.where(:rating => filter_ratings.keys)
    @all_ratings = all_ratings
    @selected_ratings = filter_ratings

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def sort_column
    session[:sort] =  Movie.column_names.include?(params[:sort]) ? params[:sort] : (Movie.column_names.include?(session[:sort]) ? session[:sort] : "title")
    session[:sort]
  end

  def sort_direction
    session[:direction] = %w[asc desc].include?(params[:direction]) ? params[:direction] : (%w[asc desc].include?(session[:direction]) ? session[:direction] : "asc")
    session[:direction]
  end
  
  def all_ratings
    Movie.pluck(:rating).uniq
  end
  
  def rating_with_keys
    a = Hash.new
    for rating in all_ratings
     a[rating] = rating
    end
    a
  end
  
  def filter_ratings
   session[:ratings] =  params[:ratings].present? ? params[:ratings] : (session[:ratings].present? ? session[:ratings] : rating_with_keys)
   session[:ratings]
  end

end
