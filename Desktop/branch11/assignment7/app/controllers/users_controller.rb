class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token ,only: %i[login]
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :landing_page, only: [:login,:new,:index]
  before_action :logged_in , except: %i[login index new create profile profileUpdate destroy_all likeUpdate]

  # GET /users or /users.json
  def index
    @users = User.all
  end
  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create


    @user = User.new(user_params)
    checkPassword = @user.check_password(params[:user][:password_confirmation])
    checkEmail = @user.check_email
    checkName = @user.check_name

    respond_to do |format|
      if checkPassword && checkEmail && checkName && @user.save

        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def destroy_all

    Post.destroy_all
    Follow.destroy_all
    User.destroy_all
    redirect_to users_path ,notice: "All of user successfully destroyed."
  end

  def login
    @user = User.new(user_params)
    respond_to do |format|
      if(@user.login)
        session[:user_id] = @user.id
        format.html { redirect_to "/feed/#{@user.id}"}
      else
        session[:user_id] = nil
        format.html {render template: 'main/login',status: :unprocessable_entity}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by_id(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def logged_in
    @user = User.find_by_id(params[:id])
    if(@user && session[:user_id] == @user.id)
      return true
    else
      session[:user_id] = nil
      redirect_to main_path , notice: "Please login"
    end
  end


  public


  def feed
    @user = User.find(session[:user_id])
    @post= @user.get_feed_post



  end

  def profile
    @post = nil
    if(!User.find_by_name(params[:name]))
      redirect_to "/feed/#{session[:user_id]}"
    else
      @check_follow = Follow.find_by(followee_id:session[:user_id],following_id:User.find_by_name(params[:name]).id)
      user = User.find_by_name(params[:name])
      @post = user.getProfile
      @user = User.find_by_id(session[:user_id])

    end






  end

  def profileUpdate
    @user = User.find(session[:user_id])
    @other_user = User.find_by_name(params[:name])

    @check_follow = Follow.find_by(followee_id:@user.id,following_id:@other_user.id)
    if(@check_follow)
      ActiveRecord::Base.connection.execute("DELETE FROM follows WHERE followee_id=#{@user.id} and following_id=#{@other_user.id}")
      redirect_to "/profile/#{params[:name]}"
    else
      Follow.create(followee_id:@user.id,following_id:@other_user.id)
      redirect_to "/profile/#{params[:name]}"
    end
  end

  def likeUpdate
    @user = User.find(session[:user_id])
    @post = Post.find(params[:postID])
    @checkLike = Like.find_by(user_id:@user.id,post_id:@post.id)
    if @checkLike
      ActiveRecord::Base.connection.execute("DELETE FROM likes WHERE post_id=#{@post.id} AND user_id=#{@user.id}")
      redirect_to "/feed/#{session[:user_id]}"
    else
      @user.likes.create(post:@post)
      redirect_to "/feed/#{session[:user_id]}"
    end


  end




end
