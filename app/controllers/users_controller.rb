class UsersController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy, :new_record, :add_record]
  before_action :ensure_correct_user, only: [:teacher, :show, :edit, :update, :destroy, :new_record, :add_record]
  before_action :correct_user, only: [:show_record]

  def index
  end

  def show_record
    @name = current_student.name
    @stu_id = current_student.student_id
    @query = <<~QUERY
      {
          record{
            jpn
            math
            eng
            sci
            soc
            year
            semester
          }
      }
    QUERY
    response = execute
    #response = HTTParty.post( "http://192.168.33.10:3000/graphql", headers: 'authenticity_token', body: {query: query})
    #logger.debug response
    @record = response["data"]["record"]
  end

  def new_record
    @record = Record.new
  end

  def add_record
    @record = Record.new(record_params)
    respond_to do |format|
      if @record.save
        format.html { redirect_to "/users/teacher", notice: '新規登録しました' }
        format.json { render :add_record, status: :created, location: @record }
      else
        # render :new_record, :id => @student.id
        flash[:notice] = '必須項目は記入して下さい'
        format.html { render :new_record, :id => @student.id }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotUnique => e
    logger.error e
    logger.error e.backtrace.join("\n")

    flash[:alert] = '既に成績データが入っています'
    render :new_record, :id => @student.id
  end

=begin
  def login
    #redirect_to '/users/index'
    @stu_id = params[:s_id]
    @stu_pass = params[:s_password]
    if !(@stu_id.empty? || @stu_pass.empty?)
      if @stu_id == "999999" && @stu_pass == "dr951kntq"
        redirect_to users_teacher_path
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
      redirect_to users_index_path, notice: "パスワード入ってないよ
    elsif !(@stu_pass.empty?)"
      redirect_to users_index_path, notice: "学籍番号入ってないよ"
    else
      redirect_to users_index_path, notice: "両方入ってないよ"
    end
  end
=end

  def login
    @teacher = Teacher.find_by(teacher_id: params[:s_id], password: params[:s_password])
    if @teacher
      session[:s_id] = params[:s_id]
      session[:teacher_name] = @teacher.name
      redirect_to users_teacher_path, notice: "ログインしました"
    else
      @name = params[:s_id]
      @password = params[:s_password]
      redirect_to users_index_path, notice: "学籍番号かパスワードが間違っています"
    end
  end

  def logout
    session[:s_id] = nil
    session[:teacher_name] = nil
    redirect_to users_index_path, notice: "ログアウトしました"
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

  def record_params
    params.require(:record).permit(:student_id, :jpn, :math, :eng, :sci, :soc, :year, :semester)
  end

  def correct_user
    if current_student.blank? == true
      redirect_to root_url, notice: '不正なアクセスです'
    end
  end

  def ensure_correct_user
    @teacher = Teacher.pluck("teacher_id")
    logger.debug("番号：#{session[:s_id].to_i}")
    unless @teacher.include?(session[:s_id].to_i)
      flash[:notice] = "権限がありません"
      redirect_to("/users/index")
    end
  end

  def execute
    variables = ensure_hash(params[:variables])
    #query = params[:query]
    operation_name = params[:operationName]
    context = {
        # Query context goes here, for example:
        current_student: current_student.student_id,
    }
    result = ExamRecordSchema.execute(@query, variables: variables, context: context, operation_name: operation_name)
    #render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { error: { message: e.message, backtrace: e.backtrace }, data: {} }, status: 500
  end
end
