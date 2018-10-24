class UsersController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy, :new_record, :add_record]
  before_action :ensure_correct_user, only: [:teacher, :show, :edit, :update, :destroy, :new_record, :add_record]
  before_action :correct_user, only: [:show_record]

  def index
  end

=begin
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
    logger.debug response
    @record = response["data"]["record"]
    @year = @record.map{|h| h["year"]}.uniq
    if params[:year].present? && params[:semester].present?
      @record = response["data"]["record"].select{|i| i["year"] == params[:year].to_i && i["semester"] == params[:semester].to_i}
    elsif params[:semester].present? && params[:year].blank?
      @record = response["data"]["record"].select{|i| i["semester"] == params[:semester].to_i}
    elsif params[:year].present? && params[:semester].blank?
      @record = response["data"]["record"].select{|i| i["year"] == params[:year].to_i}
    end

    if @record.blank?
      redirect_to users_show_record_path, alert: "成績がありません"
    end
    #response = HTTParty.post( "http://192.168.33.10:3000/graphql", headers: 'authenticity_token', body: {query: query})
  end
=end


  def show_record
    @name = current_student.name
    @stu_id = current_student.student_id
    @params2 = Hash["year" => params[:year].to_i, "semester" => params[:semester].to_i]
    @year = Record.where(student_id: @stu_id).order(year: :desc).pluck(:year).uniq
    @schema_frame = <<~XXX
    jpn
          math
          eng
          sci
          soc
          year
          semester
        }
    }
    XXX

    if !(@params2["year"].zero? || @params2["semester"].zero?)
      @query = <<~QUERY
        query($year: Int, $semester: Int){
            record(year: $year, semester: $semester){
              #{@schema_frame}
      QUERY
    elsif @params2["year"].zero? && !@params2["semester"].zero?
      @query = <<~QUERY
         query($semester: Int){
            record(semester: $semester){
              #{@schema_frame}
      QUERY
    elsif @params2["semester"].zero? && !@params2["year"].zero?
      @query = <<~QUERY
         query($year: Int){
            record(year: $year){
              #{@schema_frame}
      QUERY
    else
      @query = <<~QUERY
      {
          record{
            #{@schema_frame}
      QUERY
    end

      logger.debug @query
      response = execute
      #logger.debug response.inspect
      response["data"]["record"].each do |resarr|
        while resarr.value?(nil)
          resarr[resarr.key(nil)] = "未実施"
        end
      end
      logger.debug response.inspect
      @record = response["data"]["record"]
      logger.debug @record

    if @record.blank?
      redirect_to users_show_record_path, alert: "成績がありません"
    end

  end

  def show_all
    case params[:destroy_record] && params[:page].present?
    when true
      remreco = params[:page].keys.to_a.map(&:to_i)
      @query = <<~QUERY
          mutation {
            DeleteRecord(input: {id: #{remreco}}) {
              deletedId
            }
          }
      QUERY

      execute

      respond_to do |format|
        format.html { redirect_to "/users/teacher", notice: '削除しました' }
        format.json { head :no_content }
      end

    else
      @stu_id = nil
      #@params2 = Hash["year" => params[:year].to_i, "semester" => params[:semester].to_i]
      @allname = Student.all.pluck(:name)
      @year = Record.all.order(year: :desc).pluck(:year).uniq
      @query = <<~QUERY
          query{
            student {
              name
              records {
                edges {
                  node {
                    id
                    jpn
                    math
                    eng
                    sci
                    soc
                    year
                    semester
                  }
                }
              }
            }
          }
      QUERY

      response = execute
      r = 0
      response["data"]["student"].size.times{
        #logger.debug response["data"]["student"][r]["records"].flatten.inspect
        test = response["data"]["student"][r]["records"].flatten
        test.delete("edges")
        #logger.debug test["node"]["year"].inspect
        if params[:year].present? && params[:semester].present?
          test[0].select!{|i| i["node"]["year"] == params[:year].to_i && i["node"]["semester"] == params[:semester].to_i}
        elsif params[:semester].present? && params[:year].blank?
          test[0].select!{|i| i["node"]["semester"] == params[:semester].to_i}
        elsif params[:year].present? && params[:semester].blank?
          test[0].select!{|i| i["node"]["year"] == params[:year].to_i}
        end

        if test[0].present?
          test[0].each do |resarr|
            while resarr["node"].value?(nil)
              resarr["node"][resarr["node"].key(nil)] = "未実施"
            end
          end
        end
        r = r + 1
      }

      @record = response["data"]["student"]
      #logger.debug @record.inspect

      @norecord = @record.map{|i| i["records"]["edges"].empty?}

      if @norecord.all?{|no| no == true}
        redirect_to users_show_all_path, alert: "成績がありません"
      end
    end
  end

  def edit_record
    @ed_record = Record.find(params[:id])
  end

  def update_record
    emptyreco = params[:record].values.map{|i| i.empty?}
    unless emptyreco.all?{|no| no == false}
      flash[:notice] = '全て記入して下さい'
      redirect_to :action => "edit_record", :id => params[:id]
    end
    upamams = params[:record].values.map(&:to_i)
    @query = <<~QUERY
        mutation{
          UpdateRecord(input:{
            id: #{upamams[5]}
            jpn: #{upamams[0]}
            math: #{upamams[1]}
            eng: #{upamams[2]}
            sci: #{upamams[3]}
            soc: #{upamams[4]}
          }) {
            record{
              id
              student_id
              jpn
              math
              eng
              sci
              soc
              year
              semester
            }
          }
        }
    QUERY

    execute
    redirect_to "/users/show_all", notice: '更新しました'
  end

=begin
  def show_all
    @stu_id = nil
    @params2 = Hash["year" => params[:year].to_i, "semester" => params[:semester].to_i]
    @year = Record.all.order(year: :desc).pluck(:year).uniq
    @schema_frame = <<~XXX
    jpn
          math
          eng
          sci
          soc
          year
          semester
        }
      }
    }
    XXX

    if !(@params2["year"].zero? || @params2["semester"].zero?)
      @query = <<~QUERY
        query($year: Int, $semester: Int){
          student{
            name
            record(year: $year, semester: $semester){
              #{@schema_frame}
      QUERY
    elsif @params2["year"].zero? && !@params2["semester"].zero?
      @query = <<~QUERY
         query($semester: Int){
          student{
            name
            record(semester: $semester){
              #{@schema_frame}
      QUERY
    elsif @params2["semester"].zero? && !@params2["year"].zero?
      @query = <<~QUERY
         query($year: Int){
          student{
            name
            record(year: $year){
              #{@schema_frame}
      QUERY
    else
      @query = <<~QUERY
      query{
          student{
            name
            record{
            #{@schema_frame}
      QUERY
    end

      logger.debug @query
      response = execute
      logger.debug response.inspect
      n = 0
      response["data"]["student"].size.times{
        response["data"]["student"][n]["record"].each do |resarr|
          while resarr.value?(nil)
            resarr[resarr.key(nil)] = "未実施"
          end
        end
        n = n + 1
      }
      logger.debug response["data"]["student"].inspect
      @record = response["data"]["student"]
      logger.debug @record

    if @record.blank?
      redirect_to users_show_all_path, alert: "成績がありません"
    end
  end
=end

  def new_record
  end

=begin
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
=end

  def add_record
    @record_pre = record_params.to_h
    @record = @record_pre.map{|key,value|[key,value.to_i]}.to_h
    @stu_id = @record["student_id"]
    logger.debug @stu_id
    while @record.value?(0)
      logger.debug @record.key(0)
      @record[@record.key(0)] = "null"
    end
    if @record["year"] == "null" || @record["semester"] == "null"
      flash[:notice] = '必須項目は記入して下さい'
      logger.debug params[:id]
      redirect_to :action => "new_record", :id => params[:id]
    else
      @query =  <<~QUERY
        mutation{
          CreateRecord(input:{
            jpn: #{@record["jpn"]}
            math: #{@record["math"]}
            eng: #{@record["eng"]}
            sci: #{@record["sci"]}
            soc: #{@record["soc"]}
            year: #{@record["year"]}
            semester: #{@record["semester"]}
          }) {
            record{
              student_id
              jpn
              math
              eng
              sci
              soc
              year
              semester
            }
          }
        }
      QUERY
      logger.debug @query.inspect
      response = execute
      logger.debug response["error"].inspect
      redirect_to "/users/teacher", notice: '新規登録しました'
    end

  rescue ActiveRecord::RecordNotUnique => e
    logger.error e
    logger.error e.backtrace.join("\n")

    flash[:alert] = '既に成績データが入っています'
    render :new_record, :id => @student.id
  end

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
    params.require(:record).permit(:id, :student_id, :jpn, :math, :eng, :sci, :soc, :year, :semester)
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
    variables = ensure_hash(@params2)
    #query = params[:query]
    operation_name = params[:operationName]
    context = {
        # Query context goes here, for example:
        current_student: @stu_id,
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
