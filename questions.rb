require_relative 'questions_db'
require_relative 'replies'

class Questions
  attr_accessor :id, :author_id, :title, :body
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datam| Questions.new(datam)}
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    Questions.new(data.first)
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    Questions.new(data.first)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def create
    raise "#{self} already in database" if self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author_id)
      INSERT INTO
        questions (title, body, author_id)
      VALUES
        (?, ?, ?)
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author_id, self.id)
      UPDATE
        questions
      SET
        title = ?, body = ?, author_id = ?
      WHERE
        id = ?
    SQL
  end
  def author 
    QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
    SELECT
      fname,lname
    FROM
      users
    WHERE
      id = ?
  SQL
  end

  def replies
    Replies.find_by_questions_id(self.id)
  end
end