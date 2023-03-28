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
  
  def units_in_apartment(apt_id)
    sql = <<~SQL
      SELECT * FROM units WHERE building_id = $1;
    SQL
    
    result = @db.exec_params(sql, [apt_id])
    result.map do |tuple|
      { id: tuple['id'], building_id: tuple['building_id'], rent: tuple['rent'], tenant: tuple['tenant'] }
    end
  end
end