require 'pathname'  # main thing of the file
require_relative 'db_stuff'  # delegates to


module FilesSurface

  DB_FILE = Pathname 'files.db'

  def scan_files at:, &block
    pattern = Pathname(at) + '**/**'

    db_open do |db|

      Pathname.glob(pattern) { |thing|
        case
        when thing.file?
          db.push_file thing
        end
      }
    end
  end

  def forget_files
    DB_FILE.unlink if DB_FILE.exist?
    DBStuff.init_db DB_FILE.to_path
  end

  def query_files query, &block
    db_open do |db|
      db.find_files query do |file|
        #p file
        puts file[:name]
        puts file[:dir] #[0..50]
        puts '-----'
      end
    end
  end

  def db_open &block
    DBStuff.open DB_FILE.to_path do |db|
      block.call db
    end
  end
end
