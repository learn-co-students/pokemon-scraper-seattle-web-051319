class Pokemon

  attr_accessor :id, :name, :type, :hp, :db

  def initialize(id:, name:, type:, db:)
    @id = id
    @name = name
    @type = type
    @db = db
  end

  def self.save(name, type, db)
    sql = <<~SQL
    INSERT INTO pokemon (name, type)
    VALUES (?, ?)
    SQL

    db.execute(sql, name, type)
    @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
  end

  def self.find(id, db)
    sql = <<~SQL
      SELECT *
      FROM pokemon
      WHERE id = ?
    SQL

    saved_pokemon = db.execute(sql, id).flatten
    new_pokemon = self.new(id: saved_pokemon[0], name: saved_pokemon[1], type: saved_pokemon[2], db: db)
    new_pokemon.hp = saved_pokemon[3]
    new_pokemon
  end

  def alter_hp(hp, db)
    sql = <<~SQL
      UPDATE pokemon
      SET hp = ?
      WHERE id = ?
    SQL

    db.execute(sql, hp, self.id)
  end

end
