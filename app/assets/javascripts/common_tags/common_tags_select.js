(function($) {
  $.fn.common_tags_select = function(options) {
    var defaults = {
      autosubmit: false,
      suggestions: null
    };

    var options = $.extend( defaults, options);

    this.each(function(){
      var $this = $(this),
          thisData = $this.data(),
          thisOptions = $.extend(true, {}, options, thisData);

      $this.select2({
        ajax: {
          url: thisOptions.suggestions,
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
        templateResult: formatResult,
        templateSelection: formatSelection,
        theme: 'bootstrap',
        tags: true
      });

      if (thisOptions.autosubmit) {
        $this.change(function() {
          $this.closest('form').submit();
        });
      }
    });

    return this;
  }

  function formatSelection(tag) {
    $element = $(tag.element);
    return format($element.data('specialization'), tag.text, $element.data('count'));
  };

  function formatResult(tag) {
    return format(tag.specialization, tag.text, tag.count);
  };

  function format(specialization, text, count) {
    var specialization_text = specialization ? '<span class="glyphicon glyphicon-tags"></span> ' : ''
    var count_text = count ? ' (' + count + ')' : ''
    return $('<span>' + specialization_text + text + count_text + '</span>');
  }

})(jQuery);