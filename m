From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/8] xfstests: Move fallocate include into global.h
Date: Fri, 28 Feb 2014 11:17:41 -0600
Message-ID: <5310C4B5.9010901@sandeen.net>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com> <1393603865-26198-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49069 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbaB1RRn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Feb 2014 12:17:43 -0500
In-Reply-To: <1393603865-26198-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/28/14, 10:11 AM, Lukas Czerner wrote:
> Move the inclusion of falloc.h with all it's possible defines for the
> fallocate mode into global.h header file so we do not have to include
> and define it manually in every tool using fallocate.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I like the direction, but I think this changes behavior a little bit.

#ifdef FALLOCATE came from an autoconf macro:

AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
  [ AC_MSG_CHECKING([for fallocate])
    AC_TRY_LINK([
#define _GNU_SOURCE
#define _FILE_OFFSET_BITS 64
#include <fcntl.h>
#include <linux/falloc.h> ],
      [ fallocate(0, 0, 0, 0); ],
      [ have_fallocate=true; AC_MSG_RESULT(yes) ],
      [ have_fallocate=false; AC_MSG_RESULT(no) ])
    AC_SUBST(have_fallocate)
  ])

(at least I think so?) and so #ifdef FALLOCATE meant that
an fallocate syscall actually exists.  With your changes,
the test is now whether the fallocate *header* exists.

falloc.h is part of kernel-headers, not glibc.  So it's
possible that there's a divergence between the two.

I think it's probably ok.  Build-time checks should
determine whether we are able to _build_ and yours do that.
Each caller of fallocate (or each test using it) then probably
needs to ensure that the functionality it wants is actually
available at runtime and handle it if not.

So I'll give this a 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

but maybe the above rambling will ring alarm bells for
someone else... ;)

-Eric

> ---
>  configure.ac   |  3 ++-
>  ltp/fsstress.c | 11 ++---------
>  ltp/fsx.c      | 11 ++++-------
>  src/global.h   | 25 +++++++++++++++++++++++++
>  4 files changed, 33 insertions(+), 17 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 6fba3ad..2f95c4c 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -25,7 +25,8 @@ AC_HEADER_STDC
>  			sys/wait.h		\
>  			sys/types.h		\
>  			strings.h		\
> -			err.h
> +			err.h			\
> +			linux/falloc.h
>      ])
>      AC_CHECK_HEADERS([	sys/fs/xfs_fsops.h	\
>  			sys/fs/xfs_itable.h	\
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index c56f168..7dec7c6 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -27,13 +27,6 @@
>  #ifdef HAVE_LINUX_FIEMAP_H
>  #include <linux/fiemap.h>
>  #endif
> -#ifdef FALLOCATE
> -#include <linux/falloc.h>
> -#ifndef FALLOC_FL_PUNCH_HOLE
> -/* Copy-paste from linux/falloc.h */
> -#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
> -#endif
> -#endif
>  #ifndef HAVE_ATTR_LIST
>  #define attr_list(path, buf, size, flags, cursor) (errno = -ENOSYS, -1)
>  #endif
> @@ -2085,7 +2078,7 @@ dwrite_f(int opno, long r)
>  void
>  fallocate_f(int opno, long r)
>  {
> -#ifdef FALLOCATE
> +#ifdef HAVE_LINUX_FALLOC_H
>  	int		e;
>  	pathname_t	f;
>  	int		fd;
> @@ -2507,7 +2500,7 @@ mknod_f(int opno, long r)
>  void
>  punch_f(int opno, long r)
>  {
> -#ifdef FALLOCATE
> +#ifdef HAVE_LINUX_FALLOC_H
>  	int		e;
>  	pathname_t	f;
>  	int		fd;
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 2f1e3e8..c36a038 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -33,9 +33,6 @@
>  #ifdef AIO
>  #include <libaio.h>
>  #endif
> -#ifdef FALLOCATE
> -#include <linux/falloc.h>
> -#endif
>  
>  #ifndef MAP_FILE
>  # define MAP_FILE 0
> @@ -882,7 +879,7 @@ do_punch_hole(unsigned offset, unsigned length)
>  }
>  #endif
>  
> -#ifdef FALLOCATE
> +#ifdef HAVE_LINUX_FALLOC_H
>  /* fallocate is basically a no-op unless extending, then a lot like a truncate */
>  void
>  do_preallocate(unsigned offset, unsigned length)
> @@ -1139,7 +1136,7 @@ usage(void)
>  "	-A: Use the AIO system calls\n"
>  #endif
>  "	-D startingop: debug output starting at specified operation\n"
> -#ifdef FALLOCATE
> +#ifdef HAVE_LINUX_FALLOC_H
>  "	-F: Do not use fallocate (preallocation) calls\n"
>  #endif
>  #ifdef FALLOC_FL_PUNCH_HOLE
> @@ -1296,7 +1293,7 @@ int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
>  void
>  test_fallocate()
>  {
> -#ifdef FALLOCATE
> +#ifdef HAVE_LINUX_FALLOC_H
>  	if (!lite && fallocate_calls) {
>  		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
>  			if(!quiet)
> @@ -1306,7 +1303,7 @@ test_fallocate()
>  			ftruncate(fd, 0);
>  		}
>  	}
> -#else /* ! FALLOCATE */
> +#else /* ! HAVE_LINUX_FALLOC_H */
>  	fallocate_calls = 0;
>  #endif
>  
> diff --git a/src/global.h b/src/global.h
> index e6a2c2b..8180f66 100644
> --- a/src/global.h
> +++ b/src/global.h
> @@ -149,4 +149,29 @@
>  #include <sys/param.h>
>  #endif
>  
> +#ifdef HAVE_LINUX_FALLOC_H
> +#include <linux/falloc.h>
> +
> +#ifndef FALLOC_FL_KEEP_SIZE
> +#define FALLOC_FL_KEEP_SIZE		0x01
> +#endif
> +
> +#ifndef FALLOC_FL_PUNCH_HOLE
> +#define FALLOC_FL_PUNCH_HOLE		0x02
>  #endif
> +
> +#ifndef FALLOC_FL_NO_HIDE_STALE
> +#define FALLOC_FL_NO_HIDE_STALE		0x04
> +#endif
> +
> +#ifndef FALLOC_FL_COLLAPSE_RANGE
> +#define FALLOC_FL_COLLAPSE_RANGE	0x08
> +#endif
> +
> +#ifndef FALLOC_FL_ZERO_RANGE
> +#define FALLOC_FL_ZERO_RANGE		0x10
> +#endif
> +
> +#endif /* HAVE_LINUX_FALLOC_H */
> +
> +#endif /* GLOBAL_H */
> 

