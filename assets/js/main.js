$(function(){
    setup_step_RT_Review_RT_Queue();
});

function setup_step_RT_Review_RT_Queue() {
    var el = $('.step-RT-Review-RT-Queue');
    if ( ! el.length ) { return; }

    el.find('.ticket-ok').each(function(){
        var el = $(this);
        el.click(function(){
            $.ajax({
                url: el.attr('href'),
                dataType: 'json',
            }).done(function(data) {
                if ( ! data.success == 'OK' ) {
                    alert("Request failed");
                    return;
                }
                el.toggleClass('btn-success');
                el.toggleClass('btn-default');
                el.parents('tr').toggleClass('success');
            });

            return false;
        });
    });

    el.find('.ticket-block').each(function(){
        var el = $(this);
        el.click(function(){
            $.ajax({
                url: el.attr('href'),
                dataType: 'json',
            }).done(function(data) {
                if ( ! data.success == 'OK' ) {
                    alert("Request failed");
                    return;
                }
                el.toggleClass('btn-danger');
                el.toggleClass('btn-default');
                el.parents('tr').toggleClass('danger');
            });

            return false;
        });
    });
}
