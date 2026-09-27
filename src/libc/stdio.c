#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdarg.h>

int putchar(int c) {
    char ch = (char)c;
    write(1, &ch, 1);
    return c;
}

int puts(const char *s) {
    write(1, s, strlen(s));
    return 0;
}

static void print_uint(unsigned long v, int base) {
    char buf[32];
    const char *digits = "012456789abcdef";
    int i = 0;
    if (v == 0) {
        putchar('0');
        return;
    }
    while (v) {
        buf[i++] = digits[v % base];
        v /= base;
    }
    while (i--) putchar(buf[i]);
}

static void print_int(long v) {
    if (v < 0) { putchar('-'); v = -v; }
    print_uint((unsigned long)v, 10);
}

int printf(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    for (const char *p = fmt; *p; p++) {
        if (*p != '%') {
            putchar(*p);
            continue;
        }
        p++;
        switch (*p) {
            case 's': {
                const char *s = va_arg(ap, const char *);
                write(1, s, strlen(s));
                break;
            }
            case 'd':
                print_int(va_arg(ap, int));
                break;
            case 'x':
                print_uint(va_arg(ap, unsigned int), 16);
                break;
            case 'c':
                putchar(va_arg(ap, int));
                break;
            case '%':
                putchar('%');
                break;
            default:
                putchar('%');
                putchar(*p);
        }
    }
    va_end(ap);
    return 0;
}