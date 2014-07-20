//
//  RemoteViewController.h
//  Remote Control
//
//  Created by Zach Lite on 7/19/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface RemoteViewController : UIViewController <UIAccelerometerDelegate>

@property (strong, nonatomic) CMMotionManager *accelManager;
@property (strong, nonatomic) UIView *movingImage;

@property (weak, nonatomic) IBOutlet UISlider *throttle;
@property (weak, nonatomic) IBOutlet UILabel *direction_label;

@property (weak, nonatomic) IBOutlet UILabel *x_label;
@property (weak, nonatomic) IBOutlet UILabel *y_label;
@property (weak, nonatomic) IBOutlet UILabel *z_label;


@end
