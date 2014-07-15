//
//  main.c
//  WebClient
//
//  Created by Zach Lite on 7/10/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "network.h"


int main(int argc, const char * argv[])
{

    printf("initializing web client\n");
    

 
    
    
    
    int sockfd = net_open("192.168.1.102", argv[1], CLIENT);
    
    
    
    
    //connect!
//    connect(sockFileDescriptor, results->ai_addr, results->ai_addrlen);
    
    //Also, notice that we didn't call bind(). Basically, we don't care about our local port number; we only care where we're going (the remote port). The kernel will choose a local port for us, and the site we connect to will automatically get this information from us. No worries.
    char buf[300];//MAXDATASIZE
    

    // char client_message[] = "Non-Browser";
    // send(sockfd,client_message, sizeof(client_message), 0);

    while(1)
    {
       
        if(recv(sockfd, buf, 299, 0))//returned successfully
        {
            printf("received data\n");
            printf("%s\n", buf);
            

        }
        
        
        //    fprintf(stderr, "%s\n", strerror(errno));
        
    }
    
    
    
    
    
    // char hostname[180];
    
    // gethostname(hostname, sizeof(hostname));
    // printf("host name is %s\n", hostname);
    // fprintf(stderr, "%s\n", strerror(errno));
    
    close(sockfd);
    
    return 0;
}

