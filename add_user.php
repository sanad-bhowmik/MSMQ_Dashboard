<?php
include_once("include/initialize.php");
include_once("include/header.php");
?>
<style>
  #uploadForm {
    border-top: #F0F0F0 2px solid;
    background: #FAF8F8;
    padding: 10px;
  }

  #uploadForm label {
    margin: 2px;
    font-size: 1em;
    font-weight: bold;
  }

  .demoInputBox {
    padding: 5px;
    border: #F0F0F0 1px solid;
    border-radius: 4px;
    background-color: #FFF;
  }

  #progress-bar {
    background-color: #12CC1A;
    height: 20px;
    color: #FFFFFF;
    width: 0%;
    -webkit-transition: width .3s;
    -moz-transition: width .3s;
    transition: width .3s;
  }

  .btnSubmit {
    background-color: #09f;
    border: 0;
    padding: 10px 40px;
    color: #FFF;
    border: #F0F0F0 1px solid;
    border-radius: 4px;
  }

  #progress-div {
    border: #0FA015 1px solid;
    padding: 5px 0px;
    margin: 30px 0px;
    border-radius: 4px;
    text-align: center;
  }

  #targetLayer {
    width: 100%;
    text-align: center;
  }
</style>

<!-- Main content -->
<div class="app-main__inner">
  <div class="row">
    <div class="col-md-12">
      <div class="main-card mb-3 card">
        <div class="card-header">Add Users</div>
        <div class="card-body">
          <form id="uploadForm" action="up_user.php" method="post">
            <div class="position-relative row form-group p-t-10">
              <div class="col-sm-4">
                <p class="text">User Name</p> <input type="text" required="true" name="user_name" class="form-control" id="user_name" placeholder="User Name">
              </div>
              <div class="col-sm-4">
                <p class="text">First Name</p> <input type="text" required="true" name="first_name" class="form-control" placeholder="First Name">
              </div>
              <div class="col-sm-4">
                <p class="text">Last Name</p> <input type="text" required="true" name="last_name" class="form-control" placeholder="Last Name">
              </div>
            </div>

            <div class="position-relative row form-group p-t-10">
              <div class="col-sm-4">
                <p class="text">Mobile</p> <input type="text" name="mobile" class="form-control" placeholder="Mobile">
              </div>
              <div class="col-sm-4">
                <p class="text">Email</p> <input type="text" name="email" class="form-control" placeholder="Email">
              </div>
              <div class="col-sm-4">
                <p class="text">Password</p>
                <input type="password" required="true" name="password" class="form-control" id="password" placeholder="Password">
              </div>

            </div>

            <hr>

            <div class="position-relative row form-group">
              <div class="col-sm-4">
                <p>User Role :</p>
                <select required="true" name="user_role" class="form-control">
                  <?php
                  $output = '<option>--Select User Role---</option>';
                  foreach ($roles = get_all_user_role() as $value) {
                    $output .= '<option value="' . $value["id"] . '">' . $value["role_name"] . '</option>';
                  }
                  echo $output;
                  ?>
                </select>
              </div>
            </div>

            <hr>
            <div class="position-relative row form-group p-t-10 ">
              <div class="col-sm-4 ">
                <button type="submit" name="submit" class="btn btn-secondary">Submit</button>
              </div>
            </div>

            <div id="progress-div">
              <div id="progress-bar"></div>
            </div>
            <div id="targetLayer"></div>
          </form>
        </div>
        <div id="loader-icon" style="display:none;"><img src="LoaderIcon.gif" /></div>

        <?php if (isset($_GET['success']) && $_GET['success'] == 1): ?>
          <script>
            alert("User added successfully!");
          </script>
        <?php endif; ?>
      </div>
    </div>
  </div>
  <!--end row -->
</div>

<?php
include_once("include/footer.php");
?>