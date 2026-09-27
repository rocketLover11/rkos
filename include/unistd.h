#pragma once

#include <sys/types.h>
#include <stddef.h>

ssize_t write(int fd, const void *buf, size_t count);
ssize_t read(int fd, void *buf, size_t count);
int close(int fd);
pid_t fork(void);
int execve(const char *path, char *const argv[], char *const envp[]);
pid_t wait4(pid_t pid, int *status, int options, void *rusage);
void _exit(int status) __attribute__((noreturn));