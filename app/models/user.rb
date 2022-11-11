class User < ApplicationRecord
    include QueryHelper
    
    def self.validate_register_params(register_params)
        validation_response = {:status => false, :error_message => nil}

        # check if all params is present
        check_params = register_params.select {|key, value| value.empty?}.keys
        
        if check_params.present?
            check_params.map! {|field| field.gsub('_', ' ').capitalize}
            validation_response[:error_message] = "All fields are required: " + check_params.join(', ')
            return validation_response
        end

        # validate if the email address is valid
        if (register_params[:email_address] =~ EMAIL_REGEX_PATTERN).nil?
            validation_response[:error_message] = "Email Address is invalid" 
            return validation_response
        end

        # validate if email address is already exist in the database
        if User.fetch_user_by_email(register_params[:email_address]).present?
            validation_response[:error_message] = "Email is already exist in the database." 
            return validation_response
        end

        # validate if password and confirm password is the same
        if register_params[:password] != register_params[:confirm_password]
            validation_response[:error_message] = "Password and Confirm Password does not match." 
            return validation_response
        end

        validation_response[:status] = true

        return validation_response
    end

    def self.validate_login_params(login_params)
        validation_response = {:status => false, :error_message => nil}

        # check if all params is present
        check_params = login_params.select {|key, value| value.empty?}.keys
        
        if check_params.present?
            check_params.map! {|field| field.gsub('_', ' ').capitalize}
            validation_response[:error_message] = "All fields are required: " + check_params.join(', ')
            return validation_response
        end

        validation_response[:status] = true

        return validation_response
    end

    # Create a new user upon register
    def self.create_user(register_params)
        user_result = {:status => false, :result => nil, :message => nil}

        # validate user register params
        validated_register_params = User.validate_register_params(register_params)

        # insert user record if the user params is successfully validated
        if validated_register_params[:status]
            encrypted_password = encrypted_password(register_params[:password])
            insert_user_query   = ["INSERT INTO users (first_name, last_name, email_address, password, created_at, updated_at) 
                                    VALUES (?, ?, ?, ?, NOW(), NOW())", register_params[:first_name], register_params[:last_name], register_params[:email_address], encrypted_password]
       
            new_user_id         = insert_record(insert_user_query)

            if new_user_id.present?
                user_result[:status]  = true
                user_result[:result]  = User.fetch_user_by_id(new_user_id)
            else
                user_result[:message] = "An error encounter while creating the new user. Please reload the page and try again."
            end
        else 
            user_result[:message] = validated_register_params[:error_message]
        end

        return user_result
    end

    # authenticate user upon login
    def self.authenticate_user(login_params)
        user_result = {:status => false, :result => nil, :message => nil}

        # validate user login params
        validated_login_params = User.validate_login_params(login_params)

        if validated_login_params[:status]
            # check if the email is exist on the database
            fetched_user_record = User.fetch_user_by_email(login_params[:email_address])

            if fetched_user_record.present?
                # check if the password from the user table is the same as the password params
                if fetched_user_record["password"] == encrypted_password(login_params[:password])
                    user_result[:status] = true
                    user_result[:result] = fetched_user_record
                else 
                    user_result[:message] = "Password didn't match"
                end
            else
                user_result[:message] = "User is not registered in the database"
            end
        else
            user_result[:message] = validated_login_params[:error_message]
        end

         return user_result
    end

    # Fetch user record by email address
    def self.fetch_user_by_email(email_address)
        fetch_user_query = ['SELECT * FROM users WHERE email_address = ? LIMIT 1', email_address]
        return query_record(fetch_user_query)
    end

    # Fetch user record by email address
    def self.fetch_user_by_id(id)
        fetch_user_query = ['SELECT * FROM users WHERE id = ? LIMIT 1', id]
        return query_record(fetch_user_query)
    end

    private 
        def self.encrypted_password(password_string)
            encrypted_password = Digest::MD5.hexdigest("2022" + password_string + "wall")
            return Digest::MD5.hexdigest(encrypted_password)
        end
end
