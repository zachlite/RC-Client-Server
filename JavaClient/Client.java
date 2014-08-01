import java.io.*;
import java.net.*;

public class Client
{
    
    private Socket clientSocket;
    private DataOutputStream out;
    
    public Client(String host, int port) throws Exception
    {
        
        InitializeNetwork(host, port);

    }
    
    
	public static void main(String[] args) throws Exception
	{

        new Client("192.168.1.227", 5000);
		

	}
    
    public void transmit(Integer throttle, Integer direction) throws Exception
    {
        byte[] transmit_data = "data".getBytes();
        
		transmit_data[0] = throttle.byteValue();
		transmit_data[1] = direction.byteValue();
        
        out.write(transmit_data, 0 , 2);
        
    }

    
    private void InitializeNetwork(String host, int port) throws Exception
    {
        
		System.out.println("Initializing Client");
        
		this.clientSocket = new Socket(host, port);
		this.out = new DataOutputStream(this.clientSocket.getOutputStream());

        
    }

	public void CloseConnection() throws Exception
    {
        this.clientSocket.close();
    }

}