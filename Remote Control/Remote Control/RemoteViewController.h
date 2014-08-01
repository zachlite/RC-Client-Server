//
//  RemoteViewController.h
//  Remote Control
//
//  Created by Zach Lite on 7/19/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkClient.h"
#import "SettingsViewController.h"





@interface RemoteViewController : UIViewController <SettingsViewControllerDelegate>


{
    char HOST[INET6_ADDRSTRLEN];
    char PORT[INET6_ADDRSTRLEN];
    
    Data_Packet packet;
    
    NSTimer *dataSender;
    NSTimer *directionUpdater;
    NSTimer *throttleUpdater;
    

    
    int PacketsSentInCurrentSession;
    
}


@property (weak, nonatomic) IBOutlet UISlider *steering;

@property (weak, nonatomic) IBOutlet UISlider *throttle;
@property (weak, nonatomic) IBOutlet UILabel *direction_label;


@property (weak, nonatomic) IBOutlet UIView *status_light;
@property (weak, nonatomic) IBOutlet UIButton *NetworkAccessButton;
@property (weak, nonatomic) IBOutlet UILabel *status_message;

@property (nonatomic, retain) NSString *port_string;
@property (nonatomic, retain) NSString *host_string;



@property (nonatomic, retain) NetworkClient *client;
@end
