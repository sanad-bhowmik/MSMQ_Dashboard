<?php

include_once("include/initialize.php");

include_once("include/header.php");
?> 
<style>

#uploadForm {border-top:#F0F0F0 2px solid;background:#FAF8F8;padding:10px;}
#uploadForm label {margin:2px; font-size:1em; font-weight:bold;}
.demoInputBox{padding:5px; border:#F0F0F0 1px solid; border-radius:4px; background-color:#FFF;}
#progress-bar {background-color: #12CC1A;height:20px;color: #FFFFFF;width:0%;-webkit-transition: width .3s;-moz-transition: width .3s;transition: width .3s;}
.btnSubmit{background-color:#09f;border:0;padding:10px 40px;color:#FFF;border:#F0F0F0 1px solid; border-radius:4px;}
#progress-div {border:#0FA015 1px solid;padding: 5px 0px;margin:30px 0px;border-radius:4px;text-align:center;}
#targetLayer{width:100%;text-align:center;}

</style>
<script>
$(document).ready(function() { 
  $('#uploadForm').submit(function(e) { 


        if($('#menu_name').val()) {

            e.preventDefault();


            $('#loader-icon').show();


            $(this).ajaxSubmit({ 
                target:   '#targetLayer', 
                beforeSubmit: function() {
                    $("#progress-bar").width('0%');
                },
                uploadProgress: function (event, position, total, percentComplete){ 

                    console.log(percentComplete);
                    $("#progress-bar").width(percentComplete + '%');
                    $("#progress-bar").html('<div id="progress-status">' + percentComplete +' %</div>')
                },
                success:function (){
                    $('#loader-icon').hide();
                    
                },
                resetForm: true 
            }); 
            return false; 
       
        } //end if
        else{

          e.preventDefault();
        }


    }); // end upload form
});// end document
</script>


<!-- Main content -->
<div class="app-main__inner">


    <div class="row">
      <div class="col-md-12">
        <div class="main-card mb-3 card">
          <div class="card-header">Add Users</div>
          <div class="card-body">
            

            <form id="uploadForm"  action="up/up_menu.php" method="post" >




              <div class="position-relative row  form-group  p-t-10">
                <div class="col-sm-4">
                <p class="text">Menu Name</p> <input type="text" id="menu_name" required="true" name="menu_name" class="form-control" id="user_name" placeholder="Menu NAME">
              </div>

               <div class="col-sm-4">
                <p class="text">Icon Class</p> <input type="text" required="true" name="icon_class" class="form-control"  placeholder="PE-ICON-CLASS">
              </div>
               <div class="col-sm-4">
                <p class="text">Notification</p> YES  <input type="radio" checked value="1" name="notification" > OR
               <input type="radio" checked value="0" name="notification" > NO
              </div>


             </div>
                  
             
             <hr>




<hr>
<div class="position-relative row form-group p-t-10 ">
<div class="col-sm-4 ">


                   <button type="submit"    name="submit" class="btn btn-secondary">Submit</button>


</div>
</div>
             

<div id="progress-div"><div id="progress-bar"></div></div>
<div id="targetLayer"></div>


             </form>
          </div> 
             <div id="loader-icon" style="display:none;"><img src="LoaderIcon.gif" /></div>

          </div>
        </div>
      </div><!--end row -->


  <div class="row">
    <div class="col-md-12">
      <div class="main-card mb-3 card">
        <div class="card-header">Menu List
         
        </div>

            <?php
          $sql_get_data ="select * from tbl_menu u  ";
      
      $result = mysqli_query($GLOBALS['con'],$sql_get_data);
      ?>



        <div class="table-responsive">
          <table class="align-middle mb-0 table table-borderless table-striped table-hover">
            <thead>
              <tr>
                <th class="text-center">SL</th>
                <th class="text-center">Menu Name</th>
                <th class="text-center">Icon Class</th>
                <th class="text-center">Status</th>
                
                <th class="text-center">Notifocation</th>
                <th class="text-center">Added</th>
               
                <th class="text-center">Option</th>
              </tr>
            </thead>
            <tbody>
              <?php $i=0; while ($rs = mysqli_fetch_array($result)) { $i++;?>
                <tr>


                 <td class="text-muted text-center" >
                  <?php echo $i; ?>
                </td>
                <td class="text-center">
                  <?php echo $rs['menu_name']; ?>
                </td>
                  <td class="text-center">
                  <?php echo $rs['icon_class']; ?>
                </td>
              
                 <td class="text-center">
                  <?= $rs['status']=="1" ? 'Active' : 'In-Active' ?>
                </td>
                <td class="text-center">
                  <?= $rs['notification']=="1" ? 'Active' : 'In-Active' ?>
                </td>
                
                
                <td class="text-center">
                  <?php  echo $rs['edate']; ?>
                </td>
                <td class="text-center">
                  <?php  echo "r" ?>
                </td>

              </tr>
            <?php } ?> 
          </tbody>
            </table>
          </div>
     
        </div>
      </div>

     </div> 







</div> <!-- app inner main -->












<?php
include_once("include/footer.php");
?>