//
//  SettingsViewController.h
//  Remote Control
//
//  Created by Zach Lite on 7/22/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;
@protocol SettingsViewControllerDelegate <NSObject>

-(void)getFromViewController:(SettingsViewController *)controller :(NSString *)host :(NSString*)port;


@end

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) id <SettingsViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UITextField *HostField;
@property (weak, nonatomic) IBOutlet UITextField *PortField;

@end
