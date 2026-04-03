Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CF217BED0
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 04:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189785; cv=none; b=aQAnV2nGNa8O24RNeSfmyoPG6ClismU09woXqri8mEBVEOjiOwG2etwEIxX0k2BqO/BQbnzINeXDfDhsMFWfnSS2GHLyGILQN4tp25o+xWR2JK9RpGztBD+3kCsTACyNwqANwBSDDE4tHCw6wNttWpU6TQkq3GBcgVvRpTKgcWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189785; c=relaxed/simple;
	bh=/mxbgsE/Cdir0ic3oO8lsLtCRg/wt/4OuQTA0pV10pY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMXpXS6eiMHud9UlabPIIMFsRZpSfycIv3Q/ZoDzensCa2iqdjH1GBFPQInPXU4S/t45fW1wSZHkrFgK7XjWYv7ULchvIQkfzuY+KNWCg5PPChhMkhZFokNrdUHqnpxPn5G9hmbEVN1W1mLel0JpeiwqOJa1rqrGiNp34h987MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fxPks6/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxPks6/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10297C4CEF7;
	Fri,  3 Apr 2026 04:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775189785;
	bh=/mxbgsE/Cdir0ic3oO8lsLtCRg/wt/4OuQTA0pV10pY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fxPks6/xuGqpN7m8UXxfikotPKYpq0vasK1dQPQaRuldRvyMdRLdBpw5NzAPS1u+l
	 5FfLz4g4XyJI71imTPDjdGq95B/D7DAKoSE41Skr6zTrvev1TVXkHQY3BPz+VMNZqA
	 W94hbopFWmA3CsjuXIlr0yG2FpbIP5PRuBXgZvRve1MxvQVqkx5zfSFQ9WPQA69AND
	 MWe+SE9srXQ/ni/WOzyV1/oa97JmHaKylh2owflkNF3sJopyWCK6zz2VuYakv8r5+o
	 el62CO2c7/h0MD2rB4Wr4vhFSRt5svsvKJ+6XrB/SxJYk/kjMCoS36Hv7/4Nt4zz7F
	 Y7wwOlvQ9di0w==
Date: Thu, 2 Apr 2026 21:16:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/3] libsupport: fix portability issues with the bthread.c
Message-ID: <20260403041624.GD6254@frogsfrogsfrogs>
References: <20260403040328.2385083-1-tytso@mit.edu>
 <20260403040328.2385083-2-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403040328.2385083-2-tytso@mit.edu>

