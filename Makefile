
CC=gcc
CFLAGS=-std=c99 -g -Wall


all: server clean client


server: network.o server.o
	$(CC) $(CFLAGS) network.o server.o -o $@


server.o: server.c
	$(CC) $(CFLAGS) -c $< -o $@


client: network.o client.o
	$(CC) $(CFLAGS) network.o client.o -o $@

client.o: client.c
	$(CC) $(CFLAGS) -c $< -o $@


network.o: network.c network.h
	$(CC) $(CFLAGS) -c $< -o $@





clean: 

	rm -f network.o
	rm -f server.o		
	rm -f client.o

