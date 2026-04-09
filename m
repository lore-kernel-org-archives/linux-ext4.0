Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACA6279DA6
	for <linux-ext4@vger.kernel.org>; Thu,  9 Apr 2026 20:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775765583; cv=none; b=tdYFRufi2ItzjW2AUTGgnDVdQ62bbQqqeMSpz2A9U4Ia4fX3628NJgRXw5PXCckiEikWW3vBicycyQ6aJm1nfoRhEmVlOdaKi7A+U8mXTeTNcAJLpZzPl5bfBY2zzERqpsOdRAOHVx+fYDIJpaIRIWqR56w4HPPKrk+EH6HTWyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775765583; c=relaxed/simple;
	bh=xT4PE+pGX4lM9vAIIbfxAeQrsnqJUUd9atdffv7jk1k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=c9m49yJ7CprWLfRO8kageqZsnGauago7e9Wwl5J2Vd/OlWRhsxWt/sfX2DtG8D3Ybs+P6xn2kW65fZbCKmJArxGEPFHUGCBsnuSZaS4Vj+TB8JAC+TVZQmprjS/s6LowIdGOnAkkUGXGxEOZMYc3x3BpPk2uvUF3DxJeJI3O8d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZLqiAno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZLqiAno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434C5C4CEF7;
	Thu,  9 Apr 2026 20:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775765583;
	bh=xT4PE+pGX4lM9vAIIbfxAeQrsnqJUUd9atdffv7jk1k=;
	h=Date:From:To:Cc:Subject:From;
	b=AZLqiAnozWigbZMD4o9oyFXvqFNOAn2CYnpppo2+phwj9XVrJhmo8SV9Fc5rXp1bc
	 RbnBnCkoXJDQGsf+C32fJqIvec7c2ZMu9FfI86SAJ+Ug6k++Q2d5djcLPRSBnhGgXm
	 VaIwK7wfI3LgvMWzgDrbDQu6KSBSgdPP6Q79SPWnt+ffpWEh0QpMd7o7mrzN4ERpKw
	 nsAuDvIN6qI7z/43bQDLQa8UmzaXSPafyRZUUZz62EtQ0/5gVm2dqAHA7UYI1ozb0V
	 BpQjOCDefhkWYrdws/uLTWefqAp5yekbYupXKOFrkUjMadY1s3jTx/XyCCZzV8noSt
	 4kv6tkHSDvycA==
Date: Thu, 9 Apr 2026 13:13:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, amir73il@gmail.com
Subject: [PULLBOMB v3 1.48] fuse4fs: drop libfuse2, add new server
Message-ID: <20260409201302.GD6192@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ted,

As promised during this morning's ext4 call, this large patchbomb
contains the remaining improvements that I'd like to make to fuse2fs
before integrating iomap.

The first pull request drops libfuse2 support from e2fsprogs.

The second pull request creates a new fuse ext* server (fuse4fs) which
uses the lowlevel FUSE API instead of the high level one.  The major
advantage of using the lowlevel API is that all file operations are
performed in terms of inodes instead of paths.  As a result, fuse4fs has
MUCH less overhead than fuse2fs because we avoid the overhead of having
libfuse translate inode numbers to paths only to have fuse2fs translate
paths back into inode numbers.

Obviously, this stuff should go into e2fsprogs 1.48, not a 1.47.x stable
release.  This patchbomb hasn't changed much since its last posting on
12 Mar 2026.  The range-diff between then and now is appended below;
there aren't really any changes other than the effects of rebasing
against today's next branch and adapting to using autoheader(1).

One curious thing: I saw in [1] that you applied my get_thread_id
change, but it isn't in -next yet.  These PRs might not merge properly.
Obviously it's no big deal for me to rebase and send new PRs.

