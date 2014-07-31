//
//  NetworkClient.m
//  Remote Control
//
//  Created by Zach Lite on 7/20/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#import "NetworkClient.h"

@implementation NetworkClient
@synthesize isConnected;
@synthesize sockFileDescriptor;


-(id)initWithHost:(char *)host Port:(char*)port
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    host_addr = host;
    port_num = port;
    
    return self;
    
}




-(int)connectToHost
{
    if (!self.isConnected) {
        
        NSLog(@"host is %s", host_addr);
        NSLog(@"port is %s", port_num);
     
        self.sockFileDescriptor = net_open(host_addr, port_num, CLIENT);
        if (self.sockFileDescriptor != -1)
        {
            int set = 1;
            setsockopt(self.sockFileDescriptor, SOL_SOCKET, SO_NOSIGPIPE, (void*)&set, sizeof(int));
            
            [self receiveData:self.sockFileDescriptor];
            self.isConnected = YES;

            return 0;
        }
        else
        {
            self.isConnected = NO;
            
            NSString *error = [NSString stringWithFormat:@"%s", strerror(errno)];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:error delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    
            [alert show];
            
            return -1;
        }
        
    }
    return -1;
    
}



-(int)sendData:(const void *)data onSocket:(int)sockfd
{
        
    //signal(SIGPIPE, SIG_IGN);

    
    int send_result = send(sockfd, data, sizeof(Data_Packet), 0);
    if(send_result == -1)
    {
        
        NSString *error = [NSString stringWithFormat:@"%s", strerror(errno)];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Lost" message:error delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
        [self disconnect];
        NSLog(@"socket has closed");
        return -1;
    }
    

    
    return 0;
}

-(int)receiveData:(int)sockfd
{
    char buffer[512];
    
    recv(sockfd, buffer, sizeof(buffer) - 1, 0);
    net_print_received_data(buffer);
    NSLog(@"received data: %s", buffer);
    
    return 0;
}

-(void)disconnect
{
    close(self.sockFileDescriptor);
    self.isConnected = NO;
}

-(void)printClientInfo
{
    NSLog(@"client's host's address: %s", host_addr);
    NSLog(@"client's hosts's port number: %s", port_num);
}



@end
