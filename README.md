
# RocketOS (rkos)

## A free OS that is based off of the FreeBSD kernel.

Author: rocketLover11

## Build Instructions

### Prerequisites

Before building please note that the build is expected to be done from a FreeBSD environment, however you may be able to build on other versions of BSD.

### Dependencies

 - `bmake` - Build system (invoked as `make` on BSD)
 - `clang` - C Compiler
 - `as` - Assembler
 - `ld` - Linker
 - `ar` - Archiver
 - `flua` - Needed to generate libc syscall.h
 - `git` - Needed to clone the repository

### Clone Repository

```sh
git clone https://github.com/rocketLover11/rkos.git
cd rkos
git submodule update --init --recursive
```

### Build the OS

```sh
make -j$(sysctl -n hw.ncpu)
./tools/make-image.sh
```

## Features

 - Simple to use
 - Doesn't depend on third party code other than the kernel

## License

This project's own code (libc, init, build system) is licensed under BSD 2-Clause license - see [LICENSE.txt](LICENSE.txt).

The FreeBSD kernel source (`src/freebsd-src`, tracked as a submodule) is separate upstream code under its own BSD 2-Clause license - see [FreeBSD's license](https://cgit.FreeBSD.org/src/tree/COPYRIGHT).