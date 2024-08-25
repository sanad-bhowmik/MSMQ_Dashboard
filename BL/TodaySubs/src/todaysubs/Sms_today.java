package todaysubs;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.Statement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.net.*;
import java.io.*;
import java.util.Date;

public class Sms_today {

    Connection con;
    ConnectionBean c;
    String data;

    public Sms_today() {
        c = new ConnectionBean();
        sendMessages();
    }

    private void sendMessages() {
        String currentDate = now("yyyy-MM-dd");

        String keyword;
        String mob_num;
        String sms;

        // SQL query to fetch subscribers with keywords starting with 'START'
        String sql_Get_Subscribers = "SELECT sub.number AS mobile_num, sub.keyword "
                                    + "FROM subscribers sub "
                                    + "WHERE sub.keyword LIKE 'START%'";

        try {
            con = (Connection) c.getConnection();
            Statement st_get_subscribers = (Statement) con.createStatement();
            ResultSet rs_subscribers = st_get_subscribers.executeQuery(sql_Get_Subscribers);

            // Iterate over each subscriber
            while (rs_subscribers.next()) {
                // Get the mobile number and keyword
                mob_num = rs_subscribers.getString("mobile_num");
                keyword = rs_subscribers.getString("keyword");

                // Remove "START" and trim any extra spaces
                String trimmedKeyword = keyword.replace("START ", "").trim();

                // Debugging: Print current date, trimmed keyword, and mobile number
                System.out.println("Processing number: " + mob_num);
                System.out.println("Trimmed keyword: " + trimmedKeyword);

                // Fetch the SMS content
                sms = getSMSContent(trimmedKeyword);

                // Check if SMS content exists
                if (sms != null && !sms.isEmpty()) {
                    // Send the message
                    sendMsg(mob_num, sms, trimmedKeyword);

                    // Confirm message sent
                    System.out.println("SMS sent successfully to number: " + mob_num + " with content: '" + sms + "' and keyword: '" + trimmedKeyword + "'.");
                } else {
                    // No SMS content found for the keyword
                    System.out.println("No SMS content found for keyword '" + trimmedKeyword + "' for number: " + mob_num + ".");
                }
            }
        } catch (Exception e) {
            System.out.println("Error during message sending: " + e);
        }
    }

    public static String now(String dateFormat) {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
        return sdf.format(cal.getTime());
    }

    // Fetch the most recent SMS content based on the keyword
    public String getSMSContent(String keyword) {
        String sms = "";

        String sql_Get_SMS = "SELECT s.sms "
                           + "FROM sms s "
                           + "WHERE s.keyword = ? "
                           + "ORDER BY s.datetime DESC "
                           + "LIMIT 1";

        try {
            PreparedStatement ps = (PreparedStatement) con.prepareStatement(sql_Get_SMS);
            ps.setString(1, keyword);

            // Debugging: Print the query being executed
            System.out.println("Executing query: SELECT s.sms FROM sms s WHERE s.keyword = '" + keyword + "' ORDER BY s.datetime DESC LIMIT 1");

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                sms = rs.getString("sms");
                System.out.println("Found SMS content for keyword '" + keyword + "': " + sms);
            } else {
                System.out.println("No SMS content found for keyword '" + keyword + "'.");
            }
        } catch (Exception e) {
            System.out.println("Error during SMS content retrieval: " + e);
        }

        return sms;
    }

    void sendMsg(String mobile, String msg, String keyword) throws MalformedURLException, IOException {
        String url = "http://103.228.39.36/smppsend/blsmpp_test.php";

        String operator = mobile.substring(0, 5);
        String telcoID = "1";
        String charge = "0";
        

        
        String encodeSMS = URLEncoder.encode(msg, "UTF-8");

        // Constructing the data string with msisdn, keyword, shortcode, and message parameters
        data = "msisdn=" + mobile + "&keyword=" + keyword + "&shortcode=16658&message=" + encodeSMS;

        String all = url + '?' + data;
        System.out.println("Sending SMS: " + all);

        URL yahoo = new URL(all);
        URLConnection yc = yahoo.openConnection();
        BufferedReader in = new BufferedReader(new InputStreamReader(yc.getInputStream()));
        String inputLine;
        while ((inputLine = in.readLine()) != null) {
            System.out.println(inputLine);
        }
        in.close();
    }
}
