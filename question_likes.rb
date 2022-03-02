require_relative 'questions_db'

class QuestionLikes
  attr_accessor :id, :users_id, :questions_id, :likes
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    data.map { |datam| QuestionLikes.new(datam)}
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    QuestionLikes.new(data.first)
  end

  def initialize(options)
    @id = options['id']
    @likes = options['likes']
    @questions_id = options['questions_id']
    @users_id = options['users_id']
  end

  def create
    raise "#{self} already in database" if self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.likes, self.users_id, self.questions_id)
      INSERT INTO
        question_likes (likes, users_id, questions_id)
      VALUES
        (?, ?, ?)
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.likes, self.users_id, self.questions_id, self.id)
      UPDATE
        question_likes
      SET
        likes = ?, users_id = ?, questions_id = ?
      WHERE
      id = ?
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end
end