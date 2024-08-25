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
import java.sql.SQLException;
import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.util.Date;
/**
 *
 * @author Admin
 */
public class ChildThread extends Thread {
    Connection con;
    ConnectionBean c;
    String key;
    String recID;
    String id;
    String currentTime;
    String currentTime12;
    int free_status = 0;
    String data;

    public ChildThread() {
        c = new ConnectionBean();
    }

    @Override
    public void run() {
        try {
            work();
        } catch (SQLException ex) {
            Logger.getLogger(ChildThread.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public synchronized void work() throws SQLException {
        int i = 0;
        int countSMS = 0;
        while (i++ < 1) {
            try {
                Thread.sleep(100);
                currentTime = getCurrentTime("yyyy-MM-dd H:mm:ss");
                currentTime12 = getCurrentTime("yyyy-MM-dd");
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                Calendar cd = Calendar.getInstance();
                cd.setTime(new Date());
                cd.add(Calendar.DATE, 1);
                currentTime12 = dateFormat.format(cd.getTime());

                try {
                    con = (Connection) c.getConnection();
                    String query = "SELECT number, keyword FROM subscribers WHERE status = 1 AND number LIKE '88019%'";
                    Statement stmt = (Statement) con.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    
                    while (rs.next()) {
                        String msisdn = rs.getString("number");
                        String keyword = rs.getString("keyword");
                        try {
                            sendMsg(msisdn, keyword);
                            countSMS++;
                        } catch (Exception e) {
                            System.out.println("Exception: " + e);
                        }
                    }
                    
                } catch (Exception e) {
                    System.out.println("Exception: " + e);
                }
            } catch (InterruptedException ex) {
                Logger.getLogger(ChildThread.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        System.out.println("SMS OF KEYWORD " + key + " SENT. " + countSMS + "\n");
    }

    void sendMsg(String msisdn, String keyword) throws MalformedURLException, IOException {
    String url = "http://103.228.39.36/BLSDP/subscription_renewal_ph1.php";

    String encodeKeyword = URLEncoder.encode(keyword, "UTF-8");

    data = "msisdn=" + msisdn + "&keyword=" + encodeKeyword;
    String all = url + '?' + data;

    // Send HTTP request
    URL requestUrl = new URL(all);
    URLConnection connection = requestUrl.openConnection();
    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
    String inputLine;
    
    while ((inputLine = in.readLine()) != null) {
        System.out.println("Response: " + inputLine);
    }
    in.close();
    System.out.println("Sent message with URL: " + all);
    }




    public static String getCurrentTime(String dateFormat) {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
        return sdf.format(cal.getTime());
    }
    }
