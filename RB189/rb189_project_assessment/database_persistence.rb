require 'pg'

class DatabasePersistence
  def initialize(logger)
    @db = PG.connect(dbname: 'project')
    @logger = logger
  end
  
  def all_apartments
    sql = <<~SQL
      SELECT * FROM apartment_buildings ORDER BY name;
    SQL
    
    result = @db.exec_params(sql)
    result.map do |tuple|
      { id: tuple['id'], name: tuple['name'], address: tuple['address'] }
    end
  end
end