require 'sequel'

module DBStuff
  module_function

  def init_db file
    connect file do |db|
      init_scheme db
    end
  end

  def connect file, &block
    Sequel.sqlite file, &block
  end

  def init_scheme db
    db.create_table :files do
      primary_key :id

      String   :name
      String   :dir   # ...

      DateTime :atime
      DateTime :ctime
      DateTime :mtime
    end
  end

  def open file
    connect(file) { |db|
      db.transaction {
        yield DB.new(db)
      }
    }
  end

  class DB
    def initialize db
      @db = db
    end
    def push_file file
      other_attrs = %i[
        atime
        ctime
        mtime
      ]
      hash = other_attrs.map { |name|
        { name => file.send(name) }
      }.reduce(:merge)

      @db[:files] << {
        name: file.basename.to_path,
        dir:  file.parent.expand_path.to_path ,
        **hash
      }
    end
    def find_files query, &block
      query.run(@db[:files]).each &block
    end
  end
end

