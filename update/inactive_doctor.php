<?php
require_once("../include/dbcon.php");
require_once("../include/dasfunctions.php");


if(isset($_POST['pid'])){



  $pid = trim($_POST['pid']);

 

  $sql  = "update tbl_doctor set Active=0 where DOCID ='$pid' limit 1 ";

  $result = mysqli_query($GLOBALS['con'],$sql);

  if($result){
   echo  "In-Activated successfully !!";

 }
 else{

  echo  "Somthing went wrong !!";

}





}






?>