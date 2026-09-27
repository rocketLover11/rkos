#include <unistd.h>
#include <sys/syscall.h>
#include "syscall.h"

ssize_t write(int fd, const void *buf, size_t count) {
    return __syscall(SYS_write, fd, (long)buf, (long)count, 0, 0, 0);
}

ssize_t read(int fd, void *buf, size_t count) {
    return __syscall(SYS_read, fd, (long)buf, (long)count, 0, 0, 0);
}

int close(int fd) {
    return __syscall(SYS_close, fd, 0, 0, 0, 0, 0);
}

pid_t fork(void) {
    return __syscall(SYS_fork, 0, 0, 0, 0, 0, 0);
}

int execve(const char *path, char *const argv[], char *const envp[]) {
    return __syscall(SYS_execve, (long)path, (long)argv, (long)envp, 0, 0, 0);
}

pid_t wait4(pid_t pid, int *status, int options, void *rusage) {
    return __syscall(SYS_wait4, pid, (long)status, options, (long)rusage, 0, 0);
}

void _exit(int status) {
    __syscall(SYS_exit, status, 0, 0, 0, 0, 0);
    __builtin_unreachable();
}