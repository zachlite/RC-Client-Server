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



int cli(const char *PORT);
int cli_listen_for_server(int sockfd);
int cli_send_to_server(int sockfd);

static const char *HOST = "192.168.1.101";


int cli_listen_for_server(int sockfd)
{

    char welcome_message[512];
    recv(sockfd, welcome_message, sizeof(welcome_message) - 1, 0);
    net_print_received_data(welcome_message);

    cli_send_to_server(sockfd);

    return 0;
}


int cli_send_to_server(int sockfd)
{

    bool server_connected = true;
    while(server_connected)
    {
        if (net_is_connected(sockfd))
        {
           char intro[] = "client here!";
           send(sockfd, intro, sizeof(intro), 0);

        }
        else
        {
            server_connected = false;
        }
    }


    return 0;
}




int cli(const char *PORT)
{
    int sockfd;

    printf("initializing web client\n");

    if ((sockfd = net_open(HOST, PORT, CLIENT)) == -1)
    {
        fprintf(stderr, "error: client initialization failed\n");
        return -1;
    }


    //introduce yourself
    char intro[] = "client here!";
    send(sockfd, intro, sizeof(intro), 0);


    //listen for welcome message
    cli_listen_for_server(sockfd);





    close(sockfd);

    return 0;
}


int main(int argc, const char * argv[])
{

    if (argv[1] == NULL)
    {
        argv[1] = "5000";
    }

    cli(argv[1]);

    return 0;    

}





/*

    //connect!
//    connect(sockFileDescriptor, results->ai_addr, results->ai_addrlen);
    
    //Also, notice that we didn't call bind(). Basically, we don't care about our local port number; we only care where we're going (the remote port). The kernel will choose a local port for us, and the site we connect to will automatically get this information from us. No worries.
    char request[300];//MAXDATASIZE
    

    // char client_message[] = "Non-Browser";
    // send(sockfd,client_message, sizeof(client_message), 0);

    char message[] = "hello. I am a car.";
    send(sockfd, message, sizeof(message), 0);


    while(1)
    {
      
        if(!net_is_connected(sockfd))
        {
            printf("Server not connected\n");
            break;
        }

        //listen for instructions
        if(recv(sockfd, request, 299, 0))//returned successfully
        {
            printf("received data\n");
            printf("%s\n", request);
            

        }
        
        
        //    fprintf(stderr, "%s\n", strerror(errno));
        
    }
    
    
    
    
    
    // char hostname[180];
    
    // gethostname(hostname, sizeof(hostname));
    // printf("host name is %s\n", hostname);
    // fprintf(stderr, "%s\n", strerror(errno));
    
    close(sockfd);
    
    return 0;

*/



