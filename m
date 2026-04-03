Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F8C27EFF7
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 04:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189874; cv=none; b=FCQvIv8x36mHTTxpJq3If5YLpIAkf5M1n8oxPLLoGZquEmEz1TpAzMxJJPF69/y+ACeNE/lf8lEjfEcbRS5dhiOOmlvGQpZDG4epa6HoKWzRmf15XgQrNXvGl8pZJx2/Bg42VTzQNfqUQYhNhEVCOkVPCLVFBbvBiq9XjfCB29M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189874; c=relaxed/simple;
	bh=tFf3lVc1wUpm6X9ApxmN9DDZ+LLpf4mr1EAo+Mcqrrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VP7W/5JCMRO09EloZnzX6emNZC8c0uc1xotrZnwzKxc7aOzJFiAFrdTIY65RVu+7lLrEtFFlSERP4xOk/pKRoNZ2VIckvJ8ZBKJLlB7ADCUEjqpMwF4K999hSc3OwPkKptkEzdI/rRQekgd2ClzSuOKO+7hgwb0N2/YCfdQhMvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZ6RflA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZ6RflA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4EFC4CEF7;
	Fri,  3 Apr 2026 04:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775189873;
	bh=tFf3lVc1wUpm6X9ApxmN9DDZ+LLpf4mr1EAo+Mcqrrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nZ6RflA13CN5udTv/tJ/o78NyKwnI7K2F73ETbg+uhBRJyVbieJUblBPdRstW4bME
	 68NqvgWzSOdxSumMftuei79Z8as2IgCLAq2HpWDzGnG3cd6a6HHBfV2SZF+uhissV4
	 GHe7dOqiZCHGDHKs/Q+rr8x2h8VbIHoET9rlD9QR/GFi1/Hl1UiV0KbxJHPsNbmYlw
	 AXGoRxegi3HrT8k3dHb607IQfxf0nUM7MDYBgjsymsxIIYqYcGHKsRd2StBpnkgPPp
	 IrgEiOEONBF1X/Pwaa0H2BixpbeGYKAVitokELqG2YgFIqnnCzC7AkEKw+xNUMSfRq
	 8mexdcQ4+Lmrg==
Date: Thu, 2 Apr 2026 21:17:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/3] libsupport: add a portable get_thread_id() function
Message-ID: <20260403041752.GE6254@frogsfrogsfrogs>
References: <20260403040328.2385083-1-tytso@mit.edu>
 <20260403040328.2385083-3-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403040328.2385083-3-tytso@mit.edu>