--D

 -:  -------------- >  1:  91f5b6651553fe fuse2fs: bump library version
 1:  7e7bb349a384f7 =  2:  cf80ae2e89ba2f fuse2fs: wrap the fuse_set_feature_flag helper for older libfuse
 2:  631d3f8d14b613 =  3:  c7d947ac718bb4 fuse2fs: disable nfs exports
 3:  96ca2a29cc7dcb !  4:  c137760397ef66 fuse2fs: drop fuse 2.x support code
    @@ configure.ac: then
      	AC_DEFINE_UNQUOTED(FUSE_USE_VERSION, $FUSE_USE_VERSION,
      		[Define to the version of FUSE to use])
      fi
     
      ## misc/fuse2fs.c ##
     @@
    - #endif /* __SET_FOB_FOR_FUSE */
      #include <inttypes.h>
      #include "ext2fs/ext2fs.h"
      #include "ext2fs/ext2_fs.h"
      #include "ext2fs/ext2fsP.h"
      #include "support/bthread.h"
    + #include "support/thread.h"
     -#if FUSE_VERSION >= FUSE_MAKE_VERSION(3, 0)
     -# define FUSE_PLATFORM_OPTS	""
     -#else
     -# ifdef __linux__
     -#  define FUSE_PLATFORM_OPTS	",use_ino,big_writes"
     -# else
 4:  e048f198d7b598 =  5:  239f4b7ac05b69 fuse2fs: separate libfuse3 and fuse2fs detection in configure
 5:  3b02fa292dda7c !  6:  1536edf8a93539 fuse2fs: start porting fuse2fs to lowlevel libfuse API
    @@ fuse4fs/fuse4fs.c (new)
     +#endif /* __SET_FOB_FOR_FUSE */
     +#include <inttypes.h>
     +#include "ext2fs/ext2fs.h"
     +#include "ext2fs/ext2_fs.h"
     +#include "ext2fs/ext2fsP.h"
     +#include "support/bthread.h"
    ++#include "support/thread.h"
     +
     +#include "../version.h"
     +#include "uuid/uuid.h"
     +#include "e2p/e2p.h"
     +
     +#ifdef ENABLE_NLS
    @@ fuse4fs/fuse4fs.c (new)
     +	m = b % align;
     +	return b - m;
     +}
     +
     +#define dbg_printf(fuse4fs, format, ...) \
     +	while ((fuse4fs)->debug) { \
    -+		printf("FUSE4FS (%s): tid=%d " format, (fuse4fs)->shortdev, gettid(), ##__VA_ARGS__); \
    ++		printf("FUSE4FS (%s): tid=%llu " format, (fuse4fs)->shortdev, get_thread_id(), ##__VA_ARGS__); \
     +		fflush(stdout); \
     +		break; \
     +	}
     +
     +#define log_printf(fuse4fs, format, ...) \
     +	do { \
    @@ fuse4fs/fuse4fs.c (new)
     +		ret = -EUCLEAN;
     +		break;
     +	case EIO:
     +#ifdef EILSEQ
     +	case EILSEQ:
     +#endif
    ++#if EUCLEAN != EIO
     +	case EUCLEAN:
    ++#endif
     +		/* these errnos usually denote corruption or persistence fail */
     +		is_err = 1;
     +		ret = -err;
     +		break;
     +	default:
     +		if (err < 256) {
    @@ fuse4fs/fuse4fs.c (new)
     +
     +	return ret;
     +}
     
      ## lib/config.h.in ##
     @@
    - /* Define to 1 if you have the BSD-style 'qsort_r' function. */
    - #undef HAVE_BSD_QSORT_R
    + /* Define to 1 if fuse supports cache_readdir */
    + #undef HAVE_FUSE_CACHE_READDIR
      
    - /* Define to 1 if PR_SET_IO_FLUSHER is present */
    - #undef HAVE_PR_SET_IO_FLUSHER
    + /* Define to 1 if you have the <fuse.h> header file. */
    + #undef HAVE_FUSE_H
      
     +/* Define to 1 if fuse supports lowlevel API */
     +#undef HAVE_FUSE_LOWLEVEL
     +
    - /* Define to 1 if you have the Mac OS X function
    -    CFLocaleCopyPreferredLanguages in the CoreFoundation framework. */
    - #undef HAVE_CFLOCALECOPYPREFERREDLANGUAGES
    + /* Define to 1 if you have the 'futimes' function. */
    + #undef HAVE_FUTIMES
    + 
    + /* Define to 1 if you have the 'getcwd' function. */
    + #undef HAVE_GETCWD
      
    - /* Define to 1 if you have the Mac OS X function CFPreferencesCopyAppValue in
    -    the CoreFoundation framework. */
 6:  480ffd57c3152f =  7:  de29e11fda2d6b debian: create new package for fuse4fs
 7:  eb97e1fefbf286 =  8:  d4aa426efc0f3c fuse4fs: namespace some helpers
 8:  7a2e6084f203a4 =  9:  a53dd84ef7ce0c fuse4fs: convert to low level API
 9:  8072dafea5ba54 = 10:  37dafcc0894b89 libsupport: port the kernel list.h to libsupport
10:  df5e76db0018b3 ! 11:  30b3c80ed6bcc5 libsupport: add a cache
    @@ lib/support/xbitops.h (new)
     +#define rounddown_pow_of_two(n) __rounddown_pow_of_two(n)
     +
     +#endif
     
      ## lib/support/Makefile.in ##
     @@ lib/support/Makefile.in: OBJS=		bthread.o \
    - 		profile_helpers.o \
      		prof_err.o \
      		quotaio.o \
      		quotaio_v2.o \
      		quotaio_tree.o \
    + 		thread.o \
      		dict.o \
     -		devname.o
     +		devname.o \
     +		cache.o
      
      SRCS=		$(srcdir)/argv_parse.c \
      		$(srcdir)/bthread.c \
      		$(srcdir)/cstring.c \
      		$(srcdir)/mkquota.c \
      		$(srcdir)/parse_qtype.c \
     @@ lib/support/Makefile.in: SRCS=		$(srcdir)/argv_parse.c \
    - 		$(srcdir)/profile_helpers.c \
      		prof_err.c \
      		$(srcdir)/quotaio.c \
      		$(srcdir)/quotaio_tree.c \
      		$(srcdir)/quotaio_v2.c \
    + 		$(srcdir)/thread.c \
      		$(srcdir)/dict.c \
     -		$(srcdir)/devname.c
     +		$(srcdir)/devname.c \
     +		$(srcdir)/cache.c
      
      LIBRARY= libsupport
      LIBDIR= support
      
      @MAKEFILE_LIBRARY@
      @MAKEFILE_PROFILE@
     @@ lib/support/Makefile.in: quotaio_v2.o: $(srcdir)/quotaio_v2.c $(top_builddir)/lib/config.h \
    -  $(top_srcdir)/lib/ext2fs/bitops.h $(srcdir)/dqblk_v2.h \
    -  $(srcdir)/quotaio_tree.h
    + thread.o: $(srcdir)/thread.c $(top_builddir)/lib/config.h \
    +  $(top_builddir)/lib/dirpaths.h $(srcdir)/thread.h
      dict.o: $(srcdir)/dict.c $(top_builddir)/lib/config.h \
       $(top_builddir)/lib/dirpaths.h $(srcdir)/dict.h
      devname.o: $(srcdir)/devname.c $(top_builddir)/lib/config.h \
       $(top_builddir)/lib/dirpaths.h $(srcdir)/devname.h $(srcdir)/nls-enable.h
     +cache.o: $(srcdir)/cache.c $(top_builddir)/lib/config.h \
     + $(srcdir)/cache.h $(srcdir)/list.h $(srcdir)/xbitops.h
11:  f13414a72be32f = 12:  fb17b6521f0430 cache: disable debugging
12:  383f3dd0b56f64 = 13:  b6d5640bdf0086 cache: use modern list iterator macros
13:  a9c0181ee15128 = 14:  0be92e2d351193 cache: embed struct cache in the owner
14:  31e5763e32dfc2 = 15:  a486e89007fb55 cache: pass cache pointer to callbacks
15:  a5c773947bd56d = 16:  ae4911b183fa9d cache: pass a private data pointer through cache_walk
16:  4f017b4dc8920f = 17:  9c5af5b9d39a70 cache: add a helper to grab a new refcount for a cache_node
17:  d1dea709493fdc = 18:  c6ed3f93d43660 cache: return results of a cache flush
18:  e59f4eba2f22f8 = 19:  a13c635ef81b43 cache: add a "get only if incore" flag to cache_node_get
19:  a999b4c74344cd = 20:  cbd9dbc6943267 cache: support gradual expansion
20:  019aa0d8a8c87d = 21:  5d91f82ff155b9 cache: support updating maxcount and flags
21:  0283835cbfa2db = 22:  7134be34c002f5 cache: support channging flags
22:  0f5c83c6c88c3f = 23:  2a8ddebbfa9298 cache: implement automatic shrinking
23:  26f78774c08acc ! 24:  dd17627e00495e fuse4fs: add cache to track open files
    @@ fuse4fs/fuse4fs.c
      #ifdef __SET_FOB_FOR_FUSE
      # error Do not set magic value __SET_FOB_FOR_FUSE!!!!
      #endif
      #ifndef _FILE_OFFSET_BITS
      /*
     @@
    - #endif /* __SET_FOB_FOR_FUSE */
      #include <inttypes.h>
      #include "ext2fs/ext2fs.h"
      #include "ext2fs/ext2_fs.h"
      #include "ext2fs/ext2fsP.h"
      #include "support/bthread.h"
    + #include "support/thread.h"
     +#include "support/list.h"
     +#include "support/cache.h"
      
      #include "../version.h"
      #include "uuid/uuid.h"
      #include "e2p/e2p.h"
24:  d6a2e3be991671 = 25:  2ea53b826253b6 fuse4fs: use the orphaned inode list
25:  2a4c9c2e579556 = 26:  6bd1919297a22f fuse4fs: implement FUSE_TMPFILE
26:  38cd25631692e6 = 27:  951a10258cada0 fuse4fs: create incore reverse orphan list
