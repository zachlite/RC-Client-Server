//
//  network.c
//  WebServer
//
//  Created by Zach Lite on 7/10/14.
//  Copyright (c) 2014 Zach Lite. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include "network.h"





//"<!DOCTYPE html>
// <html>
//  <head>
//      <title>RC Car</title>
//  </head>
//  <body>
//      <div style=\"text-align: center\">
//          <h1>RC Car</h1>
//          <h3>From Zach's webserver.</h3>
//          <br><br>
                
//      </div>
//  </body>
// </html>";






void* client_handler(void *arg);





int net_open(const char *host, const char *port, HostType_t hostType)
{
    
    
    
    int sockfd;
    struct addrinfo hints, *netinfo;
    
    

    //initialize socket structures
    
    memset(&hints, 0, sizeof(hints));
    
    hints.ai_family = AF_INET; //IPv4 or IPv6 indifferent.
    hints.ai_socktype = SOCK_STREAM; //TCP stream sockets
    /*on client too?*/
    hints.ai_flags = AI_PASSIVE; //fill in my IP for me
    
    
    
    int getaddrerror;
    if ((getaddrerror = getaddrinfo(host, port, &hints, &netinfo) != 0))
    {
        fprintf(stderr, "getaddrinfo error: %s\n", gai_strerror(getaddrerror));
        return -1;
    }
    
    //when would you ever not use the first one?
    //print_IPs(host, netinfo);
    
    
    
    //create socket
    sockfd = socket(netinfo->ai_family, netinfo->ai_socktype, netinfo->ai_protocol); //returns a socket descriptor!
    if (sockfd == -1)
    {
        fprintf(stderr, "socket failed : %s\n", strerror(errno));
        printf("sockfd value : %d\n", sockfd);
        return -1;
    }
    else fprintf(stderr, "socket created\n");
    
    
    //bind to socket
    if (hostType == SERVER)
    {
        if (bind(sockfd, netinfo->ai_addr, netinfo->ai_addrlen) != 0)
        {
            fprintf(stderr, "bind failed %s\n", strerror(errno));
            printf("errno value : %d\n", errno);
            return -1;
        }
        else fprintf(stderr, "socket bound to port %s\n", port);
    }
    else //go ahead and connect to server if you're the client!
    {
        if(connect(sockfd, netinfo->ai_addr, netinfo->ai_addrlen) != 0)
        {
            fprintf(stderr, "connect failed %s\n", strerror(errno));
            return -1;
        }
        else fprintf(stderr, "connected to host %s on port %s\n", host, port);
    }
    
    
    freeaddrinfo(netinfo);
    
    return sockfd;
}



void* client_handler(void *arg)
{


    new_client *nc = arg;
    int clientfd = nc->new_client_fd;
    char *clientaddr = nc->client_addr;


    bool client_connected = true;
    while(client_connected)
    {
        sleep(1);
        
        if (net_is_connected(clientfd))
        {
            printf("handling client %d\n", clientfd);
        }
        else
        {
            client_connected = false;
        }


    }

    free(nc);
    return NULL;
}




void net_print_received_data(char *data)
{
    printf("new msg -------> %s\n", data);
}



bool net_is_connected(int fd)
{
    struct pollfd pfd;
    pfd.fd = fd;
    pfd.events = POLLERR | POLLHUP; //bitmap of events we're interested in
    pfd.revents = 0; //bitmap of events that took place

    printf("Testing connection\n");
    int poll_value = poll(&pfd, 1, 100);
    if (poll_value > 0) 
    {                 
        // if result > 0, this means that there is either data available on the
         // socket, or the socket has been closed
        char buffer[32];

        if (recv(fd, buffer, sizeof(buffer), MSG_PEEK | MSG_DONTWAIT) == 0) 
        {
            // if recv returns zero, that means the connection has been closed:
            printf("client not connected\n");
            return false;
        }
        else
        {
            //there is data on the socket?
            printf("client connected\n");
            return true;
        }
    }  
    else if(poll_value == 0)
    {
        printf("client connected\n");
        return true;
    }
    else
    {
        fprintf(stderr, "poll failed %s\n", strerror(errno));
        printf("poll return value is %d \n", poll_value);
        return false;
    }


}






void *get_in_addr(struct sockaddr *sa)
{
    if (sa->sa_family == AF_INET) {
        return &(((struct sockaddr_in*)sa)->sin_addr);
    }
    return &(((struct sockaddr_in6*)sa)->sin6_addr);
}





void net_print_IP(const char *host, struct addrinfo *netinfo)
{
    char ipstr[INET6_ADDRSTRLEN];
    struct addrinfo *p;
    
    
    printf("IP addresses for %s:\n\n", host);
    for(p = netinfo ; p != NULL; p = p->ai_next) {
        void *addr;
        char *ipver;
        // get the pointer to the address itself,
        // different fields in IPv4 and IPv6:
        if (p->ai_family == AF_INET) { // IPv4
            struct sockaddr_in *ipv4 = (struct sockaddr_in *)p->ai_addr;
            addr = &(ipv4->sin_addr);
            ipver = "IPv4";
        } else { // IPv6
            struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)p->ai_addr;
            addr = &(ipv6->sin6_addr);
            ipver = "IPv6";
        }
        // convert the IP to a string and print it:
        inet_ntop(p->ai_family, addr, ipstr, sizeof ipstr);
        printf(" %s: %s\n", ipver, ipstr);
    }
}





//show IP address for a given host
int net_show_IP(const char HOST[])
{
    struct addrinfo hints, *res, *p;
    int status;
    
    char ipstr[INET6_ADDRSTRLEN];
    
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC; // AF_INET or AF_INET6 to force version
    hints.ai_socktype = SOCK_STREAM;
    if ((status = getaddrinfo(HOST, "80", &hints, &res)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(status));
        return 2;
    }
    printf("IP addresses for %s:\n\n", HOST);
    for(p = res;p != NULL; p = p->ai_next) {
        void *addr;
        char *ipver;
        // get the pointer to the address itself,
        // different fields in IPv4 and IPv6:
        if (p->ai_family == AF_INET) { // IPv4
            struct sockaddr_in *ipv4 = (struct sockaddr_in *)p->ai_addr;
            addr = &(ipv4->sin_addr);
            ipver = "IPv4";
        } else { // IPv6
            struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)p->ai_addr;
            addr = &(ipv6->sin6_addr);
            ipver = "IPv6";
        }
        // convert the IP to a string and print it:
        inet_ntop(p->ai_family, addr, ipstr, sizeof ipstr);
        printf(" %s: %s\n", ipver, ipstr);
    }
    freeaddrinfo(res); // free the linked list
    return 0;
}