On Fri, Apr 03, 2026 at 12:03:27AM -0400, Theodore Ts'o wrote:
> The gettid() system call is only available on Linux.  So create a new
> function, get_thread_id() which implements a number of different ways
> of providing a thread id as an integer.
> 
> Use get_thread_id() instead of gettid() in fuse2fs.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  configure               | 12 ++++++++++++
>  configure.ac            |  2 ++
>  lib/config.h.in         |  6 ++++++
>  lib/support/Makefile.in | 13 +++++++++++--
>  lib/support/thread.c    | 36 ++++++++++++++++++++++++++++++++++++
>  lib/support/thread.h    |  5 +++++
>  misc/fuse2fs.c          |  3 ++-
>  7 files changed, 74 insertions(+), 3 deletions(-)
>  create mode 100644 lib/support/thread.c
>  create mode 100644 lib/support/thread.h
> 
> diff --git a/configure b/configure
> index b9a82dcec..b04b31aff 100755
> --- a/configure
> +++ b/configure
> @@ -13749,6 +13749,12 @@ if test "x$ac_cv_func_getrusage" = xyes
>  then :
>    printf "%s\n" "#define HAVE_GETRUSAGE 1" >>confdefs.h
>  
> +fi
> +ac_fn_c_check_func "$LINENO" "gettid" "ac_cv_func_gettid"
> +if test "x$ac_cv_func_gettid" = xyes
> +then :
> +  printf "%s\n" "#define HAVE_GETTID 1" >>confdefs.h
> +
>  fi
>  ac_fn_c_check_func "$LINENO" "jrand48" "ac_cv_func_jrand48"
>  if test "x$ac_cv_func_jrand48" = xyes
> @@ -13893,6 +13899,12 @@ if test "x$ac_cv_func_pthread_setname_np" = xyes
>  then :
>    printf "%s\n" "#define HAVE_PTHREAD_SETNAME_NP 1" >>confdefs.h
>  
> +fi
> +ac_fn_c_check_func "$LINENO" "pthread_threadid_np" "ac_cv_func_pthread_threadid_np"
> +if test "x$ac_cv_func_pthread_threadid_np" = xyes
> +then :
> +  printf "%s\n" "#define HAVE_PTHREAD_THREADID_NP 1" >>confdefs.h
> +
>  fi
>  ac_fn_c_check_func "$LINENO" "qsort_r" "ac_cv_func_qsort_r"
>  if test "x$ac_cv_func_qsort_r" = xyes
> diff --git a/configure.ac b/configure.ac
> index 2473879fd..4921f81f7 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -1246,6 +1246,7 @@ AC_CHECK_FUNCS(m4_flatten([
>  	getrandom
>  	getrlimit
>  	getrusage
> +	gettid
>  	jrand48
>  	keyctl
>  	llistxattr
> @@ -1270,6 +1271,7 @@ AC_CHECK_FUNCS(m4_flatten([
>  	pread64
>  	pwrite64
>  	pthread_setname_np
> +	pthread_threadid_np
>  	qsort_r
>  	secure_getenv
>  	setmntent
> diff --git a/lib/config.h.in b/lib/config.h.in
> index c6cbced5f..f129abfe7 100644
> --- a/lib/config.h.in
> +++ b/lib/config.h.in
> @@ -181,6 +181,9 @@
>  /* Define if the GNU gettext() function is already present or preinstalled. */
>  #undef HAVE_GETTEXT
>  
> +/* Define to 1 if you have the 'gettid' function. */
> +#undef HAVE_GETTID
> +
>  /* Define to 1 if you have the GNU-style 'qsort_r' function. */
>  #undef HAVE_GNU_QSORT_R
>  
> @@ -331,6 +334,9 @@
>  /* Define to 1 if you have the 'pthread_setname_np' function. */
>  #undef HAVE_PTHREAD_SETNAME_NP
>  
> +/* Define to 1 if you have the 'pthread_threadid_np' function. */
> +#undef HAVE_PTHREAD_THREADID_NP
> +
>  /* Define to 1 if you have the 'pwrite' function. */
>  #undef HAVE_PWRITE
>  
> diff --git a/lib/support/Makefile.in b/lib/support/Makefile.in
> index 6383816fd..9aac9cf00 100644
> --- a/lib/support/Makefile.in
> +++ b/lib/support/Makefile.in
> @@ -25,6 +25,7 @@ OBJS=		bthread.o \
>  		quotaio.o \
>  		quotaio_v2.o \
>  		quotaio_tree.o \
> +		thread.o \
>  		dict.o \
>  		devname.o
>  
> @@ -41,6 +42,7 @@ SRCS=		$(srcdir)/argv_parse.c \
>  		$(srcdir)/quotaio.c \
>  		$(srcdir)/quotaio_tree.c \
>  		$(srcdir)/quotaio_v2.c \
> +		$(srcdir)/thread.c \
>  		$(srcdir)/dict.c \
>  		$(srcdir)/devname.c
>  
> @@ -81,10 +83,15 @@ test_cstring: $(srcdir)/cstring.c
>  	$(Q) $(CC) -o test_cstring -DDEBUG_PROGRAM $(srcdir)/cstring.c \
>  		$(ALL_CFLAGS)
>  
> +test_thread: $(srcdir)/thread.c
> +	$(E) " CC $@"
> +	$(Q) $(CC) -o test_thread -DDEBUG_PROGRAM $(srcdir)/thread.c \
> +		$(ALL_CFLAGS)
> +
>  clean::
>  	$(RM) -f \#* *.s *.o *.a *~ *.bak core profiled/* \
>  		../libsupport.a ../libsupport_p.a $(SMANPAGES) \
> -		prof_err.c prof_err.h test_profile test_cstring
> +		prof_err.c prof_err.h test_profile test_cstring test_thread
>  
>  #fullcheck check:: tst_uuid
>  #	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_uuid
> @@ -111,7 +118,7 @@ $(OBJS):
>  argv_parse.o: $(srcdir)/argv_parse.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(srcdir)/argv_parse.h
>  bthread.o: $(srcdir)/bthread.c $(top_builddir)/lib/config.h \
> - $(srcdir)/bthread.h
> + $(top_builddir)/lib/dirpaths.h $(srcdir)/bthread.h
>  cstring.o: $(srcdir)/cstring.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(srcdir)/cstring.h
>  mkquota.o: $(srcdir)/mkquota.c $(top_builddir)/lib/config.h \
> @@ -183,6 +190,8 @@ quotaio_v2.o: $(srcdir)/quotaio_v2.c $(top_builddir)/lib/config.h \
>   $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/hashmap.h \
>   $(top_srcdir)/lib/ext2fs/bitops.h $(srcdir)/dqblk_v2.h \
>   $(srcdir)/quotaio_tree.h
> +thread.o: $(srcdir)/thread.c $(top_builddir)/lib/config.h \
> + $(top_builddir)/lib/dirpaths.h $(srcdir)/thread.h
>  dict.o: $(srcdir)/dict.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(srcdir)/dict.h
>  devname.o: $(srcdir)/devname.c $(top_builddir)/lib/config.h \
> diff --git a/lib/support/thread.c b/lib/support/thread.c
> new file mode 100644
> index 000000000..a9a10940c
> --- /dev/null
> +++ b/lib/support/thread.c
> @@ -0,0 +1,36 @@
> +/*
> + * thread.c - utility functions for Posix threads

Should these new files have an explicit license specification?

Other than that,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> + */
> +
> +#include "config.h"
> +#ifdef HAVE_PTHREAD
> +#include <pthread.h>
> +#endif
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +
> +#include "support/thread.h"
> +
> +uint64_t get_thread_id(void)
> +{
> +#if defined(HAVE_GETTID)
> +	return gettid();
> +#elif defined(HAVE_PTHREAD_THREADID_NP)
> +	uint64_t tid;
> +
> +	if (pthread_threadid_np(NULL, &tid))
> +		return tid;
> +#elif defined(HAVE_PTHREAD)
> +	return (__u64)(uintptr_t) pthread_self();
> +#endif
> +	return getpid();
> +}
> +
> +#ifdef DEBUG_PROGRAM
> +int main(int argc, char **argv)
> +{
> +	printf("Thread id: %llu\n", get_thread_id());
> +	return 0;
> +}
> +#endif
> diff --git a/lib/support/thread.h b/lib/support/thread.h
> new file mode 100644
> index 000000000..9a7f5c9db
> --- /dev/null
> +++ b/lib/support/thread.h
> @@ -0,0 +1,5 @@
> +/*
> + * thread.h -- header file for thread utilities
> + */
> +
> +uint64_t get_thread_id(void);
> diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
> index 0b43ec0fb..dfbc98636 100644
> --- a/misc/fuse2fs.c
> +++ b/misc/fuse2fs.c
> @@ -48,6 +48,7 @@
>  #include "ext2fs/ext2_fs.h"
>  #include "ext2fs/ext2fsP.h"
>  #include "support/bthread.h"
> +#include "support/thread.h"
>  #if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 0)
>  # define FUSE_PLATFORM_OPTS	""
>  #else
> @@ -148,7 +149,7 @@ static inline uint64_t round_down(uint64_t b, unsigned int align)
>  
>  #define dbg_printf(fuse2fs, format, ...) \
>  	while ((fuse2fs)->debug) { \
> -		printf("FUSE2FS (%s): tid=%d " format, (fuse2fs)->shortdev, gettid(), ##__VA_ARGS__); \
> +		printf("FUSE2FS (%s): tid=%llu " format, (fuse2fs)->shortdev, get_thread_id(), ##__VA_ARGS__); \
>  		fflush(stdout); \
>  		break; \
>  	}
> -- 
> 2.51.0
> 
