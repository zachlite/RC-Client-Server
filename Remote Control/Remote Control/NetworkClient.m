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
        
        if (self.sockFileDescriptor != -1) {

            self.isConnected = YES;
            char message[] = "iPhoneClient!";
            [self sendData:message onSocket:self.sockFileDescriptor];
            [self receiveDataFromSocket:self.sockFileDescriptor];
            return 0;
        }
        else{
            self.isConnected = NO;
            return -1;
        }
        
    }
    return -1;
    
}



-(int)sendData:(const void *)data onSocket:(int)sockfd
{
    


    if(net_is_connected(sockfd))
    {
        Data_Packet packet;
        uint16_t HBO_packet = ntohs((unsigned short)data);
        
        memcpy(&packet, &HBO_packet, sizeof(HBO_packet));
        NSLog(@"sent %d %d", packet.direction, packet.throttle);
        
        send(sockfd, data, sizeof(data), 0);
    }
    else
    {
        close(sockfd);
        self.isConnected = NO;
    }
    
    return 0;
}

-(int)receiveDataFromSocket:(int)sockfd
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
