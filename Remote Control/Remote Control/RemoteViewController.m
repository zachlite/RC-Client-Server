//
//  RemoteViewController.m
//  Remote Control
//
//  Created by Zach Lite on 7/19/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#import "RemoteViewController.h"

@interface RemoteViewController ()

//@property (nonatomic) double delta_throttle;
//@property (nonatomic) double old_throttle;

@property (nonatomic) double delta_direction;
@property (nonatomic) double old_direction;
@property (nonatomic) double direction;

@end

@implementation RemoteViewController
@synthesize y_label, x_label, z_label;
@synthesize accelManager;
@synthesize movingImage;


@synthesize delta_direction;
@synthesize old_direction;
@synthesize direction;

@synthesize throttle;
@synthesize direction_label;
//@synthesize delta_throttle;
//@synthesize old_throttle;


-(NSString *)double_to_string:(double) num
{
    return [NSString stringWithFormat:@"%f", num];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [self.throttle removeConstraints:self.throttle.constraints];
//    [self.throttle setTranslatesAutoresizingMaskIntoConstraints:YES];
//    
//    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    self.throttle.transform = trans;
    
    [self.throttle setCenter:CGPointMake(self.view.frame.size.height - 60, self.view.center.x)];
    
    [self.throttle addTarget:self action:@selector(resetThrottle) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.throttle addTarget:self action:@selector(throttleEngine) forControlEvents:UIControlEventAllEvents];
    
    
    self.movingImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.movingImage setCenter:CGPointMake(self.view.center.y, self.view.center.x)];
    self.movingImage.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.movingImage];
    
    
    
    self.accelManager = [[CMMotionManager alloc] init];
    
    
    self.accelManager.accelerometerUpdateInterval = .01;
    [self.accelManager startAccelerometerUpdates];
    
    
    [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateAccelerometerData) userInfo:nil repeats:YES];
   
    
}
-(void)throttleEngine
{
    NSLog(@"throttle value: %f ", self.throttle.value);
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


-(void)updateAccelerometerData
{
    
    self.delta_direction = accelManager.accelerometerData.acceleration.y - self.old_direction;
    self.delta_direction *= 100;
    
    
    
    
    [self.movingImage setCenter:CGPointMake(self.movingImage.center.x + self.delta_direction, self.movingImage.center.y)];// + self.delta_throttle)];
    

    
    
    
    self.old_direction = accelManager.accelerometerData.acceleration.y;

}

- (IBAction)Calibrate:(id)sender {
    
    [self.movingImage setCenter:CGPointMake(self.view.center.y, self.view.center.x)];
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
