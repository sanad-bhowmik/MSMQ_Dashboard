/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package todaysubs;

/**
 *
 * @author Shibly
 */
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


public class ConnectionBean implements java.io.Serializable {

    private Connection con;
    private String dbName = "smspanelnew";
    private String userName = "root";
    private String password = "";
    private String host = "localhost:3306";
    private String url = "jdbc:mysql://" + host + "/" + dbName;

    public ConnectionBean(){


    }

    public Connection getConnection() {
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            con = DriverManager.getConnection(url, userName, password);
              System.out.println("DB Connected");
        } catch (Exception e) {
              System.out.println(e);
        }
        return this.con;
    }
    public void setConnection(Connection acon) {
        this.con = acon;
    }

    public void closeConnection() {
        try {
            this.con.close();
        } catch (SQLException ex) {
            Logger.getLogger(ConnectionBean.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}


