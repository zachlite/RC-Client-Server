//
//  RemoteViewController.m
//  Remote Control
//
//  Created by Zach Lite on 7/19/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#import "RemoteViewController.h"
#import "NetworkClient.h"
#define SENSITIVITY 150
#define THRESHOLD 90

@interface RemoteViewController ()

//@property (nonatomic) double delta_throttle;
//@property (nonatomic) double old_throttle;


@property (nonatomic) double delta_direction;
@property (nonatomic) double old_direction;
@property (nonatomic) double direction;
@property (nonatomic) CGFloat screen_center_x;

@end

@implementation RemoteViewController
@synthesize y_label, x_label, z_label;
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
    
    [self.throttle addTarget:self action:@selector(resetThrottle) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    //[self.throttle addTarget:self action:@selector(throttleEngine) forControlEvents:UIControlEventAllEvents];
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
    [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(turnWheel) userInfo:nil repeats:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(throttleEngine) userInfo:nil repeats:YES];

    
    client = [[NetworkClient alloc] initWithHost:"192.168.1.101" Port:"5001"];
    
    
}

- (IBAction)connect:(id)sender {
    [client connectToHost];
    if (client.isConnected) {
        self.status_light.backgroundColor = [UIColor greenColor];
    }
    
}


-(void)throttleEngine
{
    //NSLog(@"throttle value: %f ", self.throttle.value);
    
    if (client.isConnected) {
        char message[10];
        sprintf(message, "%f", self.throttle.value);
        [client sendData:message onSocket:client.sockFileDescriptor];
    }
    
    
}

-(void)resetThrottle
{
    [UIView animateWithDuration:.2 animations:^{
        [self.throttle setValue:0.0 animated:YES];
    }completion:^(BOOL finished){
        if (finished) {
            [self throttleEngine];
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
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(self.direction * (M_2_PI / 90));
    self.wheel.transform = transform;
    
    self.direction_label.text = [self double_to_string:self.direction / THRESHOLD];
    
    
    self.old_direction = accelManager.accelerometerData.acceleration.y;

}

- (IBAction)Calibrate:(id)sender {
    
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
