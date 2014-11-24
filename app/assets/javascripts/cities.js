$(function(){
  
  $('.from-city').change(function(){
    var city_id = $('.from-city').val();

  //   $.ajax('/cities/' + city_id + '/hoods', {
  //     type: 'get',
  //     // context: this,
  //     dataType: 'json'
  //   }).success(function(result){
  //     result.forEach(function(hood){
  //       $('.from-hood').append($('<option></option>').val(hood.id).html(hood.name));
  //       // console.log(hood.name, hood.id);
  //     });
  //   });
  // });

    $.ajax('/cities/' + city_id + '/hoods', {
      type: 'get',
      // context: this,
      dataType: 'json'
    }).success(function(result){
      $('.from-hood option:not(:first)').remove();
      result.forEach(function(hood){
        

        $('.from-hood').append($('<option></option>').val(hood.id).html(hood.name));
        // console.log(hood.name, hood.id);
      });
    });
  });

  // $.ajax('/cities/' + city_id + '/hoods', {
  //     type: 'get',
  //     // context: this,
  //     dataType: 'script'
  //   })
  // });

});
