#ifndef CRIME_H
#define CRIME_H

/*
#include <stdint.h>

unsigned char port_byte_in (uint16_t port);
void port_byte_out (uint16_t port, uint8_t data);
unsigned short port_word_in (uint16_t port);
void port_word_out (uint16_t port, uint16_t data);
*/

typedef unsigned char BYTE;

struct cr_time {
        BYTE Hours;
        BYTE Mins;
        BYTE secs;
    };

int get_time(struct cr_time *curTime);

#endif