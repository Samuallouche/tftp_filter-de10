#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define HW_REGS_BASE 0xFF200000
#define HW_REGS_SPAN 0x00200000


void reverseString(char *inputString) {
    int length = strlen(inputString);  // Find the length of the string
    int i, j = length - 1;
    char temp;

    // Swap characters starting from the ends moving towards the center
    for (i = 0; i < length / 2; i++) {
        temp = inputString[i];
        inputString[i] = inputString[j];
        inputString[j] = temp;
        j--;
    }
}

int main() {
    int fd;
    int cnt=0;
    void *virtual_base;
    volatile uint32_t *filter_addr;
    char file_type[5] = {0};  
    char command[10];         
    uint32_t current_types[4] = {0};  

    // Open the /dev/mem device
    fd = open("/dev/mem", (O_RDWR | O_SYNC));
    if (fd == -1) {
        fprintf(stderr, "Could not open \"/dev/mem\"...\n");
        return -1;
    }

    // Memory map the peripheral physical address
    virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);
    if (virtual_base == MAP_FAILED) {
        fprintf(stderr, "mmap() failed...\n");
        close(fd);
        return -1;
    }
    printf("Welcome to the tftp filter- a game changer in the network security");
    while (1) {
        printf("What action would you like to do in the filter: (add+, delete-, reset X, exit ->, show » ) ");
        scanf("%s", command);

        if (strcmp(command, "exit") == 0) {
             for (int i = 0; i < 4; i++) {
                current_types[i] = 0;
                filter_addr = (volatile uint32_t *)(virtual_base + i * 4);
                *filter_addr = 0;
            }
            printf("You are exiting the system \n");
            break;
        }

        if (strcmp(command, "reset") == 0) {
            for (int i = 0; i < 4; i++) {
                current_types[i] = 0;
                filter_addr = (volatile uint32_t *)(virtual_base + i * 4);
                *filter_addr = 0;
            }
            printf("All files types to filter have been reset.\n");
        } 
        else if (strcmp(command, "add") == 0) {
            printf("Enter a file type to filter: ");
            scanf("%4s", file_type);
            reverseString(file_type);
            int added = 0;
            for (int i = 0; i < 4; i++) {
                if (current_types[i] == 0) {
                    current_types[i] = *(uint32_t *)file_type;
                    filter_addr = (volatile uint32_t *)(virtual_base +  i * 4);
                    *filter_addr = current_types[i];
                    reverseString(file_type);
                    printf("File type '%s' added to the filter.\n",file_type);
                    added = 1;
                    break;
                }
            }
            if (!added) {
                printf("Error: No available. Delete an existing type first. we can filter up to 4 types!\n");
            }
        } else if (strcmp(command, "delete") == 0) {
            printf("Enter a file type to delete from the filter: \n ");
            scanf("%4s", file_type);
            reverseString(file_type);
            int found = 0;
            for (int i = 0; i < 4; i++) {
                if (current_types[i] == *(uint32_t *)file_type) {
                    current_types[i] = 0;
                    filter_addr = (volatile uint32_t *)(virtual_base +  i * 4);
                    *filter_addr = 0;
                    reverseString(file_type);
                    printf("File type '%s' deleted.\n",file_type);
                    found = 1;
                    break;
                }
            }
            if (!found) {
                printf("File type '%s' not found.\n",file_type);
            }
        }
           else if (strcmp(command, "show") == 0) {
            printf("All the type of data that you are already filtering: \n");
            for (int i = 0; i < 4; i++) {
                if (current_types[i] != 0) {
                    printf("file type: '%s'\n",file_type);
                  }
                else{
                cnt++;
                if (cnt==4) {
                    printf("You are currently not filtering anything!! \n");
                    cnt=0;
                }
                }
            } 
        }
         else {
            printf("Invalid command.\n");
        }
    }

    // Cleanup
    if (munmap(virtual_base, HW_REGS_SPAN) != 0) {
        fprintf(stderr, "munmap() failed...\n");
    }

    close(fd);
    return 0;
}
