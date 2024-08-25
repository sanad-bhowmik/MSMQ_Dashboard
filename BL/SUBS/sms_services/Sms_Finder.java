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
import java.sql.SQLException;
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

            try{
                System.out.println(ct.isAlive());
            }
            catch (Exception ex) {
                System.out.println(""+ex);
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
        // System.out.println(now("h:mm a"));
        String currentTime = now("H:mm");
        String currentTimetemp = currentTime+":00";
        String currentTime1 = now("yyyyy.MMMMM.dd GGG H:mm:ss");
        System.out.println(currentTime1);
        System.out.println(currentTimetemp);
        String key;
        String time;
        String recID;

        String sql = "select * from keyword where status=1 and keyword_type='sub'";
        try {
            con=(Connection) c.getConnection();
            Statement st =(Statement) con.createStatement();
            ResultSet rs=st.executeQuery(sql);
            while(rs.next()){
                key=rs.getString("keyword_name");
                time=rs.getString("subs_sending_time");
                recID=rs.getString("keyword_recid");
                time=time.trim();
                key=key.trim();
                recID=recID.trim();

               // System.out.println(key+time);

                if (currentTimetemp.matches(time)) {

                    ct = new ChildThread(key,recID);
                    ct.start();
                    System.out.println( key + "started");


                }

            }
           } catch (Exception e) {
        }


        if (currentTime.matches("12:25 PM")) {
//            System.out.print("Hello");
            flag = true;
        }
        try {
            con.close();
        } catch (SQLException ex) {
            Logger.getLogger(Sms_Finder.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public static String now(String dateFormat) {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
        return sdf.format(cal.getTime());

    }
}

