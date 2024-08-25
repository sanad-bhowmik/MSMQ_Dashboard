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
import com.mysql.jdbc.Statement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Admin
 */
public class Sms_Finder extends Thread {
    public static boolean flag = false;
    ChildThread ct;
    Connection con;
    ConnectionBean c;    
    public Sms_Finder() {
        c=new ConnectionBean();
    }

    @Override
    public void run() {
        while (true) {
            flagChange();
            if (flag) {
                flag = false;
            }            
            System.out.println("\n"+"Running.......");
            try {
                Thread.sleep(60000);
            } catch (InterruptedException ex) {
                Logger.getLogger(Sms_Finder.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    private void flagChange() {        
        String currentTime = now("HH:mm");
        String currentTimetemp = currentTime+":00";
        String currentTime1 = now("yyyy.MMMMM.dd H:mm:ss");
        System.out.println(currentTime1);
        System.out.println(currentTimetemp);
        String key="";
        String time;
        int free_status=0;
        String recID="";

       try {
            

                if (currentTimetemp.matches("10:00 AM")) {
                    ct = new ChildThread();
                    ct.start();
                    System.out.println( key + "started");
                }
            
           } catch (Exception e) {
                System.out.println(e);
        }
        if (currentTime.matches("12:25 PM")) {
            flag = true;
        }
   }

    public static String now(String dateFormat) {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
        return sdf.format(cal.getTime());
    }
}

