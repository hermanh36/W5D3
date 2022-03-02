
require_relative "questions_db"
 
class Replies
  attr_accessor :body_reply, :parents_id, :questions_id, :users_id, :id
  def self.all 
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map{|datum| Replies.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        replies
      WHERE 
        id = ?;
    SQL
    Replies.new(data.first)
  end
   def self.find_by_questions_id(questions_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, questions_id)
      SELECT
        *
      FROM 
        replies
      WHERE 
        questions_id = ?;
    SQL
    Replies.new(data.first)
  end

   def self.find_by_users_id(users_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, users_id)
      SELECT
        *
      FROM 
        replies
      WHERE 
        users_id = ?;
    SQL
    Replies.new(data.first)
  end
  
  def initialize(options)
    @id = options['id']
    @users_id= options['users_id']
    @questions_id = options['questions_id']
    @parents_id = options['parents_id']
    @body_reply = options['body_reply']
  end

  def create
    raise "#{self} is already in database" if self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.users_id, self.questions_id, self.parents_id, self.body_reply)
      INSERT INTO
        replies (users_id, questions_id, parents_id, body_reply)
      VALUES
        (?,?,?,?)
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} is not in database" unless self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.users_id, self.questions_id, self.parents_id, self.body_reply, self.id)
      UPDATE
        replies
      SET
        users_id = ?, questions_id = ?, parents_id = ?, body_reply = ?
      WHERE
        id = ?
    SQL
  end

  def author
    QuestionsDatabase.instance.execute(<<-SQL, self.users_id)
    SELECT
      fname,lname
    FROM
      users
    WHERE
      id = ?
  SQL
  end
end