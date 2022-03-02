require_relative "questions_db"
require_relative "questions.rb"
require_relative "replies"

class Users
  attr_accessor :id, :fname, :lname

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map{ |datum| Users.new(datum)   }
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_id(id)
    users = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    Users.new(users.first)
  end

  def self.find_by_name(fname, lname)
    users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    Users.new(users.first)
  end
  
  def update
    raise "#{self} already in database" unless self.id
     users = QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname, self.id)
        UPDATE
          users
        SET
          fname = ?,
          lname = ?
        WHERE
          id = ?;
     SQL
  end

  def create
    raise "#{self} already in database" if self.id
    users = QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL
    self.id =  QuestionsDatabase.instance.last_insert_row_id
  end

  def authored_questions
    Questions.find_by_author_id(self.id)
  end
      
  def authored_replies
    Replies.find_by_users_id(self.id)
  end
end