On Fri, Apr 03, 2026 at 12:03:26AM -0400, Theodore Ts'o wrote:
> The function pthread_setname_np() is non-portable; that's what the
> "np" means.  In particular, on Mac systems, the function takes only a
> single argument, while on most other systems which have the function,
> it takes two arguments.
> 
> Also fix a problem where a 1-bit signed integer can only accept values
> of 0 or -1.  Change it to be a 1-bit unsigned integer, which can
> accept values of 0 or 1.  Clang will issue a warning if 1-bit signed
> integer are used incorrectly, and fail with -Werror.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  configure             |  6 ++++++
>  configure.ac          |  1 +
>  lib/config.h.in       | 24 +++++++++++++++---------
>  lib/support/bthread.c | 12 ++++++++++--
>  4 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/configure b/configure
> index 4da5439fe..b9a82dcec 100755
> --- a/configure
> +++ b/configure
> @@ -13887,6 +13887,12 @@ if test "x$ac_cv_func_pwrite64" = xyes
>  then :
>    printf "%s\n" "#define HAVE_PWRITE64 1" >>confdefs.h
>  
> +fi
> +ac_fn_c_check_func "$LINENO" "pthread_setname_np" "ac_cv_func_pthread_setname_np"
> +if test "x$ac_cv_func_pthread_setname_np" = xyes
> +then :
> +  printf "%s\n" "#define HAVE_PTHREAD_SETNAME_NP 1" >>confdefs.h
> +
>  fi
>  ac_fn_c_check_func "$LINENO" "qsort_r" "ac_cv_func_qsort_r"
>  if test "x$ac_cv_func_qsort_r" = xyes
> diff --git a/configure.ac b/configure.ac
> index ecef9df39..2473879fd 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -1269,6 +1269,7 @@ AC_CHECK_FUNCS(m4_flatten([
>  	pwrite
>  	pread64
>  	pwrite64
> +	pthread_setname_np
>  	qsort_r
>  	secure_getenv
>  	setmntent
> diff --git a/lib/config.h.in b/lib/config.h.in
> index 8ea7ec2b1..c6cbced5f 100644
> --- a/lib/config.h.in
> +++ b/lib/config.h.in
> @@ -46,9 +46,6 @@
>  /* Define to the version of FUSE to use */
>  #undef FUSE_USE_VERSION
>  
> -/* Define to 1 if fuse supports cache_readdir */
> -#undef HAVE_FUSE_CACHE_READDIR

Huh, there's a lot of churn in this file.  Do you have a magic script
somewhere that regenerates config.h.in?

I don't see any problems with this file's changes, but I could also not
scatter junk everywhere :)

> -
>  /* Define to 1 if you have the 'add_key' function. */
>  #undef HAVE_ADD_KEY
>  
> @@ -73,9 +70,6 @@
>  /* Define to 1 if you have the BSD-style 'qsort_r' function. */
>  #undef HAVE_BSD_QSORT_R
>  
> -/* Define to 1 if PR_SET_IO_FLUSHER is present */
> -#undef HAVE_PR_SET_IO_FLUSHER
> -
>  /* Define to 1 if you have the Mac OS X function
>     CFLocaleCopyPreferredLanguages in the CoreFoundation framework. */
>  #undef HAVE_CFLOCALECOPYPREFERREDLANGUAGES
> @@ -87,6 +81,9 @@
>  /* Define to 1 if you have the 'chflags' function. */
>  #undef HAVE_CHFLAGS
>  
> +/* Define to 1 if CLOCK_MONOTONIC is present */
> +#undef HAVE_CLOCK_MONOTONIC
> +
>  /* Define if the GNU dcgettext() function is already present or preinstalled.
>     */
>  #undef HAVE_DCGETTEXT
> @@ -136,9 +133,15 @@
>  /* Define to 1 if you have the 'fsync' function. */
>  #undef HAVE_FSYNC
>  
> +/* Define to 1 if FS_IOC_READ_VERITY_METADATA ioctl is available */
> +#undef HAVE_FS_IOC_READ_VERITY_METADATA
> +
>  /* Define to 1 if you have the 'ftruncate64' function. */
>  #undef HAVE_FTRUNCATE64
>  
> +/* Define to 1 if fuse supports cache_readdir */
> +#undef HAVE_FUSE_CACHE_READDIR
> +
>  /* Define to 1 if you have the <fuse.h> header file. */
>  #undef HAVE_FUSE_H
>  
> @@ -313,6 +316,9 @@
>  /* Define to 1 if you have the 'pread64' function. */
>  #undef HAVE_PREAD64
>  
> +/* Define to 1 if PR_SET_IO_FLUSHER is present */
> +#undef HAVE_PR_SET_IO_FLUSHER
> +
>  /* Define if you have POSIX threads libraries and header files. */
>  #undef HAVE_PTHREAD
>  
> @@ -322,6 +328,9 @@
>  /* Have PTHREAD_PRIO_INHERIT. */
>  #undef HAVE_PTHREAD_PRIO_INHERIT
>  
> +/* Define to 1 if you have the 'pthread_setname_np' function. */
> +#undef HAVE_PTHREAD_SETNAME_NP
> +
>  /* Define to 1 if you have the 'pwrite' function. */
>  #undef HAVE_PWRITE
>  
> @@ -699,7 +708,4 @@
>  /* Define to 1 on platforms where this makes time_t a 64-bit type. */
>  #undef __MINGW_USE_VC2005_COMPAT
>  
> -/* Define to 1 if CLOCK_MONOTONIC is present */
> -#undef HAVE_CLOCK_MONOTONIC
> -
>  #include <dirpaths.h>
> diff --git a/lib/support/bthread.c b/lib/support/bthread.c
> index 936ca0f0f..87eeb1b3d 100644
> --- a/lib/support/bthread.c
> +++ b/lib/support/bthread.c
> @@ -9,6 +9,7 @@
>   * %End-Header%
>   */
>  #include "config.h"
> +#ifdef HAVE_PTHREAD

Hmmm if we don't have pthreads, then shouldn't bthread.h also exclude
all the function declarations ifndef HAVE_PTHREAD?

>  #include <stdlib.h>
>  #include <errno.h>
>  #include <pthread.h>
> @@ -33,7 +34,7 @@ struct bthread {
>  	bthread_fn_t fn;
>  	void *data;
>  	unsigned int period; /* seconds */
> -	int can_join:1;
> +	unsigned int can_join:1;

That works, though I suppose you could change it to bool.

--D

>  };
>  
>  /* Wait for a signal or for the periodic interval */
> @@ -101,7 +102,13 @@ int bthread_create(const char *name,  bthread_fn_t fn, void *data,
>  	if (error)
>  		goto out_cond;
>  
> +#ifdef HAVE_PTHREAD_SETNAME_NP
> +#ifdef __APPLE__
> +	pthread_setname_np(name);
> +#else
>  	pthread_setname_np(bt->thread, name);
> +#endif
> +#endif
>  
>  	*btp = bt;
>  	return 0;
> @@ -178,7 +185,7 @@ int bthread_cancel(struct bthread *bt)
>  /* Ask the thread to cancel itself and wait for it */
>  void bthread_stop(struct bthread *bt)
>  {
> -	int need_join = 0;
> +	unsigned int need_join = 0;
>  
>  	pthread_mutex_lock(&bt->lock);
>  	switch (bt->state) {
> @@ -199,3 +206,4 @@ void bthread_stop(struct bthread *bt)
>  	if (need_join)
>  		pthread_join(bt->thread, NULL);
>  }
> +#endif /* HAVE_PTHREAD */
> -- 
> 2.51.0
> 
