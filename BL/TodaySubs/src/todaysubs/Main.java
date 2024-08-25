/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package todaysubs;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;


/**
 *
 * @author shibly
 */
public class Main extends JFrame{

    private JFrame f = new JFrame("PLAYON24 AUTOMATED INSTANT SMS SERVICE PANEL"); //create Frame

    private JPanel pnlTxt = new JPanel(); // East quadrant
    private JPanel pnltdSrvices = new JPanel(); // Center quadrant

    private JButton starttDService = new JButton("Start Today Instant BL SMS Service");
    private JButton stoptDService = new JButton("Stop Today Instant BL SMS Service");

    private String txtareaText = "<html><font color=black><p> <ul>"
            +"<li>Updating  today Instant SMS press 'Start  Today BL Instant SMS Service'.</li>"
            + "</ul></p></font></html>";
    private JLabel jl = new JLabel(txtareaText);





    private JMenuBar mb = new JMenuBar(); // Menubar
    private JMenu mnuFile = new JMenu("File"); // File Entry on Menu bar
    private JMenuItem mnuItemQuit = new JMenuItem("Quit"); // Quit sub item


    /** Constructor for the GUI */
    public Main(){
		// Set menubar
        f.setJMenuBar(mb);

		//Build Menus
        mnuFile.add(mnuItemQuit);  // Create Quit line
        mb.add(mnuFile);        // Add Menu items to form


        pnlTxt.add(jl);

        pnltdSrvices.add(starttDService);
        pnltdSrvices.add(stoptDService);



        // Setup Main Frame

         f.getContentPane().add(pnlTxt, BorderLayout.NORTH);
         f.getContentPane().add(pnltdSrvices, BorderLayout.CENTER);

		// Allows the Swing App to be closed
        f.addWindowListener(new ListenCloseWdw());

		//Add Menu listener
        mnuItemQuit.addActionListener(new ListenMenuQuit());
        starttDService.addActionListener(new ListentStart());
        stoptDService.addActionListener(new ListenMenuQuit());

    }

    public class ListenMenuQuit implements ActionListener{
        public void actionPerformed(ActionEvent e){
            System.exit(0);
        }
    }

    public class ListenCloseWdw extends WindowAdapter{
        @Override
        public void windowClosing(WindowEvent e){
            System.exit(0);
        }
    }

   public class ListentStart implements ActionListener{
        public void actionPerformed(ActionEvent e) {

            Sms_today ST = new Sms_today();


        }

    }

    public void launchFrame(){

	f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.pack();
        f.setSize(500,250);
        f.setVisible(true);
    }

    public static void main(String args[]){
        Main gui = new Main();
        gui.launchFrame();
    }







}
