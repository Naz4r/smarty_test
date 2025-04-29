$(document).ready(function() {

    $('input[name="city_ids[]"]').change(function() {

        if ($('input[name="city_ids[]"]:checked').length > 0) {
            $('.bulk-edit').show();
        } else {
            $('.bulk-edit').hide();
        }
    });
});