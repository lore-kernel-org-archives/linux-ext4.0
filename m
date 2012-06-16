From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Minimal configuration for e2fsprogs
Date: Fri, 15 Jun 2012 20:08:25 -0400
Message-ID: <20120616000825.GE7363@thunk.org>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50811 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab2FPAI3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jun 2012 20:08:29 -0400
Content-Disposition: inline
In-Reply-To: <20120615042421.GA7021@thor.bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 15, 2012 at 02:24:21PM +1000, Tony Breeds wrote:
> 	I appologise if this is not the correct place to discuss this,
> or if it's been discussed before.  In either event please point me in
> the right direction and I'll move along.
> 
> I'm the maintainer for yaboot a bootloader for powerpc systems.  We link
> against libext2fs.a, but as we're a bootloader we do NOT link against
> libc as such we need to implement a number of "stub" functions to keep
> up with the newer features being added here.

So I think you need to break your list a bit more.  There are a number
of functions on this list where, if yaboot doesn't actually call a
particular function (for example, the progess bar functions, in
lib/ext2fs/progress.c), the fact that they reference the stdio
functions won't matter.  Something similar will be going on with
test_io.c; if you don't use those functions, you won't need to provide
stubs for any of the libc functions called by them.

There are some cases where we may need to create some configure
options.  For example, there are a large number of the symbols that
you have listed that got dragged in by the lib/ext2fs/mmp.c.  That's
one where it may be simplest to add a set of #ifdef's that comment out
multi-mount protection --- I assume you don't plan to support booting
over fibre channel where you might need to care about having two
systems trying to modify the same file system at the same time.  :-)

Which brings up another point --- are you only planning on opening the
file system read-only, or do you expect to modify the file system from
yaboot?  If you don't need to modify the file system, and so you don't
need to load the bitmap manipulation functions, that will make a whole
bunch more of the libc dependencies drop out.

So the bottom line is yes, I think we can do somethings to help you;
but depending on which parts of the libext2fs functionality yaboot
actually needs, it may not be as bad as you think, especially if you
are willing to limit which libext2fs functions you call.

Regards,

						- Ted

> 
> Our current set looks like:
> ---
> int printf(const char *format, ...);
> int fprintf(FILE *stream, const char *format, ...);
> int fputs(const char *s, FILE *stream);
> int fflush(FILE *stream);
> char *getenv(const char *name);
> int gethostname(char *name, size_t len);
> int gettimeofday(struct timeval *tv, struct timezone *tz);
> int * __errno_location(void);
> unsigned int sleep(unsigned int seconds);
> int rand(void);
> void srand(unsigned int seed);
> long int random(void);
> void srandom(unsigned int seed);
> uid_t geteuid(void);
> uid_t getuid(void);
> pid_t getpid(void);
> int stat(const char *path, struct stat *buf);
> int stat64(const char *path, struct stat *buf);
> int fstat(int fd, struct stat *buf);
> int fstat64(int fd, struct stat *buf);
> int open(const char *pathname, int flags, mode_t mode);
> int open64(const char *pathname, int flags, mode_t mode);
> off_t lseek(int fd, off_t offset, int whence);
> off64_t lseek64(int fd, off64_t offset, int whence);
> ssize_t read(int fildes, void *buf, size_t nbyte);
> int close(int fd);
> void *calloc(size_t nmemb, size_t size);
> void perror(const char *s);
> void exit(int status);
> int ioctl(int d, int request, ...);
> size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
> long sysconf(int name);
> int getpagesize(void);
> void qsort(void *base, size_t nmemb, size_t size,
>            int(*compar)(const void *, const void *));
> ---
> 
> Plus a few typdefs and #defines.
> 
> It looks to me (with only a quick look) that a lot of these libc
> functions are used for nice error messages to the end user.
> 
> So my question is essentially twofold.
> 1) Is there a "good" way to ./configure e2fsprogs to build a really
> minimal libext2fs.a ?
> 2) If not can I get some pointers adding a --really-minimal autoconf
> argument to pretty much do what I need.
> 
> Of course getting e2fsprogs to support this minimal build is only the
> first step I then need to convince the distros to package it.
> 
> I did consider, cp'ing the code into yaboot but that seems pretty gross
> and would end up breaching the Fedora Packaging Guidelines.
> 
> Any advice gladly accepted.
> 
> Yours Tony


