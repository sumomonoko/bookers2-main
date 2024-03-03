class BooksController < ApplicationController
  def create
    @book_new = Book.new(book_params)
    @book_new.user = current_user
    if @book_new.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book_new.id)
    else
      @books = Book.all
      @user = current_user
      flash.now[:alert]
      render :index
    end
  end

  def index
    @user = current_user
    @book_new = Book.new
    @books = Book.all
  end

  def edit
    is_matching_login_user
    @book = Book.find(params[:id])
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
  end

  def update
    is_matching_login_user
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id)
      flash[:notice] = "You have updated book successfully."
    else
      flash.now[:alert]
      render :edit
    end
  end


   # 投稿データのストロングパラメータ
  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user == current_user
      redirect_to books_path
    end
  end
end