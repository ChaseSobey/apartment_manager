require 'pg'

class DatabasePersistence
  def initialize(logger)
    @db = PG.connect(dbname: 'project')
    @logger = logger
  end
  
  def all_apartments(page)
    sql = <<~SQL
      SELECT * FROM apartment_buildings ORDER BY name LIMIT 2 OFFSET $1;
    SQL
    
    result = @db.exec_params(sql, [page])
    result.map do |tuple|
      { id: tuple['id'], name: tuple['name'], address: tuple['address'] }
    end
  end
  
  def all_apartment_names
    sql = 'SELECT * FROM apartment_buildings'
    
    result = @db.exec(sql)
    result.field_values(:name)
  end
  
  def find_apartment(id)
    sql = <<~SQL
      SELECT * FROM apartment_buildings WHERE id = $1;
    SQL
    
    result = @db.exec_params(sql, [id])
    result.map do |tuple|
      { id: tuple['id'], name: tuple['name'], address: tuple['address'] }
    end
  end
  
  def count_apartments
    sql = 'SELECT * FROM apartment_buildings'
    
    result = @db.exec(sql)
    result.ntuples
  end
  
  def all_tenant_names
    sql = 'SELECT * FROM units'
    
    result = @db.exec(sql)
    result.field_values(:tenant)
  end
  
  def find_tenant(id)
    sql = <<~SQL
      SELECT * FROM units WHERE id = $1;
    SQL
    
    result = @db.exec_params(sql, [id])
    result.map do |tuple|
      { id: tuple['id'], building_id: tuple['building_id'], rent: tuple['rent'], tenant: tuple['tenant'] }
    end
  end
  
  def count_units_in_apartment(apt_id)
    sql = 'SELECT * FROM units WHERE building_id = $1'
    
    result = @db.exec_params(sql, [apt_id])
    result.ntuples
  end
  
  def units_in_apartment(apt_id, page)
    sql = <<~SQL
      SELECT * FROM units WHERE building_id = $1 ORDER BY tenant LIMIT 2 OFFSET $2;
    SQL
    
    result = @db.exec_params(sql, [apt_id, page])
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
  
  def delete_apartment(id)
    sql = 'DELETE FROM apartment_buildings WHERE id = $1'
    
    @db.exec_params(sql, [id])
  end
  
  def delete_tenant(id)
    sql = 'DELETE FROM units WHERE id = $1'
    
    @db.exec_params(sql, [id])
  end
  
  def update_apartment_info(id, name, address)
    sql = 'UPDATE apartment_buildings SET name = $1, address = $2 WHERE id = $3'
    
    @db.exec_params(sql, [name, address, id])
  end
  
  def update_unit_info(id, tenant, rent)
    sql = 'UPDATE units SET tenant = $1, rent = $2 WHERE id = $3'
    
    @db.exec_params(sql, [tenant, rent, id])
  end
end