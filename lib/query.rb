class Query
  def initialize string
    @query = string
  end

  def run db
    case @query
    when NAME_QUERY
      pattern = [?%, $1, ?%].join
      db.where Sequel.like(:name, pattern)
    when TIME_QUERY
      date = DateTime.parse $1
      from = date
      to   = date.next_day

      code = 
        %w[ atime ctime mtime ].map { |attr|
          "( (#{attr} >= from) & (#{attr} < to) )"
        }.join(?|)
      #p code
      #exit 0

      db.where {
        instance_eval code
      }
        #( (atime >= from) & (atime < to) ) |
        #(ctime =~ value) |
        #(mtime =~ value) |
        #(utime =~ value)
      #}
    else
      raise 'unknown query: %s' % @query.inspect
    end
  end
  NAME_QUERY = /\Aname (.+)\z/
  #DATE_QUERY = /\Adate (.+)\z/
  TIME_QUERY = /\Atime (.+)\z/
  #LIKE_QUERY = /\A([^\s]+) like (.+)\z/
  #EQ_QUERY = /\A([^\s]+) = (.+)\z/
end
