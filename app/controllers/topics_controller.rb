class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def show
    redirect_to action: :edit
  end

  def new
    build_topic
  end

  def edit
    load_topic
  end

  def create
    build_topic

    if @topic.save
      flash[:success] = "Topic successfully created!"
      redirect_to @topic
    else
      flash[:error] = "Topic could not be created"
      render "new", status: :unprocessable_entity
    end
  end

  def update
    load_topic
    build_topic

    if @topic.save
      flash[:success] = "Topic successfully updated!"
      redirect_to @topic
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @topic.destroy!

    respond_to do |format|
      format.html { redirect_to topics_path, status: :see_other, notice: "Topic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def build_topic
    @topic ||= topic_scope.new
    @topic.attributes = topic_params
  end

  def load_topics
    @topics ||= topic_scope
                 .ordered
                 .to_a
  end

  def topic_scope
    Topic.all
  end

  def load_topic
    @topic = topic_scope.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title)
  rescue ActionController::ParameterMissing
    {}
  end
end
