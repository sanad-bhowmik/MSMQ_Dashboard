<?php
//for reading pending SMS you must frequently call this script. Use crontab job for example.
ob_start();
//print "<pre>";
require_once "smpp.php";//SMPP protocol
//connect to the smpp server
$tx = new SMPP('172.16.249.43', 5100);
//$tx->debug=true;

//bind the receiver
//$tx->system_type="immsl";
$tx->addr_npi = 1;
$tx->bindReceiver("MobiTips", "MobTip@1");
//print_r($tx);
//die;
do {
    //read incoming sms
    $sms = $tx->readSMS();
    //check sms data
    //print_r($sms);
    //die;
    if ($sms && !empty($sms['source_addr']) && !empty($sms['destination_addr']) && !empty($sms['short_message'])) {
        //send sms for processing in smsadv
        //print_r($sms);

        $from = $sms['source_addr'];
        $to = $sms['destination_addr'];
        $message = $sms['short_message'];
        $squence = $sms['squence'];
        //echo $from."<br/>";
        //run some processing function for incomming sms
        process_message($from, $to, $message, $squence);
    } else {
        echo "No Data";
    }
    //until we have sms in queue
} while ($sms);
//close the smpp connection
$tx->close();
unset($tx);
//clean any output
ob_end_clean();
//print "</pre>";

function process_message($from, $to, $message, $squence)
{
    //print "Received SMS\nFrom: $from\nTo:   $to\nMsg:  $message";
    include 'db_config.php';
    $date = date('Y-m-d h:i A');
    $msgup = strtoupper($message);
    $datenew = date('Y-m-d');
    if ($squence == "") {
        $squence = date('Ymdhhiiss') . "-3";
    } else {
        $squence = $squence . "-3";
    }
    $msgupmain = $msgup;

    if ($msgup == "STOP MWP") {
        $msgup = "START MWP";
    }
    if ($msgup == "STOP CNS") {
        $msgup = "START CNS";
    }
    if ($msgup == "STOP FNS") {
        $msgup = "START FNS";
    }
    if ($msgup == "STOP BNS") {
        $msgup = "START BNS";
    }
    if ($msgup == "STOP LSU") {
        $msgup = "START LSU";
    }

    $selectquery = "select * from tbl_bl_keyword where keyword='$msgup' limit 1";
    $ftp = fopen("C:/mts/htdocs/blsmpptips/LOG/mo_log_" . $datenew . ".txt", 'a+');
    fwrite($ftp, $from . " - " . $to . " - " . $message . " " . $msgup . "-" . $selectquery . "-" . $date . "\n");
    fclose($ftp);


    $resquery = mysqli_query($con, $selectquery);
    if (mysqli_num_rows($resquery) > 0) {
        while ($rowqu = mysqli_fetch_array($resquery, MYSQLI_ASSOC)) {
            $subscription_type = $rowqu['subscription_type'];
        }
        if ($subscription_type == "Subscription") {
            if ($msgupmain == "STOP MWP" || $msgupmain == "STOP CNS" || $msgupmain == "STOP FNS" || $msgupmain == "STOP BNS" || $msgupmain == "STOP LSU") {
                $registerMO_url = 'http://localhost/BLSDP/unsubscription.php';
            } else {
                if ($from == "880193007289866") {
                    $registerMO_url = 'http://localhost/BLSDP/subscription_charging.php';
                    //$registerMO_url='http://localhost/BLSDP/subscription_charging_ph1.php';
                } else {
                    $registerMO_url = 'http://localhost/BLSDP/subscription_charging_ph1.php';
                    //$registerMO_url='http://localhost/BLSDP/subscription_charging.php';
                }
                /*
                         $registerMO_param="?msisdn=$from&keyword=".urlencode($msgup);
             $ftp2 = fopen("C:/mts/htdocs/blsmpptips/LOG/url_log_".$datenew.".txt",'a+');
                     fwrite($ftp2,$registerMO_url."".$registerMO_param."-".$date."\n");
                     fwrite($ftp2,$registerMO_param." ".$date."\n");
                     fclose($ftp2);
             $response	=HttpRequest($registerMO_url,$registerMO_param);	
                         */
            }
        } else {

            /*
                           if($from=="880193007289822")
                           {
                           $registerMO_url='http://localhost/BLSDP/ondemand_charging_ph2.php';
                           //$registerMO_url='http://localhost/BLSDP/ondemand_charging_ph1.php';
                           }
                           else if($from=="880193007289866")
                           {
                           $registerMO_url='http://localhost/BLSDP/ondemand_charging.php';
                           //$registerMO_url='http://localhost/BLSDP/ondemand_charging_ph1.php';
                           }
                           else
                           {
                           $registerMO_url='http://localhost/BLSDP/ondemand_charging_ph1.php';
                           //$registerMO_url='http://localhost/BLSDP/ondemand_charging.php';
                           }
               */


            $registerMO_url = "http://103.228.39.36/msmq/add_queu.php";
            $keyword = urlencode($msgup);
            $registerMO_param = "?msisdn=$msisdn&text=$keyword&keyword=$keyword&moid=$squence&shortcode=16658&telcoid=3";
            $Queue_response = HttpRequest($queue_url, $queue_param);


            $registerMO_url = 'http://localhost/BLSDP/ondemand_charging_ph1.php';
            $registerMO_param = "?msisdn=$from&keyword=" . urlencode($msgup);
            $response = HttpRequest($registerMO_url, $registerMO_param);


            $ftp2 = fopen("C:/mts/htdocs/blsmpptips/LOG/url_log_" . $datenew . ".txt", 'a+');
            fwrite($ftp2, $registerMO_url . "" . $registerMO_param . "-" . $date . "\n");
            fwrite($ftp2, $registerMO_param . " " . $date . "\n");
            fclose($ftp2);

        }


    } else {

    }






}

function HttpPOST($url, $param)
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $param);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/soap+xml;charset=UTF-8'));
    $response_body = curl_exec($ch);
    $response_header = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return $response_body;
}
function HttpRequest($url, $param)
{
    $URL_STR = $url . $param;
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $URL_STR);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, false);
    curl_exec($ch);
    $response = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return $response;
}
?>