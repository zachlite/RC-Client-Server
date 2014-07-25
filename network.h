//
//  network.h
//  WebServer
//
//  Created by Zach Lite on 7/12/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#ifndef NETWORK_H
#define NETWORK_H

#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <poll.h>
#include <stdbool.h>


typedef enum {SERVER, CLIENT} HostType_t;

typedef struct{
    char client_addr[INET6_ADDRSTRLEN];
    int new_client_fd;
}new_client;

typedef struct
{
   signed char throttle;
   signed char direction;
    signed char count;
    
}Data_Packet;


int net_open(const char *host, const char *port, HostType_t hostType);
bool net_is_connected(int fd);

void net_print_received_data(char *data);


void *get_in_addr(struct sockaddr *sa);
void net_print_IP(const char *host, struct addrinfo *netinfo);
int net_show_IP(const char HOST[]);


#endif
