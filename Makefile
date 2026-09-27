CC					= cc
AS					= as
AR					= ar
LD					= ld

ROOT				= ${.PARSEDIR}
INCDIR				= ${ROOT}/include
BUILDDIR			= ${ROOT}/build
ROOTDIR				= ${ROOT}/root

CFLAGS				= -ffreestanding -fno-stack-protector -nostdinc -Wall -Wextra -O1 -I${INCDIR}
LDFLAGS				= -nostdlib -static -e _start

FBSD_SRC			= ${ROOT}/src/freebsd-src
KERNCONF			= GENERIC
MAKEOBJDIRPREFIX 	= ${BUILDDIR}/kernel-obj
.export MAKEOBJDIRPREFIX

LIBC_SRCS			!= find ${ROOT}/src/libc -name '*.c'
LIBC_OBJS			= ${LIBC_SRCS:S,${ROOT}/src/libc,${BUILDDIR}/libc,g:S,.c,.o,}
LIBC_OBJS			+= ${BUILDDIR}/libc/syscall.o
CRT0_OBJ			= ${BUILDDIR}/crt0.o
LIBC_A				= ${BUILDDIR}/libc.a

INIT_SRCS			!= find ${ROOT}/src/init -name '*.c'
INIT_OBJS			= ${INIT_SRCS:S,${ROOT}/src/init,${BUILDDIR}/init,g:S,.c,.o,}

.PHONY: all clean kernel installkernel syscalls libc init

all: syscalls libc kernel init

kernel:
	mkdir -p ${MAKEOBJDIRPREFIX}
	${MAKE} -C ${FBSD_SRC} buildkernel KERNCONF=${KERNCONF}

installkernel:
	${MAKE} -C ${FBSD_SRC} installkernel KERNCONF=${KERNCONF} DESTDIR=${ROOTDIR}

${INCDIR}/sys/syscall.h: ${SYSCALLS_MASTER} ${SYSCALLS_CONF}
	${MAKE} -C ${FBSD_SRC} sysent
	mkdir -p ${INCDIR}/sys
	cp ${FBSD_SRC}/sys/sys/syscall.h ${INCDIR}/sys/syscall.h

syscalls: ${INCDIR}/sys/syscall.h

${CRT0_OBJ}: ${ROOT}/src/crt/crt0.s
	mkdir -p ${.TARGET:H}
	${AS} -o ${.TARGET} ${.ALLSRC}

${BUILDDIR}/libc/syscall.o: ${ROOT}/src/libc/syscall.s
	mkdir -p ${.TARGET:H}
	${AS} -o ${.TARGET} ${.ALLSRC}

.for src in ${LIBC_SRCS}
${BUILDDIR}/libc/${src:T:R}.o: ${src} ${INCDIR}/sys/syscall.h
	mkdir -p ${.TARGET:H}
	${CC} ${CFLAGS} -c ${src} -o ${.TARGET}
.endfor

${LIBC_A}: ${LIBC_OBJS}
	${AR} rcs ${.TARGET} ${.ALLSRC}

libc: ${LIBC_A}

.for src in ${INIT_SRCS}
${BUILDDIR}/init/${src:T:R}.o: ${src}
	mkdir -p ${.TARGET:H}
	${CC} ${CFLAGS} -c ${src} -o ${.TARGET}
.endfor

${ROOTDIR}/sbin/init: ${CRT0_OBJ} ${INIT_OBJS} ${LIBC_A}
	mkdir -p ${.TARGET:H}
	${LD} ${LDFLAGS} -o ${.TARGET} ${CRT0_OBJ} ${INIT_OBJS} -L${BUILDDIR} -lc

init: ${ROOTDIR}/sbin/init

clean:
	rm -rf ${BUILDDIR}
	rm -f ${ROOTDIR}
	rm -f ${ROOT}/include/sys/syscall.h