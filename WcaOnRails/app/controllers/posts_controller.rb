class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :rss, :show]
  before_action :can_admin_results_only, except: [:index, :rss, :show]

  def index
    @posts = Post.where(world_readable: true).order(sticky: :desc, created_at: :desc).paginate(page: params[:page])
  end

  def rss
    @posts = Post.where(world_readable: true).order(created_at: :desc).paginate(page: params[:page])
    respond_to :xml
  end

  def show
    @post = find_post
  end

  def new
    @post = Post.new(params[:post] ? post_params : {})
  end

  def create
    @post = Post.new(post_params, world_readable: true)
    @post.author = current_user
    if @post.save
      flash[:success] = "Created new post"
      redirect_to post_path(@post.slug)
    else
      render 'new'
    end
  end

  def edit
    @post = find_post
  end

  def update
    @post = find_post
    if @post.update_attributes(post_params)
      flash[:success] = "Updated post"
      redirect_to post_path(@post.slug)
    else
      render 'edit'
    end
  end

  def destroy
    @post = find_post
    @post.destroy
    flash[:success] = "Deleted post"
    redirect_to root_url
  end

  private def editable_post_fields
    [:title, :body, :sticky]
  end
  helper_method :editable_post_fields

  private def post_params
    params.require(:post).permit(*editable_post_fields)
  end

  private def find_post
    # We explicitly query for slug rather than using an OR, because mysql does
    # weird things when searching for an id using a string:
    #  mysql> select id from posts where id="2014-foo";
    #  +------+
    #  | id   |
    #  +------+
    #  | 2014 |
    #  +------+
    #  1 row in set, 1 warning (0.00 sec)
    world_readable_posts = Post.where(world_readable: true)
    world_readable_posts.find_by_slug(params[:id]) || world_readable_posts.find_by_id!(params[:id])
  end
end
