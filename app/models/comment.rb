class Comment < ApplicationRecord
    include QueryHelper

    belongs_to :user
    belongs_to :message
  
    def self.create_comment(comment_params, user_id)
        comment_result = {:status => false, :result => nil, :message => nil}

        if comment_params[:comment_text].present? && comment_params[:message_id].present?
            insert_comment_query = ["INSERT INTO comments (user_id, message_id, comment, created_at, updated_at) 
                                    VALUES (?, ?, ?, NOW(), NOW());", user_id, comment_params[:message_id], comment_params[:comment_text]]

            new_comment          = insert_record(insert_comment_query)

            if new_comment.present?
                comment_result[:status]  = true
            else
                comment_result[:message] = "Error while creating a new comment. Please try again."
            end
        else
            comment_result[:message] = "Comment is required"
        end

        return comment_result
    end

    def self.delete_comment(comment_params)
        comment_result = {:status => false, :result => nil, :message => nil}

        if comment_params[:comment_id].present?
            fetch_comment_query = ["SELECT * FROM comments WHERE id = ? LIMIT 1", comment_params[:comment_id]]
            fetch_comment_record = query_record(fetch_comment_query)

            if fetch_comment_record.present?
                delete_query    = ["DELETE FROM comments WHERE id =?", comment_params[:comment_id]]
                deleted_record  = delete_record(delete_query)

                comment_result[:status] = true
            else
                comment_result[:message] = "Unable to delete the comment. Please try again"
            end
        else
            comment_result[:message] = "Comment ID is required to delete a comment"
        end

        return comment_result
    end
end
