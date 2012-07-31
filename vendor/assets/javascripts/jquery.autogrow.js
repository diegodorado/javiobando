(function($) {

  /*
   * Auto-growing textareas; technique ripped from Facebook
   */
  $.fn.autogrow = function(options) {
      
    this.filter('textarea').each(function() {

      if ($(this).data('autogrowed')) return ;
      var pre = $('<pre></pre>').css({
          display:   'none',
          margin: 0,
          padding: 0,
          'white-space': 'pre-wrap',
          'word-wrap': 'break-word',
          'word-break': 'inherit',
          width:      $(this).width(),
          fontSize:   $(this).css('fontSize'),
          fontFamily: $(this).css('fontFamily'),
          lineHeight: $(this).css('lineHeight')
      }).appendTo(document.body);
      
      var update = function() {
          pre.html(this.value+' ');
          $(this).css('height', pre.height());
      }
      
	    $(this).bind('update blur keyup change cut paste', update);

	    // And this line is to catch the browser paste event
	    $(this).bind('input paste',function(e){ var that = this;setTimeout( function(){update.apply(that);}, 250); });				
      $(this).data('autogrowed',true);
	    $(this).trigger('update');
        
    });
    
    return this;
      
  }
  
})(jQuery);
