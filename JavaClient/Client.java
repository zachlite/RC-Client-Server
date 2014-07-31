import java.io.*;
import java.net.*;

public class Client
{
	public static void main(String[] args) throws Exception
	{

		

		System.out.println("Initializing Client");

		Socket clientSocket = new Socket("127.0.0.1", 5000);
		DataOutputStream out = new DataOutputStream(clientSocket.getOutputStream());


		
		Integer throttle = 27;
		Integer direction = 93;


		byte[] data = "data".getBytes();

		data[0] = throttle.byteValue();
		data[1] = direction.byteValue();

		//byte[] data = hexStringToByteArray("1b0f");

		out.write(data, 0, 2);

		clientSocket.close();
	}


	public static byte[] hexStringToByteArray(String s) 
	{
		int len = s.length();
		byte[] data = new byte[len / 2];

		for (int i = 0; i < len; i += 2)
		{
			data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
			                      + Character.digit(s.charAt(i+1), 16));
		}

		return data;
	}

}