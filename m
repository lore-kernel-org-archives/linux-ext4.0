From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Minimal configuration for e2fsprogs
Date: Fri, 15 Jun 2012 14:24:21 +1000
Message-ID: <20120615042421.GA7021@thor.bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:42798 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab2FOEYa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jun 2012 00:24:30 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi All,
	I appologise if this is not the correct place to discuss this,
or if it's been discussed before.  In either event please point me in
the right direction and I'll move along.

I'm the maintainer for yaboot a bootloader for powerpc systems.  We link
against libext2fs.a, but as we're a bootloader we do NOT link against
libc as such we need to implement a number of "stub" functions to keep
up with the newer features being added here.

Our current set looks like:
---
int printf(const char *format, ...);
int fprintf(FILE *stream, const char *format, ...);
int fputs(const char *s, FILE *stream);
int fflush(FILE *stream);
char *getenv(const char *name);
int gethostname(char *name, size_t len);
int gettimeofday(struct timeval *tv, struct timezone *tz);
int * __errno_location(void);
unsigned int sleep(unsigned int seconds);
int rand(void);
void srand(unsigned int seed);
long int random(void);
void srandom(unsigned int seed);
uid_t geteuid(void);
uid_t getuid(void);
pid_t getpid(void);
int stat(const char *path, struct stat *buf);
int stat64(const char *path, struct stat *buf);
int fstat(int fd, struct stat *buf);
int fstat64(int fd, struct stat *buf);
int open(const char *pathname, int flags, mode_t mode);
int open64(const char *pathname, int flags, mode_t mode);
off_t lseek(int fd, off_t offset, int whence);
off64_t lseek64(int fd, off64_t offset, int whence);
ssize_t read(int fildes, void *buf, size_t nbyte);
int close(int fd);
void *calloc(size_t nmemb, size_t size);
void perror(const char *s);
void exit(int status);
int ioctl(int d, int request, ...);
size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
long sysconf(int name);
int getpagesize(void);
void qsort(void *base, size_t nmemb, size_t size,
           int(*compar)(const void *, const void *));
---

Plus a few typdefs and #defines.

It looks to me (with only a quick look) that a lot of these libc
functions are used for nice error messages to the end user.

So my question is essentially twofold.
1) Is there a "good" way to ./configure e2fsprogs to build a really
minimal libext2fs.a ?
2) If not can I get some pointers adding a --really-minimal autoconf
argument to pretty much do what I need.

Of course getting e2fsprogs to support this minimal build is only the
first step I then need to convince the distros to package it.

I did consider, cp'ing the code into yaboot but that seems pretty gross
and would end up breaching the Fedora Packaging Guidelines.

Any advice gladly accepted.

Yours Tony

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP2rj1AAoJEEsCiJRY75GKpYkP/iKxIi6Rt/2Z5MogObTENmvt
rmc42jUiwvVke92xN2UDiG5o+q8hYlaxgxqJqVIwXVHRrIFbPiRKkRVpTLkcD5qn
RiTvw22INv6Env3MH1TUT2pWprpZiIyzfnHsR3RGhwDKJr2C+jvNEGCy6wwx0lCw
DFSwlMTRLk6nHkiI0VbI3HtxUsLeMCu+22oSu22NjAvyIkj9O5fO5PasFVh5wf6L
SglgzHAFT+VtQzlVZYNkJF6lo7f/xvoTOXKRzutXvSGL5GuZv0KadN+DXARKwY58
SxUULh26Ltz2Mgoylp2/jQlvmGIQxu8NTjVsWA2ZzP5JiwowF/DPsxcQ8LTIP0Zf
IV/VMbq3FsdqXGe/wVVSvndO1K+4jRJjY29uIVCDGsYOrdItRqQLGkMVlQooYoQ8
Aox85CzygbDvSig0An8Gg3rpwHl5zHSBjv03+KLmJo6st2ij1w+SrnyzgelLPj9n
Lx6MJaf2GpyUOa69FTQzS29lvG9YIRD+oFRnyaivcPTEldGbvcGOmzA8/gV16gmX
rT2grDvISLf3O4TKfdGSPK11q0RFBed8YWd4oGifgrHmY45ONmjWlQI93a6K1Kgw
1tDasDwIpzjIqWVeGkHPNShxP/Yk8sa8zvTFpSaCmaUMgR3hRls9aymvqyZ/tANU
SfbNFkvLNIHqL06jQHVe
=lwqF
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
