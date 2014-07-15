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

char get_index[] = "GET index.html";
char index_data[] = "<h1>RC Car WebServer!</h1>";
//"<!DOCTYPE html>
// <html>
// 	<head>
// 		<title>RC Car</title>
// 	</head>
// 	<body>
// 		<div style=\"text-align: center\">
// 			<h1>RC Car</h1>
// 			<h3>From Zach's webserver.</h3>
// 			<br><br>
				
// 		</div>
// 	</body>
// </html>";




int net_open(const char *host, const char *port, HostType_t hostType);
int net_listen_for_client(int sockfd);
// int net_spawn_client_handler(int clientfd);




void *get_in_addr(struct sockaddr *sa);
void net_print_IP(const char *host, struct addrinfo *netinfo);
int net_show_IP(const char HOST[]);


#endif
