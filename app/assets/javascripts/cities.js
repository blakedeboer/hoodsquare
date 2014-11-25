$(function(){
  
  $('.from-city').change(function(){
    var city_id = $('.from-city').val();

    // fire ajax to go to /cities/city_id/hoods
    $.ajax('/cities/' + city_id + '/hoods', {
      type: 'get',
      dataType: 'json'
    }).success(function(result){
      // preform the on success result
      // removes all option elements but first and removes the disabled attribute
      $('.from-hood option:not(:first)').remove();
      $('.from-hood').removeAttr('disabled');
      
      // populates the to-city dropdown list by removing the from-city that was selected
      $('.to-city option:not(:first)').each(function(){
        $(this).remove();
        $('.to-city').append($('<option></option>').val($(this).val()).html($(this).text()));
      });

      $('.to-city option[value="' + city_id + '"]').remove();

      //populates the hoods in the dropdown that match the from-city
      result.forEach(function(hood){
        $('.from-hood').append($('<option></option>').val(hood.id).html(hood.name));
      });
    });
  });

  // enables to-city when hood is selected
  $('.from-hood').change(function(){
    $('.to-city').removeAttr('disabled');
  });

  // $.ajax('/cities/' + city_id + '/hoods', {
  //     type: 'get',
  //     // context: this,
  //     dataType: 'script'
  //   })
  // });

});
