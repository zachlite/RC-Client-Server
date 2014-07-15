//
//  main.c
//  WebServer
//
//  Created by Zach Lite on 7/9/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "network.h"




int server(const char *PORT)
{
    
    int sockfd;

    printf("initializing web server\n");

    
    if ((sockfd = net_open(NULL, PORT, SERVER)) == -1)
    {
        fprintf(stderr, "error: server initialization failed\n");
        return -1;
    }
    
    
    if (net_listen_for_client(sockfd) == -1)
    {
        fprintf(stderr, "error: could not listen on network");
        close(sockfd);
        return -1;
    }
    
    
    
    
    close(sockfd);
    
    return 0;
    
}



int main(int argc, const char * argv[])
{
    server(argv[1]);
    
    return 0;
}



