$(function(){
  
  $('.from-city').change(function(){
    var city_id = $('.from-city').val();
    
    // repopulates the to-city dropdown list so that the city selected can be removed after selecting hood
    $(this).children().each(function(){
      $('.to-city option:not(:first)').remove();
      var options = $(this).parent().children().slice(1).clone();
      $('.to-city').append(options);
    });
    
    // fire ajax to go to /cities/city_id/hoods
    $.ajax('/cities/' + city_id + '/hoods', {
      type: 'get',
      dataType: 'json'
    }).success(function(result){
      // preform the on success result
      // removes all option elements but first and removes the disabled attribute
      $('.from-hood option:not(:first)').remove();
      $('.from-hood').removeAttr('disabled');
      
      // removes the from-city that was selected
      $('.to-city').find('option[value="' + city_id + '"]').remove();

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
