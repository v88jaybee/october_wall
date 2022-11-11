$(document).ready(function(){
    $("body")
        .on("submit", "#message_form", function(e){
            e.preventDefault();
            let message_form = $(this);

            $.post(message_form.attr("action"), message_form.serialize(), function(message_result){
                if(message_result.status){
                    location.reload();
                }
                else{
                    alert(message_result.message);
                }
            })
        })
        .on("click", ".post_comment_btn", function(){
            let comment_form = $("#comment_form");
            let post_button = $(this);

            comment_form.find("#comment_message_id").val(post_button.data("message-id"));
            comment_form.find("#comment_message_textarea").val(post_button.siblings("textarea").val());

            comment_form.submit();
        })
        .on("submit", "#comment_form", function(e){
            e.preventDefault();
            let comment_form = $(this);

            $.post(comment_form.attr("action"), comment_form.serialize(), function(comment_result){
                if(comment_result.status){
                    location.reload();
                }
                else{
                    alert(comment_result.message);
                }
            })
        })
        .on("click", ".delete_message_btn", function(){
            let delete_message_form = $("#delete_message_form");
            let delete_message_btn = $(this);

            delete_message_form.find("#delete_message_id").val(delete_message_btn.data("message-id"));

            delete_message_form.submit();
        })
        .on("submit", "#delete_message_form", function(e){
            e.preventDefault();
            let delete_message_form = $(this);

            $.post(delete_message_form.attr("action"), delete_message_form.serialize(), function(delete_result){
                if(delete_result.status){
                    location.reload();
                }
                else{
                    alert(delete_result.message);
                }
            })
        })
        .on("click", ".delete_comment_btn", function(){
            let delete_comment_form = $("#delete_comment_form");
            let delete_comment_btn = $(this);

            delete_comment_form.find("#delete_comment_id").val(delete_comment_btn.data("comment-id"));
            delete_comment_form.submit();
        })
        .on("submit", "#delete_comment_form", function(e){
            e.preventDefault();
            let delete_comment_form = $(this);

            $.post(delete_comment_form.attr("action"), delete_comment_form.serialize(), function(delete_result){
                if(delete_result.status){
                    location.reload();
                }
                else{
                    alert(delete_result.message);
                }
            })
        })
});