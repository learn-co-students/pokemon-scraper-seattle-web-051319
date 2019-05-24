class Pokemon

    attr_accessor :name, :type, :id, :db, :hp

    def initialize(id:, name:, type:, db:)
        @name = name
        @type = type
        @id = id
        @db = db
    end

    def self.save(name, type, db)
        sql = <<-SQL
          INSERT INTO pokemon (name, type)
          VALUES (?, ?)
        SQL
     
        db.execute(sql, name, type)
        @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
    end

    def self.new_from_db(row)
        id = row[0]
        name = row[1]
        type = row[2]
        self.new(id, name, type, db)
      end

    def self.find(id, db)
        sql = <<~SQL
            SELECT *
            FROM pokemon
            WHERE id = ?
        SQL

        saved_pokemon = db.execute(sql, id).flatten
        new_pokemon = self.new(id: saved_pokemon[0], name: saved_pokemon[1], type: saved_pokemon[2], db: db)
        # new_pokemon.hp = saved_pokemon[3]
        new_pokemon
    end



end
