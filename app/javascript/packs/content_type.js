import 'select2'
import 'select2/dist/css/select2.css'
$(document).ready(function(){
  $('#micropost_content_type').change(function(){
    var recruitment = document.getElementsByClassName('recruitment-article');
    var join = document.getElementsByClassName('join-article');
    var common = document.getElementsByClassName('common-article');
    var value = $('#micropost_content_type').val();
    if(value == '') {
      for(var i = 0; i < join.length; i++) {
        join[i].style.display = "none";
      }
      for(var i = 0; i < recruitment.length; i++) {
        recruitment[i].style.display = "none";
      }
      for(var i = 0; i < common.length; i++) {
        common[i].style.display = "none";
      }
    } else if(value == '募集'){
      for(var i = 0; i < join.length; i++) {
        join[i].style.display = "none";
      }
      for(var i = 0; i < common.length; i++) {
        common[i].style.display = "table-row";
      }
      for(var i = 0; i < recruitment.length; i++) {
        recruitment[i].style.display = "table-row";
        // recruitment[i].empty();
      }
      $('.recruitment-article').prop('disabled', false);
      $('.join-article').prop('disabled', true);
      $(".part0").select2({
        width: 600
      });
      $(".genre0").select2({
        width: 600
      });
    } else if(value == '加入') {
      for(var i = 0; i < recruitment.length; i++) {
        recruitment[i].style.display = "none";
      }
      for(var i = 0; i < common.length; i++) {
        common[i].style.display = "table-row";
      }
      for(var i = 0; i < join.length; i++) {
        join[i].style.display = "table-row";
        // join[i].empty();
      }
      $(".recruitment-article").prop('disabled', true);
      $('.join-article').prop('disabled', false);
      $(".part1").select2({
        width: 600
      });
      $(".genre1").select2({
        width: 600
      });
    }
  });
});
