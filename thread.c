#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>

pthread_t tid[2];

typedef


void* doSomeThing(void *arg)
{
    // unsigned long i = 0;
    pthread_t id = pthread_self();

    int thread_id = (int)arg;

    printf("thread %d\n", thread_id);
    

    if(pthread_equal(id,tid[0]))
    {

        printf("\n First thread processing\n");
        sleep(3);
        printf("first thread finished processing\n");


    }
    else
    {
        printf("\n Second thread processing\n");
        sleep(6);
        printf("second thread finished processing\n");
    }




    return NULL;
}

int main(void)
{
    int i = 0;
    int err;

    if (sizeof(int) == sizeof(void*))
    {
        printf("same size\n");
    }
    else
    {
        printf("not same\n");
    }

    void *status1;
    void *status2;

    while(i < 2)
    {
        err = pthread_create(&(tid[i]), NULL, &doSomeThing, (void*)i);
        if (err != 0)
            printf("\ncan't create thread :[%s]", strerror(err));
        else
            printf("\n Thread created successfully\n");


        i++;
    }


    pthread_join(tid[0], &status1);
    pthread_join(tid[1], &status2);

    
    return 0;
} 