/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package sms_services;

/**
 *
 * @author shibly
 */
import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.Statement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.net.*;
import java.io.*;

/**
 *
 * @author Admin
 */
public class ChildThread extends Thread {

    Connection con;
    ConnectionBean c;
    String key;
    String recID;

    public ChildThread(String key,String recID) {
        this.key = key;
        this.recID = recID;
        c = new ConnectionBean();
    }

    public void run() {

        work();
    }

    public synchronized void work() {

        int i = 0;
        while (i++ < 1) {
            try {
                Thread.sleep(100);
                try {
                    con = (Connection) c.getConnection();
                    String sms = null;
                    String id=null;

                    String msgQuery = "select * from sms where status=1 and keyword_name='" + key + "'";
                    Statement msgSt = (Statement) con.createStatement();
                    ResultSet msgRs = msgSt.executeQuery(msgQuery);
                    if (msgRs.next()) {
                        sms = msgRs.getString("sms");
                        id=msgRs.getString("id");
                    }

                    String msgUpdate= "update sms set status=0 where id='"+ id +"' and keyword_name='" + key + "'";
                    PreparedStatement ps=(PreparedStatement) con.prepareStatement(msgUpdate);
                    ps.executeUpdate();

                    //sms = sms.replaceAll(" ", "+");

                    String query = "select * from subscriber where status=1 and subs_keyword='" + key + "'";
                    Statement st = (Statement) con.createStatement();
                    ResultSet rs = st.executeQuery(query);
                    int j = 0;
                    while (rs.next()) {
                        try {
                            Thread.sleep(100);
                        } catch (Exception e) {
                        }
                        String mobile_num = rs.getString("mobile_num");
                        try {
                          
                           sendMsg_test(mobile_num, sms, recID,j);
                           // sendMsg(mobile_num, sms, recID);
                            j++;
                        } catch (Exception e) {
                        }

                    }

                } catch (Exception e) {
                }

            } catch (InterruptedException ex) {
                Logger.getLogger(ChildThread.class.getName()).log(Level.SEVERE, null, ex);
            }
            System.out.println("SMS OF KEYWORD"+key+"SENT. "+"\n");
        }

    }

    void sendMsg_test(String mobile, String msg, String recid , int num){

        System.out.println(mobile+msg+recid+num);
    }

    void sendMsg(String mobile, String msg, String recid) throws MalformedURLException, IOException {

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
        //echo 'd'.$data;
        String all = url + '?' + data;
        //String s = "add add";
        //s = s.replaceAll(" ", "_");
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

        System.out.println(all);

    }

  
}


