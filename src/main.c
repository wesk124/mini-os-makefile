#include <stdio.h>
#include <unistd.h>

int main(void) {
	int i;
	
	sleep(1);
	for(i=0; i<5; i++)
	{
		printf("hello world\n");
		sleep(1);
	}
	
        return 0;
}
