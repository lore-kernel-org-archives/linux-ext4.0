Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55F9314D15
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416424; cv=none; b=PLQRr7pGG50PZcvUSZYGH8NBuYCmLN4hVgflHyF+H2VdWSul2pHXDWc8K+hG/HetGnjm4VmI+aqpTU8thE03xmCXwSG9ecpAoaC0InipSkCSpIF5mW/l4pFTrSzAzHWbmzWmUE255EQQYRQ93HGRDpMgj1eXjGi/fq5IKy721F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416424; c=relaxed/simple;
	bh=+fiBnYE/G0hVOvPhnZseIPWPLZhXVFNj8Hs7ep1/PFI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jKsiLQuuaw8L4qwdS1zN9PrfIuhIK7dahBreWoQlLHEuvXS7fDe7/E5MrRQg+IeAoP0K5FVVDM2XX1p1LegqjH0dM/MCiQ/XQw5EdEfmvF3K0eo1DYQFRDarNhLkp08LK/cSYKy7YDKK2f0mEquJytsRmfXStXFGA100sfLscqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8+poJon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8+poJon"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 86E8D1F000E9;
	Thu, 25 Jun 2026 19:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416422;
	bh=Nbi2WeB58P5GIaMALlr707i0oggobay8w3NXIJnyQvg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=j8+poJonG7BhRoaar2B2x0EN6tJYSif36TFjrZPKYbj1KgwfBGNfrkNr1WzmYEOyD
	 4/KsLcdd7Gq1Blxv8M3NGxFbYbHWyBRHLBfkpKEDx9JsvMz8/IF/KULFkKm0dlB2wj
	 nLCGtByW4Wnz51Gm95wociuSrtcztih/TGR+Fp4rU+XTwKMOSKc/yY24stGi1L9x/X
	 BabHmPC/WA2pMsarkCsyn2PgfyvZJCC2pfOkqJU7TURnseH+Tgci7mNxJHsPwoQASq
	 6/ZXC0/y7kQXhQCt8AZ5LBRUMQCp1/hoMojHVK4RRqQrgM60PT1exL2RVywsAsersp
	 vDBacb8R+3nzA==
Date: Thu, 25 Jun 2026 12:40:22 -0700
Subject: [PATCH 4/6] fuse2fs: enable caching IO manager
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241607220.1810839.1314372486005301486.stgit@frogsfrogsfrogs>
In-Reply-To: <178241607127.1810839.16661954075518963408.stgit@frogsfrogsfrogs>
References: <178241607127.1810839.16661954075518963408.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Enable the new dynamic iocache I/O manager in the fuse server, and turn
off all the other cache control.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/Makefile.in   |    2 +-
 fuse4fs/fuse4fs.c     |   11 ++++++++---
 lib/support/iocache.c |    4 ++--
 misc/Makefile.in      |    3 ++-
 misc/fuse2fs.c        |    7 ++++++-
 5 files changed, 19 insertions(+), 8 deletions(-)


diff --git a/fuse4fs/Makefile.in b/fuse4fs/Makefile.in
index bb859369914a36..8fbbfabe7be1e7 100644
--- a/fuse4fs/Makefile.in
+++ b/fuse4fs/Makefile.in
@@ -180,7 +180,7 @@ fuse4fs.o: $(srcdir)/fuse4fs.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/support/bthread.h \
  $(top_srcdir)/lib/support/thread.h $(top_srcdir)/lib/support/list.h \
  $(top_srcdir)/lib/support/cache.h $(top_srcdir)/version.h \
- $(top_srcdir)/lib/e2p/e2p.h
+ $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/support/iocache.h
 journal.o: $(srcdir)/../debugfs/journal.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/../debugfs/journal.h \
  $(top_srcdir)/e2fsck/jfs_user.h $(top_srcdir)/e2fsck/e2fsck.h \
diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index fdd4327a4c0907..43e7278ffec1a9 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -60,6 +60,7 @@
 #include "support/thread.h"
 #include "support/list.h"
 #include "support/cache.h"
+#include "support/iocache.h"
 
 #include "../version.h"
 #include "uuid/uuid.h"
@@ -1434,13 +1435,15 @@ static errcode_t fuse4fs_service_openfs(struct fuse4fs *ff, char *options,
 	if (ret)
 		return errno;
 
+	iocache_set_backing_manager(unixfd_io_manager);
+
 	/*
 	 * Open the filesystem with SKIP_MMP so that we can find out if the
 	 * filesystem actually has MMP.
 	 */
 	snprintf(path, sizeof(path), "/dev/fd/%d", ff->bdev_fd);
 	retval = ext2fs_open2(path, options, *flags | EXT2_FLAG_SKIP_MMP, 0, 0,
-			      unixfd_io_manager, &ff->fs);
+			      iocache_io_manager, &ff->fs);
 	if (retval)
 		return retval;
 
