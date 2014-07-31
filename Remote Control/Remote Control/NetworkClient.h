//
//  NetworkClient.h
//  Remote Control
//
//  Created by Zach Lite on 7/20/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "network.h"

@interface NetworkClient : NSObject
{
    char *host_addr;
    char *port_num;
}



@property (nonatomic) BOOL isConnected;
@property (nonatomic) int sockFileDescriptor;

-(id)initWithHost:(char *)host Port:(char*)port;

-(int)connectToHost;
-(int)sendData:(const void *)data onSocket:(int)sockfd;
-(int)receiveData:(int)sockfd;
-(void)disconnect;
//-(void)checkConnectionStatus;



-(void)printClientInfo;

@end
