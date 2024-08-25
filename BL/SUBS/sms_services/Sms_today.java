package sms_services;

/**
 *
 * @author shibly
 */
import com.mysql.jdbc.Connection;
import com.mysql.jdbc.Statement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.net.*;
import java.io.*;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Admin
 */
public class Sms_today {

   
    Connection con;
    ConnectionBean c;
    public Sms_today() {
        c=new ConnectionBean();
        flagChange();
    }

 

    private void flagChange() {
        // System.out.println(now("h:mm a"));
        String currentDate = now("yyyy-MM-dd");
        System.out.println(currentDate);
        String keyword;
        String mob_num;
        String sms;
        int recID;
        int id=0;



    String sql_Get_SMS = "SELECT * FROM `sub_i_sms_store` where status=1 and date='"+currentDate+"'";
        try {
            con=(Connection) c.getConnection();
            Statement st_get_sms =(Statement) con.createStatement();
            ResultSet rs_sms=st_get_sms.executeQuery(sql_Get_SMS);
            while(rs_sms.next()){

                keyword=rs_sms.getString("keyword_name");
                mob_num=rs_sms.getString("mobile_num");
                sms=rs_sms.getString("sms");
                recID=getRecID(keyword);

                //sendMsg_test(mob_num,sms,recID);
                sendMsg(mob_num,sms,recID);
                System.out.println("ID: "+id+" KEY: "+keyword+" recID: "+recID+" mob: "+mob_num+" SMS: "+sms);
             
                    id++;
            }
           } catch (Exception e) {
                System.out.println(e);
        }

    }

    public static String now(String dateFormat) {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
        return sdf.format(cal.getTime());

    }

  public int getRecID(String keyword) {
     String recID_temp;
      int recID=0;

        String sql_Get_recID = "SELECT keyword_recid FROM `keyword` where status=1 and keyword_name='"+keyword+"' and keyword_type='sub-i'";
                            try {
                                con=(Connection) c.getConnection();
                                Statement st =(Statement) con.createStatement();
                                ResultSet rs=st.executeQuery(sql_Get_recID);
                                while(rs.next()){
                                    recID_temp=rs.getString("keyword_recid");
                                    recID = Integer.parseInt(recID_temp);
                                   }
                               } catch (Exception e) {
                            }
        return recID;
   }

  void sendMsg_test(String mobile, String msg, int recid){

        System.out.println(mobile+msg+recid);
    }

    void sendMsg(String mobile, String msg, int recid) throws MalformedURLException, IOException{

        String url = "http://premium.joshbox.com.bd:8001/sendsms.aspx";

        String operator = mobile.substring(0, 5);
        String telcoID = "1";
        String charge="0";
        String sp="9934";
        if (operator.equals("88017")) {
            telcoID = "1";
            charge="200";
        } else if (operator.equals("88018")) {
            telcoID = "4";
            charge="230";
            sp="9934";
        } else if (operator.equals("88015")) {
            telcoID = "5";
        } else if (operator.equals("88019")) {
            telcoID = "3";
        } else if (operator.equals("88011")) {
            telcoID = "2";
        } else if (operator.equals("88016")) {
            telcoID = "6";
        }
      
        String encodeSMS = URLEncoder.encode(msg.toString(),"UTF-8");

        String data = "user=admin&pass=admin&to=" + mobile + "&type=1&charge="+charge+"&msg=" + encodeSMS + "&recID=" + recid + "&groupID=0&sp="+sp+"&telcoID=" + telcoID;
        String all = url + '?' + data;
       
        System.out.println(all);

       
       
       URL yahoo = new URL(all);
        URLConnection yc = yahoo.openConnection();
        BufferedReader in = new BufferedReader(
                new InputStreamReader(
                yc.getInputStream()));
        String inputLine;

        while ((inputLine = in.readLine()) != null) {
            System.out.println(inputLine);
        }
        in.close();
         
        
       
    }


}

