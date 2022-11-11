module QueryHelper
    extend ActiveSupport::Concern
    module ClassMethods

        # DOCU: Query single record
		def query_record(sql_statement)
            ActiveRecord::Base.connection.select_one(
                ActiveRecord::Base.send(:sanitize_sql_array, sql_statement)
            )
		end

        # DOCU: Query multiple records
		def query_records(sql_statement)
            ActiveRecord::Base.connection.exec_query(
                ActiveRecord::Base.send(:sanitize_sql_array, sql_statement)
            ).to_hash
        end
        
        # DOCU: Insert records to the database
        def insert_record(sql_statement)
            ActiveRecord::Base.connection.insert(
                ActiveRecord::Base.send(:sanitize_sql_array, sql_statement)
            )
        end

        # DOCU: Update records in the database
        def update_record(sql_statement)
            ActiveRecord::Base.connection.update(
                ActiveRecord::Base.send(:sanitize_sql_array, sql_statement)
            )
        end

        # DOCU: Delete records in the database
        def delete_record(sql_statement)
            ActiveRecord::Base.connection.delete(
                ActiveRecord::Base.send(:sanitize_sql_array, sql_statement)
            )
        end
    end
end