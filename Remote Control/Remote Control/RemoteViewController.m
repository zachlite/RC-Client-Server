//
//  RemoteViewController.m
//  Remote Control
//
//  Created by Zach Lite on 7/19/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#import "RemoteViewController.h"
#import "NetworkClient.h"
#import "SettingsViewController.h"
#define SENSITIVITY 85
#define THRESHOLD 90

#define SEND_INTERVAL .01
#define THROTTLE_UPDATE_INTERVAL .02
#define DIRECTION_UPDATE_INTERVAL .02

@interface RemoteViewController ()

//@property (nonatomic) double delta_throttle;
//@property (nonatomic) double old_throttle;



@property (nonatomic) double direction;


@end

@implementation RemoteViewController


@synthesize steering;
@synthesize direction;


@synthesize throttle;
@synthesize direction_label;

@synthesize status_light;
@synthesize status_message;
@synthesize NetworkAccessButton;

@synthesize host_string, port_string;

@synthesize client;

//@synthesize delta_throttle;
//@synthesize old_throttle;


-(NSString *)double_to_string:(double) num
{
    return [NSString stringWithFormat:@"%f", num];
}

-(void)initThrottleSlider
{
    //    [self.throttle removeConstraints:self.throttle.constraints];
    //    [self.throttle setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    self.throttle.transform = trans;
    
    [self.throttle setCenter:CGPointMake(self.view.frame.size.height - 60, self.view.center.x)];
    
    [self.throttle setContinuous:NO];
    
    [self.throttle addTarget:self action:@selector(resetThrottle) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    //[self.throttle addTarget:self action:@selector(updateThrottle) forControlEvents:UIControlEventAllEvents];
}

-(void)initSteeringSlider
{
    [self.steering setContinuous:NO];
    [self.steering addTarget:self action:@selector(resetSteering) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}
    


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    [self initThrottleSlider];
    [self initSteeringSlider];
    
    
    
    
}

-(void)killTimers
{
    [dataSender invalidate];
    [directionUpdater invalidate];
    [throttleUpdater invalidate];
}

-(void)initTimers
{
   
    if (![dataSender isValid])
    {
        dataSender = [NSTimer scheduledTimerWithTimeInterval:SEND_INTERVAL target:self selector:@selector(sendCarData) userInfo:nil repeats:YES];

    }
    if (![directionUpdater isValid])
    {
        directionUpdater = [NSTimer scheduledTimerWithTimeInterval:DIRECTION_UPDATE_INTERVAL target:self selector:@selector(updateDirection) userInfo:nil repeats:YES];

    }
    if (![throttleUpdater isValid])
    {
        throttleUpdater = [NSTimer scheduledTimerWithTimeInterval:THROTTLE_UPDATE_INTERVAL target:self selector:@selector(updateThrottle) userInfo:nil repeats:YES];
    }
   
}


-(void)getFromViewController:(SettingsViewController *)controller :(NSString *)host :(NSString *)port
{

    
    if ([host isEqualToString:@""] || [port isEqualToString:@""])
    {
        self.host_string = NULL;
        self.port_string = NULL;
    }
    else
    {
        self.host_string = host;
        self.port_string = port;
    }
    

    
    char hostBuffer[INET6_ADDRSTRLEN];
    char portBuffer[INET6_ADDRSTRLEN];

    if(![host getCString:hostBuffer maxLength:sizeof(hostBuffer) encoding:NSUTF8StringEncoding])
    {
        NSLog(@"host conversion error");
    }
    if(![port getCString:portBuffer maxLength:sizeof(portBuffer) encoding:NSUTF8StringEncoding])
    {
        NSLog(@"port conversion error");
    }
    
  
    
    strncpy(PORT, portBuffer, sizeof(PORT));
    strncpy(HOST, hostBuffer, sizeof(HOST));
    
    
    
    
}
- (IBAction)defaultSettings:(id)sender {
    self.host_string = @"d";
    self.port_string = @"3";
    
    strncpy(PORT, "5000", sizeof("5000"));
    strncpy(HOST, "192.168.1.227", sizeof("192.168.1.227"));

    
}

- (IBAction)settingsPressed:(id)sender {
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    settingsViewController.delegate = self;
    
    [self presentViewController:settingsViewController animated:YES completion:nil];
    
}

- (IBAction)connect:(id)sender {
    

    if (self.host_string == NULL || self.port_string == NULL)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Info" message:@"Need configuration info" delegate:self cancelButtonTitle:@"got it." otherButtonTitles:nil, nil];
            [alert show];
        
    }
    else
    {
        
  
        if (!self.client) {
            NSLog(@"client lazily instantiated");
            self.client = [[NetworkClient alloc] initWithHost:HOST Port:PORT];
        }
        
        
     
        if (client.isConnected) {
            [client disconnect];
            [self killTimers];
            [self updateConnectionUI];

        }
        else
        {
            if([client connectToHost] != -1)
            {
                PacketsSentInCurrentSession = 0;
                [self initTimers];
                [self updateConnectionUI];

            }
            
            
        }
        
    }
    
    
}

-(void)updateConnectionUI
{
    NSLog(@"updating ui");
    
    if(client.isConnected)
    {
        self.status_message.text = @"connected";
        self.status_light.backgroundColor = [UIColor greenColor];
        [self.NetworkAccessButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    }
    else
    {
        self.status_message.text = @"not connected";
        self.status_light.backgroundColor = [UIColor redColor];
        [self.NetworkAccessButton setTitle:@"Connect" forState:UIControlStateNormal];
    }
    
}

-(void)sendCarData
{
    
    if (client.isConnected)
    {
        NSLog(@"Sending packet #%d", ++PacketsSentInCurrentSession);
        NSLog(@"%d %d", packet.throttle, packet.direction);
        if([client sendData:&packet onSocket:client.sockFileDescriptor] == -1)
        {
            [self updateConnectionUI];
            [self killTimers];
        }
    }
}


-(void)updateThrottle
{
    packet.throttle = (char)self.throttle.value;
}

-(void)updateDirection
{
    packet.direction = (char)self.steering.value;
    //NSLog(@"direction is %d", packet.direction);
}

-(void)resetThrottle
{
    [UIView animateWithDuration:.2 animations:^{
        [self.throttle setValue:90.0 animated:YES];
    }completion:^(BOOL finished){
        if (finished) {
            [self updateThrottle];
        }
    }];
}

-(void)resetSteering
{
    NSLog(@"steering reset");
    [UIView animateWithDuration:.2 animations:^{
        [self.steering setValue:90.0 animated:YES];
    }completion:^(BOOL finished){
        if (finished) {
            [self updateDirection];
        }
    }];
 
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
