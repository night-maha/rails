class UsersController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def index
  end

  def login
    #redirect_to '/users/index'
    @stu_id = params[:s_id]
    @stu_pass = params[:s_password]
    if !(@stu_id.empty? || @stu_pass.empty?)
      if @stu_id == "999999" && @stu_pass == "dr951kntq"
        redirect_to users_teacher_path
        # print cgi.header({"status" => "REDIRECT", "location" => teacher_url})
      else
        #検索結果の個数
        login_id = Student.where("student_id = ?", @stu_id).count
        #検索したユーザのパスワード
        login_pass = Student.select("password").where("student_id = ?", @stu_id)
        #検索結果によるエラー処理
        if login_id == 0
          redirect_to users_index_path, notice: "学籍番号かパスワードが間違っています"
        elsif login_id == 1
          redirect_to users_index_path, notice: "ok"
        else
          redirect_to users_index_path, notice: "管理者に連絡をしてください"
        end
      end
    elsif !(@stu_id.empty?)
      redirect_to users_index_path, notice: "パスワード入ってないよ"
    elsif !(@stu_pass.empty?)
      redirect_to users_index_path, notice: "学籍番号入ってないよ"
    else
      redirect_to users_index_path, notice: "両方入ってないよ"
    end
  end

  def teacher
    @students = Student.all
  end

  def show
  end

  def edit
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    respond_to do |format|
      if @student.save
        format.html { redirect_to "/users/teacher", notice: '新規登録しました' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to "/users/teacher", notice: '更新しました' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @student.destroy

    respond_to do |format|
      format.html { redirect_to "/users/teacher", notice: '削除しました' }
      format.json { head :no_content }
    end
  end

private
  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:student_id, :password, :name, :sex, :birthday)
  end
end
