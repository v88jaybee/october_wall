class Message < ApplicationRecord
    include QueryHelper
    belongs_to :user

    def self.fetch_all_messages_comments
        fetch_message_query = ["SELECT messages.id as message_id, messages.user_id, messages.message, CONCAT(users.first_name, ' ', users.last_name) as author_message, messages.created_at, 
                                    CASE WHEN comments.id IS NULL THEN '[]'
                                    ELSE
                                        JSON_ARRAYAGG(
                                            JSON_OBJECT(
                                                'comment_id', comments.id,
                                                'comment_user_id', comments.user_id,
                                                'message_id', comments.message_id,
                                                'comment', comments.comment,
                                                'created_at', comments.created_at,
                                                'author_comment', CONCAT(comment_user.first_name, ' ', comment_user.last_name)
                                            )
                                        )
                                    END as user_comments
                                FROM messages
                                INNER JOIN users ON users.id = messages.user_id
                                LEFT JOIN comments ON comments.message_id = messages.id
                                LEFT JOIN users as comment_user ON comment_user.id = comments.user_id
                                GROUP BY messages.id
                                ORDER BY created_at DESC"]

        return query_records(fetch_message_query)
    end

    def self.create_message(message_params, user_id)
        message_result = {:status => false, :result => nil, :message => nil}

        if message_params[:message_text].present?
            insert_message_query = ["INSERT INTO messages (user_id, message, created_at, updated_at) 
                                    VALUES (?, ?, NOW(), NOW())", user_id, message_params[:message_text]]

            new_message          = insert_record(insert_message_query)

            if new_message.present?
                message_result[:status]  = true
            else
                message_result[:message] = "Error while creating a new message. Please try again."
            end
        else
            message_result[:message] = "Message is required"
        end

        return message_result
    end

    def self.delete_message(message_params)
        message_result = {:status => false, :result => nil, :message => nil}

        if message_params[:message_id].present?
            fetch_message_query = ["SELECT * FROM messages WHERE id = ? LIMIT 1", message_params[:message_id]]
            fetch_message_record = query_record(fetch_message_query)

            if fetch_message_record.present?
                delete_query    = ["DELETE FROM messages WHERE id =?", message_params[:message_id]]
                deleted_record  = delete_record(delete_query)

                message_result[:status]     = true
            else
                message_result[:message]    = "Unable to delete the message. Please try again"
            end
        else
            message_result[:message] = "Message ID is required to delete a message"
        end

        return message_result
    end
end
