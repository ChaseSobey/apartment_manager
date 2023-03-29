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
  
  def add_new_apartment(name, address)
    sql = <<~SQL
      INSERT INTO apartment_buildings (name, address) VALUES ($1, $2);
    SQL
    
    @db.exec_params(sql, [name, address])
  end
  
  def add_new_tenant(tenant, rent, building_id)
    sql = <<~SQL
      INSERT INTO units (building_id, tenant, rent) VALUES ($1, $2, $3);
    SQL
    
    @db.exec_params(sql, [building_id, tenant, rent])
  end
end