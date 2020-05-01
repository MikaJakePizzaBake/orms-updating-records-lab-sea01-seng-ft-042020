class Student
  attr_accessor :name, :grade, :id
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)
    SQL
    DB[:conn].execute(sql)
  end
  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end
  def save
    if
      self.id
      self.update
    else
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end
def self.new_from_db(row)
  student= self.new(id, name, grade)
  student.id = [0]
  student.name = [1]
  student.grade = [2]
  student
end
def self.create(name, grade)
  student = Student.new(name,grade)
  student.save
end
def update
  sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
  DB[:conn].execute(sql, self.name, self.grade, self.id)
end
end
