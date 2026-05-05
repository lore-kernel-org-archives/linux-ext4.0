Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E160118D636
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 00:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777939879; cv=none; b=VmD5h17y+skJgjio3S6rUqIV4Hvh8/+7mEzOHzPAbLGRid82vg5i6mehk5Y08PyTg8yuVKJR2z+tymdH+qVw+P4gJABwOtZ4SJxyLfLu4OFbOrc8UTnKzgSY909xfokmYFzlNEFT7qLn/xODOIHc3rVsp4wnJSQyzb9AycF2kLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777939879; c=relaxed/simple;
	bh=c2L9O+9HZWtOsM5r4zjnKnlRITt9/mSKBPF3khSrXsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kCalgs8rupi0hFj4WU45Fn+mejfYKgAXetvVa6BjT3MBBiJU7H2s3zIKvOqaIMYGhsW47gCYpWO98Ai1dn42Qv0wxP6NEXUKVacQN+EXxGKbRgjUt3kJ/3xQ6kCl/hOiopgo68Pu8fyJzAsST/6II1h5y5fw+gMOErflPLcROyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZaL4r/sW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaL4r/sW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EC3C2BCB8;
	Tue,  5 May 2026 00:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777939878;
	bh=c2L9O+9HZWtOsM5r4zjnKnlRITt9/mSKBPF3khSrXsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZaL4r/sWeNR4Dzuz36FOdhpX9IwTG6WnC0YVFJMGn+UL1Hr72k85R5TZ7N8fLqprW
	 ED44CV13Qvj+GTWVvNda/QOZ90RhsUPnt7czS0uLFEH/x3I16Jq0XXyYMqA1o4I50T
	 2uQDioO+/Kv2eSEzFJJsH/znhOi+yH9BbKqWeshwuIlkRSSTpn/hhYsVIFJ7sDKWKm
	 KGJmSLN/nm6MVTZLDywXGZeKs6AwARbaerNYrKnv1qU3uxQqtLO75qvJz32Cjfnf6J
	 a9AmUjpmJWHikJuli9PSL3eYD4rWHb2BzJLRukkEP4To2Whmu4LZIODd7lSluA2UoT
	 zEcXud2/5XIrA==
Date: Mon, 4 May 2026 17:11:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/7] libsupport: drop xbitops.h and define fls() if
 necessary
Message-ID: <20260505001117.GB1101423@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260504233301.2345652-2-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504233301.2345652-2-tytso@mit.edu>

