import 'select2'
import 'select2/dist/css/select2.css'
$(document).ready(function(){
    var recruitment = document.getElementsByClassName('recruitment-article');
    var join = document.getElementsByClassName('join-article');
    var common = document.getElementsByClassName('common-article');
    var value = $('#micropost_content_type').val();
      for(var i = 0; i < join.length; i++) {
        join[i].style.display = "table-row";
      }
      for(var i = 0; i < recruitment.length; i++) {
        recruitment[i].style.display = "table-row";
      }
      for(var i = 0; i < common.length; i++) {
        common[i].style.display = "table-row";
      }
      $(".part0").select2({
        width: 600
      });
      $(".genre0").select2({
        width: 600
      });
      $(".part1").select2({
        width: 600
      });
      $(".genre1").select2({
        width: 600
      });
});
