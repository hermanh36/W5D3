require_relative "questions_db"

class QuestionFollows
  attr_accessor :id, :users_id, :questions_id
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map {|datum| QuestionFollows.new(datum)}
  end

  def self.find_by_question_id(questions_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, questions_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        author_id = ?
    SQL
    QuestionFollows.new(data.first)
  end
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    QuestionFollows.new(data.first)
  end

  def initialize(options)
    @id = options['id']
    @users_id = options['users_id']
    @questions_id = options['questions_id']
  end

  def create 
    raise "#{self} already in database" if self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.users_id, self.questions_id)
      INSERT INTO
      question_follows (users_id,questions_id)
      VALUES
        (?, ?)
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} is not in database" unless self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.users_id, self.questions_id, self.id)
      UPDATE
        question_follows
      SET
        users_id = ?, questions_id = ?
      WHERE
        id = ?
    SQL
  end
end