On Mon, May 04, 2026 at 07:32:55PM -0400, Theodore Ts'o wrote:
> The new cache.c file doesn't actually need most of the functions in
> xbitops.h.  It only needs fls(), and on some systems, like MacOS and
> *BSD systems, fls() is defined already.  The other functions in
> xbitops.h are massively non-portable and break on non-Linux systems,
> especially MacOS.
> 
> So define fls() if it's needed (on Linux), and drop xbitops.h.
> 
> Fixes: 30b3c80ed6bc ("libsupport: add a cache")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Works for me; in the end I didn't use it as many places as I thought I
was going to.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  configure               |   6 ++
>  configure.ac            |   1 +
>  fuse4fs/Makefile.in     |  18 +++---
>  lib/config.h.in         |   3 +
>  lib/support/Makefile.in |   2 +-
>  lib/support/cache.c     |  33 ++++++++++-
>  lib/support/xbitops.h   | 128 ----------------------------------------
>  7 files changed, 51 insertions(+), 140 deletions(-)
>  delete mode 100644 lib/support/xbitops.h
> 
> diff --git a/configure b/configure
> index a97794121..a1a270e63 100755
> --- a/configure
> +++ b/configure
> @@ -13677,6 +13677,12 @@ if test "x$ac_cv_func_fdatasync" = xyes
>  then :
>    printf "%s\n" "#define HAVE_FDATASYNC 1" >>confdefs.h
>  
> +fi
> +ac_fn_c_check_func "$LINENO" "fls" "ac_cv_func_fls"
> +if test "x$ac_cv_func_fls" = xyes
> +then :
> +  printf "%s\n" "#define HAVE_FLS 1" >>confdefs.h
> +
>  fi
>  ac_fn_c_check_func "$LINENO" "fstat64" "ac_cv_func_fstat64"
>  if test "x$ac_cv_func_fstat64" = xyes
> diff --git a/configure.ac b/configure.ac
> index b62553e3d..abce79594 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -1233,6 +1233,7 @@ AC_CHECK_FUNCS(m4_flatten([
>  	fchown
>  	fcntl
>  	fdatasync
> +	fls
>  	fstat64
>  	fsync
>  	ftruncate64
> diff --git a/fuse4fs/Makefile.in b/fuse4fs/Makefile.in
> index 9f3547c27..cecee2b25 100644
> --- a/fuse4fs/Makefile.in
> +++ b/fuse4fs/Makefile.in
> @@ -134,7 +134,7 @@ distclean: clean
>  	$(RM) -f .depend Makefile $(srcdir)/TAGS $(srcdir)/Makefile.in.old
>  
>  # +++ Dependency line eater +++
> -#
> +# 
>  # Makefile dependencies follow.  This must be the last section in
>  # the Makefile.in file
>  #
> @@ -145,9 +145,10 @@ fuse4fs.o: $(srcdir)/fuse4fs.c $(top_builddir)/lib/config.h \
>   $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
>   $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/hashmap.h \
>   $(top_srcdir)/lib/ext2fs/bitops.h $(top_srcdir)/lib/ext2fs/ext2fsP.h \
> - $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/version.h \
> - $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/support/cache.h \
> - $(top_srcdir)/lib/support/list.h $(top_srcdir)/lib/support/xbitops.h
> + $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/support/bthread.h \
> + $(top_srcdir)/lib/support/thread.h $(top_srcdir)/lib/support/list.h \
> + $(top_srcdir)/lib/support/cache.h $(top_srcdir)/version.h \
> + $(top_srcdir)/lib/e2p/e2p.h
>  journal.o: $(srcdir)/../debugfs/journal.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(srcdir)/../debugfs/journal.h \
>   $(top_srcdir)/e2fsck/jfs_user.h $(top_srcdir)/e2fsck/e2fsck.h \
> @@ -161,8 +162,7 @@ journal.o: $(srcdir)/../debugfs/journal.c $(top_builddir)/lib/config.h \
>   $(top_srcdir)/lib/support/dqblk_v2.h \
>   $(top_srcdir)/lib/support/quotaio_tree.h \
>   $(top_srcdir)/lib/ext2fs/fast_commit.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
> - $(top_srcdir)/lib/support/list.h $(top_srcdir)/lib/ext2fs/compiler.h \
> - $(top_srcdir)/lib/ext2fs/kernel-jbd.h
> + $(top_srcdir)/lib/support/list.h $(top_srcdir)/lib/ext2fs/kernel-jbd.h
>  revoke.o: $(srcdir)/../e2fsck/revoke.c $(srcdir)/../e2fsck/jfs_user.h \
>   $(top_builddir)/lib/config.h $(top_builddir)/lib/dirpaths.h \
>   $(srcdir)/../e2fsck/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
> @@ -175,8 +175,7 @@ revoke.o: $(srcdir)/../e2fsck/revoke.c $(srcdir)/../e2fsck/jfs_user.h \
>   $(top_srcdir)/lib/support/dqblk_v2.h \
>   $(top_srcdir)/lib/support/quotaio_tree.h \
>   $(top_srcdir)/lib/ext2fs/fast_commit.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
> - $(top_srcdir)/lib/support/list.h $(top_srcdir)/lib/ext2fs/compiler.h \
> - $(top_srcdir)/lib/ext2fs/kernel-jbd.h
> + $(top_srcdir)/lib/support/list.h $(top_srcdir)/lib/ext2fs/kernel-jbd.h
>  recovery.o: $(srcdir)/../e2fsck/recovery.c $(srcdir)/../e2fsck/jfs_user.h \
>   $(top_builddir)/lib/config.h $(top_builddir)/lib/dirpaths.h \
>   $(srcdir)/../e2fsck/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
> @@ -189,5 +188,4 @@ recovery.o: $(srcdir)/../e2fsck/recovery.c $(srcdir)/../e2fsck/jfs_user.h \
>   $(top_srcdir)/lib/support/dqblk_v2.h \
>   $(top_srcdir)/lib/support/quotaio_tree.h \
>   $(top_srcdir)/lib/ext2fs/fast_commit.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
> - $(top_srcdir)/lib/support/list.h $(top_srcdir)/lib/ext2fs/compiler.h \
> - $(top_srcdir)/lib/ext2fs/kernel-jbd.h
> + $(top_srcdir)/lib/support/list.h $(top_srcdir)/lib/ext2fs/kernel-jbd.h
> diff --git a/lib/config.h.in b/lib/config.h.in
> index fd2520396..abba5e2c6 100644
> --- a/lib/config.h.in
> +++ b/lib/config.h.in
> @@ -124,6 +124,9 @@
>  /* Define to 1 if you have the 'fdatasync' function. */
>  #undef HAVE_FDATASYNC
>  
> +/* Define to 1 if you have the 'fls' function. */
> +#undef HAVE_FLS
> +
>  /* Define to 1 if fsmap_sizeof() is declared in linux/fsmap.h */
>  #undef HAVE_FSMAP_SIZEOF
>  
> diff --git a/lib/support/Makefile.in b/lib/support/Makefile.in
> index 6ff1c81d0..d20d6a984 100644
> --- a/lib/support/Makefile.in
> +++ b/lib/support/Makefile.in
> @@ -199,4 +199,4 @@ dict.o: $(srcdir)/dict.c $(top_builddir)/lib/config.h \
>  devname.o: $(srcdir)/devname.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(srcdir)/devname.h $(srcdir)/nls-enable.h
>  cache.o: $(srcdir)/cache.c $(top_builddir)/lib/config.h \
> - $(srcdir)/cache.h $(srcdir)/list.h $(srcdir)/xbitops.h
> + $(top_builddir)/lib/dirpaths.h $(srcdir)/list.h $(srcdir)/cache.h
> diff --git a/lib/support/cache.c b/lib/support/cache.c
> index 3a9e276f1..f9669e3fc 100644
> --- a/lib/support/cache.c
> +++ b/lib/support/cache.c
> @@ -7,6 +7,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <strings.h>
>  #include <unistd.h>
>  #include <pthread.h>
>  #include <stdbool.h>
> @@ -14,9 +15,9 @@
>  #include <stdint.h>
>  #include <errno.h>
>  
> +#include "config.h"
>  #include "list.h"
>  #include "cache.h"
> -#include "xbitops.h"
>  
>  #undef CACHE_DEBUG
>  /* #define CACHE_DEBUG 1 */
> @@ -32,6 +33,36 @@
>  # define ASSERT(x)		do { } while (0)
>  #endif
>  
> +#ifndef HAVE_FLS
> +static inline int fls(int x)
> +{
> +	int r = 32;
> +
> +	if (!x)
> +		return 0;
> +	if (!(x & 0xffff0000u)) {
> +		x = (x & 0xffffu) << 16;
> +		r -= 16;
> +	}
> +	if (!(x & 0xff000000u)) {
> +		x = (x & 0xffffffu) << 8;
> +		r -= 8;
> +	}
> +	if (!(x & 0xf0000000u)) {
> +		x = (x & 0xfffffffu) << 4;
> +		r -= 4;
> +	}
> +	if (!(x & 0xc0000000u)) {
> +		x = (x & 0x3fffffffu) << 2;
> +		r -= 2;
> +	}
> +	if (!(x & 0x80000000u)) {
> +		r -= 1;
> +	}
> +	return r;
> +}
> +#endif
> +
>  static unsigned int cache_generic_bulkrelse(struct cache *, struct list_head *);
>  
>  int
> diff --git a/lib/support/xbitops.h b/lib/support/xbitops.h
> deleted file mode 100644
> index 78a8f2a85..000000000
> --- a/lib/support/xbitops.h
> +++ /dev/null
> @@ -1,128 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -#ifndef __BITOPS_H__
> -#define __BITOPS_H__
> -
> -/*
> - * fls: find last bit set.
> - */
> -
> -static inline int fls(int x)
> -{
> -	int r = 32;
> -
> -	if (!x)
> -		return 0;
> -	if (!(x & 0xffff0000u)) {
> -		x = (x & 0xffffu) << 16;
> -		r -= 16;
> -	}
> -	if (!(x & 0xff000000u)) {
> -		x = (x & 0xffffffu) << 8;
> -		r -= 8;
> -	}
> -	if (!(x & 0xf0000000u)) {
> -		x = (x & 0xfffffffu) << 4;
> -		r -= 4;
> -	}
> -	if (!(x & 0xc0000000u)) {
> -		x = (x & 0x3fffffffu) << 2;
> -		r -= 2;
> -	}
> -	if (!(x & 0x80000000u)) {
> -		r -= 1;
> -	}
> -	return r;
> -}
> -
> -static inline int fls64(uint64_t x)
> -{
> -	uint32_t h = x >> 32;
> -	if (h)
> -		return fls(h) + 32;
> -	return fls(x);
> -}
> -
> -static inline unsigned fls_long(unsigned long l)
> -{
> -        if (sizeof(l) == 4)
> -                return fls(l);
> -        return fls64(l);
> -}
> -
> -/*
> - * ffz: find first zero bit.
> - * Result is undefined if no zero bit exists.
> - */
> -#define ffz(x)	ffs(~(x))
> -
> -/*
> - * XFS bit manipulation routines.  Repeated here so that some programs
> - * don't have to link in all of libxfs just to have bit manipulation.
> - */
> -
> -/*
> - * masks with n high/low bits set, 64-bit values
> - */
> -static inline uint64_t mask64hi(int n)
> -{
> -	return (uint64_t)-1 << (64 - (n));
> -}
> -static inline uint32_t mask32lo(int n)
> -{
> -	return ((uint32_t)1 << (n)) - 1;
> -}
> -static inline uint64_t mask64lo(int n)
> -{
> -	return ((uint64_t)1 << (n)) - 1;
> -}
> -
> -/* Get high bit set out of 32-bit argument, -1 if none set */
> -static inline int highbit32(uint32_t v)
> -{
> -	return fls(v) - 1;
> -}
> -
> -/* Get high bit set out of 64-bit argument, -1 if none set */
> -static inline int highbit64(uint64_t v)
> -{
> -	return fls64(v) - 1;
> -}
> -
> -/* Get low bit set out of 32-bit argument, -1 if none set */
> -static inline int lowbit32(uint32_t v)
> -{
> -	return ffs(v) - 1;
> -}
> -
> -/* Get low bit set out of 64-bit argument, -1 if none set */
> -static inline int lowbit64(uint64_t v)
> -{
> -	uint32_t	w = (uint32_t)v;
> -	int		n = 0;
> -
> -	if (w) {	/* lower bits */
> -		n = ffs(w);
> -	} else {	/* upper bits */
> -		w = (uint32_t)(v >> 32);
> -		if (w) {
> -			n = ffs(w);
> -			if (n)
> -				n += 32;
> -		}
> -	}
> -	return n - 1;
> -}
> -
> -/**
> - * __rounddown_pow_of_two() - round down to nearest power of two
> - * @n: value to round down
> - */
> -static inline __attribute__((const))
> -unsigned long __rounddown_pow_of_two(unsigned long n)
> -{
> -	return 1UL << (fls_long(n) - 1);
> -}
> -
> -#define rounddown_pow_of_two(n) __rounddown_pow_of_two(n)
> -
> -#endif
> -- 
> 2.53.0
> 
> 
