#ifndef STRINGS_H
#define STRINGS_H

void int_to_ascii(int n, char str[]);
void hex_to_ascii(int n, char str[]);
void reverse(char s[]);
int strlen(char s[]);
void backspace(char s[]);
void append(char s[], char n);
void prepend(char s[], char n);
int strcmp(char s1[], char s2[]);
void strpad( char s[], int olen, char pd );
char* itoa(int i, char b[]);

#endif
