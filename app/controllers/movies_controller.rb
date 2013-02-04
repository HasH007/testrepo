class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sortcolumn = params[:sortcolumn]
    @all_ratings = getAllRatings


    rating_hash = params[:ratings]
    print "**************** #{rating_hash.class} ****************"

    if(rating_hash == nil && @sortcolumn == nil)
	if(session[:sc] != nil || session[:sr] != nil)
	    flash.keep
	    if(session[:sc] != nil && session[:sr] != nil)
		redirect_to movies_path(:sortcolumn=>session[:sc], :ratings=>session[:sr].join(" "))
	    elsif(session[:sc] != nil)
		redirect_to movies_path(:sortcolumn=>session[:sc])
	    else
		redirect_to movies_path(:ratings=>session[:sr].join(" "))
	    end
	end
    end

    if(rating_hash != nil)
	print "**************** #{rating_hash.class} ****************"
	@selected_ratings = (rating_hash.class == String) ? rating_hash.split(" ") : rating_hash.keys
    else
	@selected_ratings = getAllRatings
    end

    session[:sc] = @sortcolumn
    session[:sr] = @selected_ratings

    if(@sortcolumn == "Title")
       	@movies = Movie.where(:rating=> @selected_ratings).order('title ASC')
    elsif(@sortcolumn == "Release Date")
       	@movies = Movie.where(:rating=> @selected_ratings).order('release_date ASC').all
    else
       	@movies = Movie.where(:rating=> @selected_ratings)
    end   
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def getAllRatings
	Movie.select(:rating).map(&:rating).uniq
  end

end
