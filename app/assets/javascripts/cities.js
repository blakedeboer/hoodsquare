$(function(){
  
  $('.from-city').change(function(){
    var city_id = $('.from-city').val();

    $.ajax('/cities/' + city_id + '/hoods', {
      type: 'get',
      dataType: 'json'
    }).success(function(result){
      $('.from-hood option:not(:first)').remove();
      $('.from-hood').removeAttr('disabled');
      
      // $('.to-city option:not(:first)').remove();
      // $('.to-city option[value="' + city_id + '"]').remove();

      result.forEach(function(hood){

        $('.from-hood').append($('<option></option>').val(hood.id).html(hood.name));
        // console.log(hood.name, hood.id);
      });
    });
  });

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
