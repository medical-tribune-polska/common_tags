$.fn.common_tags_select = function(options) {
  var options = (typeof options !== 'undefined') ? options : { autosubmit: false };
  this.each(function(){
    var url = $(this).data('suggestions-url');

    $(this)
      .select2({
        ajax: {
          url: url,
          dataType: 'json',
          delay: 250,
          data: function (params) {
            return {
              q: params.term
            };
          },
          processResults: function (data, params) {
            return {
              results: data
            };
          },
          cache: true
        },
        minimumInputLength: 1,
        theme: 'bootstrap',
        tags: true
      });

    if (options['autosubmit']) {
      $(this).change(function() {
        $(this).closest('form').submit();
      });
    }
  });

  return this;
}