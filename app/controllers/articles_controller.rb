class ArticlesController < ApplicationController

  def index
    @articles = Article.find(:all)
  end
  
  def show
    @article = Article.find(params[:id])
    @comment = Comment.new(:article => @article)
  end
  
  def new
    if current_user
      @article = Article.new
    else
      flash[:notice] = "Must be logged in."
      redirect_to root_url
    end      
  end
  
  def create
    if current_user
      @article = Article.new(params[:article])
      if @article.save
        flash[:notice] = "Successfully created article."
        redirect_to @article
      else
        render :action => 'new'
      end
    else
      flash[:notice] = "Must be logged in."
      redirect_to root_url
    end
  end
  
  def edit
    if current_user
      @article = Article.find(params[:id])
    else
      flash[:notice] = "Must be logged in."
      redirect_to root_url
    end
  end
  
  def update
    if current_user
      @article = Article.find(params[:id])
      if @article.update_attributes(params[:article])
        flash[:notice] = "Successfully updated article."
        redirect_to @article
      else
        render :action => 'edit'
      end
    else
      flash[:notice] = "Must be logged in."
      redirect_to root_url
    end
  end
  
  def destroy
    if admin_user
      @article = Article.find(params[:id])
      @article.destroy
      flash[:notice] = "Successfully destroyed article."
      redirect_to articles_url
    else
      flash[:notice] = "Must be an admin."
      redirect_to root_url
    end
  end

end
