package zach.remote;
import java.io.*;
import java.net.*;

/**
 * Created by Zach on 7/31/14.
 */

public class Client extends Thread
{

    private Socket clientSocket;
    private String host;
    private int port;
    private DataOutputStream out;
    private Integer throttle;
    private Integer direction;
    private boolean isConnected;

    public void set_throttle(Integer throttle)
    {
        this.throttle = throttle;
    }
    public void set_direction(Integer direction)
    {
        this.direction = direction;
    }






    public Client(String host, int port) throws Exception
    {
        //super();
        this.host = host;
        this.port = port;

    }

    @Override
    public void run()
    {

        try
        {
            System.out.println("initializing host...");
            InitializeNetwork(host, port);

        }
        catch (Exception e)
        {

        }


        while(this.clientSocket.isConnected())
        {
            try
            {
                transmit();
            }
            catch (Exception e)
            {

            }


            try
            {
                sleep(50); //sleep 50 milliseconds
            }
            catch (Exception e)
            {

            }

        }
        System.out.println("client disconnected");

        CloseConnection();
    }



//    public static void main(String[] args) throws Exception
//    {
//
//        new Client("192.168.1.227", 5000);
//
//
//    }

    public void transmit() throws Exception
    {
        System.out.println("transmitting...");
        byte[] transmit_data = "data".getBytes();



        transmit_data[0] = this.throttle.byteValue();
        transmit_data[1] = this.direction.byteValue();

        this.out.write(transmit_data, 0 , 2);

    }


    private void InitializeNetwork(String host, int port) throws Exception
    {

        System.out.println("Initializing Client");

        this.clientSocket = new Socket(host, port);
        this.out = new DataOutputStream(this.clientSocket.getOutputStream());


        System.out.println("initialized");
        this.isConnected = true;
    }

    public void CloseConnection()
    {
        try
        {
            this.clientSocket.close();
            this.isConnected = false;
        }
        catch (Exception e)
        {

        }
    }

    public boolean getIsConnected()
    {return  this.isConnected;}




}
