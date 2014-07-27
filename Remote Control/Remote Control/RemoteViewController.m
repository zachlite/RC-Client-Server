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
#define SENSITIVITY 75
#define THRESHOLD 50

@interface RemoteViewController ()

//@property (nonatomic) double delta_throttle;
//@property (nonatomic) double old_throttle;


@property (nonatomic) double delta_direction;
@property (nonatomic) double old_direction;
@property (nonatomic) double direction;
@property (nonatomic) CGFloat screen_center_x;

@end

@implementation RemoteViewController
@synthesize accelManager;
@synthesize movingImage;


@synthesize delta_direction;
@synthesize old_direction;
@synthesize direction;
@synthesize screen_center_x;

@synthesize throttle;
@synthesize direction_label;

@synthesize wheel;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    [self initThrottleSlider];
    
    self.screen_center_x = self.view.center.y;
    
    self.movingImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.movingImage setCenter:CGPointMake(self.screen_center_x, self.view.center.x)];
    self.movingImage.backgroundColor = [UIColor redColor];
    //[self.view addSubview:self.movingImage];
    
    
    
    self.accelManager = [[CMMotionManager alloc] init];
    
    
    self.accelManager.accelerometerUpdateInterval = .01;
    [self.accelManager startAccelerometerUpdates];
    
    
    

    
    [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(updateAccelerometerData) userInfo:nil repeats:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(sendCarData) userInfo:nil repeats:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(updateDirection) userInfo:nil repeats:YES];
    
   
    [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(updateThrottle) userInfo:nil repeats:YES];

    

    
    
    
    
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
            self.status_message.text = @"not connected";
            self.status_light.backgroundColor = [UIColor redColor];
            [self.NetworkAccessButton setTitle:@"Connect" forState:UIControlStateNormal];
        }
        else{
            if([client connectToHost] != -1)
            {
                PacketsSentInCurrentSession = 0;
                self.status_message.text = @"connected";
                self.status_light.backgroundColor = [UIColor greenColor];
                [self.NetworkAccessButton setTitle:@"Disconnect" forState:UIControlStateNormal];
            }
            
            
        }
        
    }
    
    
    
    
    
}

-(void)sendCarData
{
    
    if (client.isConnected)
    {
        NSLog(@"Sending packet #%d", ++PacketsSentInCurrentSession);
        NSLog(@"%d %d", packet.throttle, packet.direction);
        [client sendData:&packet onSocket:client.sockFileDescriptor];
    }
}


-(void)updateThrottle
{
    packet.throttle = (char)self.throttle.value;
}

-(void)updateDirection
{
    packet.direction = (char)self.direction;
    
    if (abs(packet.direction) < 10)
    {
        packet.direction = 0;
    }
    
    //NSLog(@"direction is %d", packet.direction);
}

-(void)resetThrottle
{
    [UIView animateWithDuration:.2 animations:^{
        [self.throttle setValue:0.0 animated:YES];
    }completion:^(BOOL finished){
        if (finished) {
            [self updateThrottle];
        }
    }];
}


-(void)turnWheel
{
    //NSLog(@"wheel direction: %f", self.direction/THRESHOLD);
//    if (client.isConnected) {
//        char message[10];
//        sprintf(message, "%f", self.direction);
//        [client sendData:message onSocket:client.sockFileDescriptor];
//        
//    }
}


-(void)updateAccelerometerData
{
    
    self.delta_direction = accelManager.accelerometerData.acceleration.y - self.old_direction;
    self.delta_direction *= SENSITIVITY;

   
             

    self.direction += self.delta_direction;
    
    if (self.direction > THRESHOLD) {
        self.direction = THRESHOLD;
    }
    else if (self.direction < (THRESHOLD * -1)){
        self.direction = THRESHOLD * -1;
    }
    
    
    
    //[self.movingImage setCenter:CGPointMake(self.screen_center_x + self.direction, self.movingImage.center.y)];// + self.delta_throttle)];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(self.direction * (M_2_PI / 45));
    self.wheel.transform = transform;
    
//    self.direction_label.text = [self double_to_string:(self.direction)];
    
    
    self.old_direction = accelManager.accelerometerData.acceleration.y;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    
    if (CGRectContainsPoint(self.wheel.frame, touchPoint))
    {
        [self Calibrate];
    }
    
}

- (void)Calibrate{
    
    //[self.movingImage setCenter:CGPointMake(self.view.center.y, self.view.center.x)];
    self.direction = 0;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)slider:(id)sender {
}
- (IBAction)throttle:(id)sender {
}
@end
