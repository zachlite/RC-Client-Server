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
#include "index.h"
#include <pthread.h>



int serve(const char *PORT);
int serv_listen_for_client(int sockfd);
void* serv_client_handler(void *arg);








void* serv_client_handler(void *arg)
{
    char *welcomeMessage = "Joined Server successfully";
    unsigned long msgLength; long byte_sent;
    msgLength = strlen(welcomeMessage);


    new_client *nc = arg;
    int clientfd = nc->new_client_fd;
    char *clientaddr = nc->client_addr;



    

    printf("sending welcome to client\n");
    byte_sent = send(clientfd, welcomeMessage, sizeof(welcomeMessage), 0);                
    if (byte_sent == -1)
    {
        fprintf(stderr, "send failed %s\n", strerror(errno));

    }
   



    //by this point, the type of client has been established.

    //launch processing thread


    //here we listen for client requests, and load them on to the queue to be processed

    bool client_connected = true;
    int packet_count = 0;

    //int size = sizeof(char);

    while (client_connected)
    {
        if(1)
        //if (net_is_connected(clientfd))
        {
            // char packet;
            Data_Packet packet;
            int bytes_received;


            //printf("listening for client request....\n");
            bytes_received = recv(clientfd, &packet, sizeof(packet), 0);
            
            if (bytes_received == 0)
            {
                printf("client has disconnected!!!!\n");
                client_connected = false;
            }

            else if(bytes_received < sizeof(packet))
            {
                printf("recieved %d bytes\n", bytes_received);
                printf("incomplete transfer!\n");
            }


            else
            {
                //printf("recieved %d bytes\n", bytes_received);

                packet_count++;
                
                printf("%d %d\n", packet.throttle, packet.direction);



                //printf("packet # %d\n", packet_count);
                //fprintf(stderr ,"---------------->throttle: %d ---------------->direction: %d\n", packet.throttle, packet.direction);
                //printf("--------->%x\n", packet);


                //net_print_received_data(packet.throttle);
                //net_print_received_data(packet.direction);
                
                //respond
                //strcat(client_request, ": request received by server");
                //send(clientfd, client_request, sizeof(client_request), 0);

                //issue command to car
            }


          

        }
        else
        {
            printf("client is not there\n");
            client_connected = false;
        }

    }

    printf("received %d packets\n", packet_count);

    // while (client_connected) //while client server connection is present
    // {

        





    //     if (net_is_client_there(clientfd))
    //     {

    //         recv(clientfd, buffer, sizeof(buffer), 0);
    //         printf("%s",buffer);



    //         printf("sending data to client\n");
    //         byte_sent = send(clientfd,index_data, sizeof(index_data), 0);
                
    //         if (byte_sent == -1)
    //         {
    //            fprintf(stderr, "send failed %s\n", strerror(errno));
                    
    //         }
    //     }
    //     else
    //     {
    //         client_connected = false;
    //     }

    //     sleep(1);


    //     // sleep(1);
    //     // printf("sending data to client\n");
    //     // byte_sent = send(clientfd, welcomeMessage, msgLength, 0);
        
    //     // if (byte_sent == -1)
    //     // {
    //     //     fprintf(stderr, "send failed %s\n", strerror(errno));
            
    //     // }
    
    // }
    
    free(nc);

    close(clientfd);
    printf("client disconnected\n");
    return NULL;
}




int serv_listen_for_client(int sockfd)
{
    printf("Waiting for connections\n");
    
    
    int listenStatus;
    
    listenStatus = listen(sockfd, 3);
    
    if (listenStatus == -1) {
        fprintf(stderr, "listen failed %s\n", strerror(errno));
        return -1;
    }
    
    
    
    
    char s[INET6_ADDRSTRLEN];
    //    char *welcomeMessage = "Joined Server successfully";
    //    unsigned long msgLength; long byte_sent;
    //    msgLength = strlen(welcomeMessage);
    
    
    while (1) //continuously listen for incoming connections
    {

        struct sockaddr_storage their_addr;
        socklen_t addr_size;
        int newfd;
        addr_size = sizeof(their_addr);
        
        
        //accept a new connection and get its file descriptor
        newfd = accept(sockfd, (struct sockaddr *)&their_addr, &addr_size);
        
        
        inet_ntop(their_addr.ss_family, get_in_addr((struct sockaddr *)&their_addr), s, sizeof(s));
        printf("Server received a connection from %s\n", s);
        

        //thread creation
        pthread_t thread_id;
        void *thread_status;

        //struct to tell the new client handler about the new socket!
        new_client *newc = malloc(sizeof(*newc));
        newc->new_client_fd = newfd;
        strncpy(newc->client_addr, s, INET6_ADDRSTRLEN);


        if (pthread_create(&thread_id, NULL, &serv_client_handler, newc) != 0)
        {
            fprintf(stderr, "can't create thread %s\n", strerror(errno));
            free(newc);
        }


        //net_client_handler(newfd, s);
        
        //then spawn a new thread to handle it.
        //        while (1)
        //        {
        //            sleep(1);
        //            byte_sent = send(newfd, welcomeMessage, msgLength, 0);
        //
        //            if (byte_sent == -1)
        //            {
        //                fprintf(stderr, "%s\n", strerror(errno));
        //
        //            }
        //        }
        
        //then close the socket when the thread is done..
        //close(newfd);
        
        
        
    }

    //pthread_join(thread_id, &thread_status);

    
    
    
    return 0;
}




int serve(const char *PORT)
{
    
    int sockfd;

    printf("initializing web server\n");

    
    if ((sockfd = net_open(NULL, PORT, SERVER)) == -1)
    {
        fprintf(stderr, "error: server initialization failed\n");
        return -1;
    }
    
    
    if (serv_listen_for_client(sockfd) == -1)
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
    for (int i = 0; i < 100; ++i)
    {
        printf("*");
    }
    printf("\n");


    if (argv[1] == NULL)
    {
        argv[1] = "5000";
    }

    serve(argv[1]);
    
    return 0;
}