@@ -1473,7 +1476,7 @@ static errcode_t fuse4fs_service_openfs(struct fuse4fs *ff, char *options,
 		*flags |= EXT2_FLAG_DIRECT_IO;
 	}
 
-	return ext2fs_open2(path, options, *flags, 0, 0, unixfd_io_manager,
+	return ext2fs_open2(path, options, *flags, 0, 0, iocache_io_manager,
 			    &ff->fs);
 }
 #else
@@ -1581,6 +1584,8 @@ static errcode_t fuse4fs_open(struct fuse4fs *ff)
 	if (ff->directio)
 		flags |= EXT2_FLAG_DIRECT_IO;
 
+	iocache_set_backing_manager(unix_io_manager);
+
 	/*
 	 * If the filesystem is stored on a block device, the _EXCLUSIVE flag
 	 * causes libext2fs to try to open the block device with O_EXCL.  If
@@ -1616,7 +1621,7 @@ static errcode_t fuse4fs_open(struct fuse4fs *ff)
 			err = fuse4fs_service_openfs(ff, options, &flags);
 		else
 			err = ext2fs_open2(ff->device, options, flags, 0, 0,
-					   unix_io_manager, &ff->fs);
+					   iocache_io_manager, &ff->fs);
 		if ((err == EPERM || err == EACCES) &&
 		    (!ff->ro || (flags & EXT2_FLAG_RW))) {
 			/*
diff --git a/lib/support/iocache.c b/lib/support/iocache.c
index 82f805e1000e97..4ed941ff2d3ae6 100644
--- a/lib/support/iocache.c
+++ b/lib/support/iocache.c
@@ -249,7 +249,7 @@ static void iocache_invalidate_bufs(struct iocache_private_data *data,
  */
 static void iocache_invalidate_cache(struct iocache_private_data *data)
 {
-	LIST_HEAD(list);
+	struct list_head list = LIST_HEAD_INIT(list);
 
 	cache_walk(&data->cache, iocache_add_list, &list);
 	iocache_invalidate_bufs(data, &list);
@@ -262,7 +262,7 @@ static void iocache_invalidate_cache(struct iocache_private_data *data)
 static void iocache_invalidate_range(struct iocache_private_data *data,
 				     blk64_t block, uint64_t count)
 {
-	LIST_HEAD(list);
+	struct list_head list = LIST_HEAD_INIT(list);
 	uint64_t i;
 
 	for (i = 0; i < count; i++) {
diff --git a/misc/Makefile.in b/misc/Makefile.in
index ec964688acd623..48bd42b8272572 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -880,7 +880,8 @@ fuse2fs.o: $(srcdir)/fuse2fs.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/hashmap.h \
  $(top_srcdir)/lib/ext2fs/bitops.h $(top_srcdir)/lib/ext2fs/ext2fsP.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/version.h \
- $(top_srcdir)/lib/e2p/e2p.h
+ $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/support/cache.h \
+ $(top_srcdir)/lib/support/list.h $(top_srcdir)/lib/support/iocache.h
 e2fuzz.o: $(srcdir)/e2fuzz.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 59ad3ab0c6eb3f..32f4f1e2a48056 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -49,6 +49,9 @@
 #include "ext2fs/ext2fsP.h"
 #include "support/bthread.h"
 #include "support/thread.h"
+#include "support/list.h"
+#include "support/cache.h"
+#include "support/iocache.h"
 
 #include "../version.h"
 #include "uuid/uuid.h"
@@ -1176,6 +1179,8 @@ static errcode_t fuse2fs_open(struct fuse2fs *ff)
 	if (ff->directio)
 		flags |= EXT2_FLAG_DIRECT_IO;
 
+	iocache_set_backing_manager(unix_io_manager);
+
 	/*
 	 * If the filesystem is stored on a block device, the _EXCLUSIVE flag
 	 * causes libext2fs to try to open the block device with O_EXCL.  If
@@ -1208,7 +1213,7 @@ static errcode_t fuse2fs_open(struct fuse2fs *ff)
 	deadline = init_deadline(FUSE2FS_OPEN_TIMEOUT);
 	do {
 		err = ext2fs_open2(ff->device, options, flags, 0, 0,
-				   unix_io_manager, &ff->fs);
+				   iocache_io_manager, &ff->fs);
 		if ((err == EPERM || err == EACCES) &&
 		    (!ff->ro || (flags & EXT2_FLAG_RW))) {
 			/*

