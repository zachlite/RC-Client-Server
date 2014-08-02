package zach.remote;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.SeekBar;

import java.net.ConnectException;


public class remote extends Activity {

    private Button connectButton;
    private Button disconnectButton;
    private Client client;
    private Boolean clientConnected;

    private SeekBar steering;
    private SeekBar throttle;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_remote);

        this.connectButton = (Button) this.findViewById(R.id.connectButton);
        this.connectButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                System.out.println("button pressed");

                InitClient();


            }
        });

        this.disconnectButton = (Button) this.findViewById(R.id.disconnectButton);
        this.disconnectButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                System.out.println("disconnect button pressed");
                KillClient();
            }
        });


        this.steering = (SeekBar) findViewById(R.id.steeringBar);
        this.steering.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                client.set_direction(seekBar.getProgress());
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                seekBar.setProgress(90);
                client.set_direction(seekBar.getProgress());
            }
        });

        this.throttle = (SeekBar) findViewById(R.id.throttleBar);
        this.throttle.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                client.set_throttle(seekBar.getProgress());
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                seekBar.setProgress(90);
                client.set_throttle(seekBar.getProgress());
            }
        });



    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.remote, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }


    private void KillClient()
    {
        if (client.getIsConnected())
        {
            client.CloseConnection();

        }

    }


    private void InitClient()
    {

            try
            {
                this.client = new Client("192.168.1.227", 5000);
                this.client.start();

            }
            catch (Exception e)
            {
                System.out.println("exception caught");
                System.out.println(e);
            }




    }

}
