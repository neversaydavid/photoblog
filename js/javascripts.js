
$(function(){
  var figures = $('figure');
  figures.picture({container: '.image-box', useLarger: true})
});

jQuery(window).load(function(){
    var $container = jQuery('#archive');
    
    $container.isotope({
      itemSelector: '.image-box'
    });

    $('#filters a').click(function(){
      var selector = $(this).data('filter');
      $container.isotope({ filter: selector });
      return false;
    });

  })