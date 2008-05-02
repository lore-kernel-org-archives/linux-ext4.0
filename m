From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, RFC] ext3: move headers out of include/linux
Date: Fri, 2 May 2008 09:48:46 -0400
Message-ID: <20080502134846.GJ17365@mit.edu>
References: <E1JrZxd-0004c8-7E@closure.thunk.org> <alpine.LFD.1.10.0805011134520.5994@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57693 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764861AbYEBNtK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 May 2008 09:49:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805011134520.5994@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2008 at 11:39:38AM -0700, Linus Torvalds wrote:
> I'd suggest not sending out patches like this.
> 
> If the patch is largely a rename one, and sent out for review, just use 
> "git diff -M -p --stat --summary", because it's going to be a *lot* more 
> reviewable that way.

Um, yeah, good point.  I've added diff.renames=copies to my .gitconfig
file, because it really is much easier to review.

Is this better, and would you be willing to apply this at this point
in the merge cycle?

					- Ted

>From f149cd2c06eb8611afd254cb56e764815fe2dc7f Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Wed, 30 Apr 2008 23:06:56 -0400
Subject: [PATCH] ext3: move headers out of include/linux

Move ext3 headers out of include/linux.  Cristoph promised to do this
once the ext4 patch was accepted, but I figured I'd do him a favor and
do it for him.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext3/acl.c                                   |    4 ++--
 fs/ext3/balloc.c                                |    5 ++---
 fs/ext3/bitmap.c                                |    2 +-
 fs/ext3/dir.c                                   |    3 +--
 include/linux/ext3_fs.h => fs/ext3/ext3.h       |    7 ++++---
 include/linux/ext3_fs_i.h => fs/ext3/ext3_i.h   |    0 
 fs/ext3/ext3_jbd.c                              |    3 ++-
 {include/linux => fs/ext3}/ext3_jbd.h           |    1 -
 include/linux/ext3_fs_sb.h => fs/ext3/ext3_sb.h |    0 
 fs/ext3/file.c                                  |    5 ++---
 fs/ext3/fsync.c                                 |    5 ++---
 fs/ext3/hash.c                                  |    3 +--
 fs/ext3/ialloc.c                                |    5 ++---
 fs/ext3/inode.c                                 |    4 ++--
 fs/ext3/ioctl.c                                 |    5 ++---
 fs/ext3/namei.c                                 |    5 ++---
 fs/ext3/resize.c                                |    5 ++---
 fs/ext3/super.c                                 |    5 ++---
 fs/ext3/symlink.c                               |    3 +--
 fs/ext3/xattr.c                                 |    4 ++--
 fs/ext3/xattr_security.c                        |    4 ++--
 fs/ext3/xattr_trusted.c                         |    4 ++--
 fs/ext3/xattr_user.c                            |    4 ++--
 23 files changed, 38 insertions(+), 48 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index a754d18..82e90dd 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -9,8 +9,8 @@
 #include <linux/slab.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
-#include <linux/ext3_jbd.h>
-#include <linux/ext3_fs.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 #include "xattr.h"
 #include "acl.h"
 
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 92fd033..1905a56 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -14,11 +14,10 @@
 #include <linux/time.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
-#include <linux/jbd.h>
-#include <linux/ext3_fs.h>
-#include <linux/ext3_jbd.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
diff --git a/fs/ext3/bitmap.c b/fs/ext3/bitmap.c
index 6afc39d..aff8a6f 100644
--- a/fs/ext3/bitmap.c
+++ b/fs/ext3/bitmap.c
@@ -9,7 +9,7 @@
 
 #include <linux/buffer_head.h>
 #include <linux/jbd.h>
-#include <linux/ext3_fs.h>
+#include "ext3.h"
 
 #ifdef EXT3FS_DEBUG
 
diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 8ca3bfd..4462774 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -22,11 +22,10 @@
  */
 
 #include <linux/fs.h>
-#include <linux/jbd.h>
-#include <linux/ext3_fs.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
+#include "ext3.h"
 
 static unsigned char ext3_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
diff --git a/include/linux/ext3_fs.h b/fs/ext3/ext3.h
similarity index 99%
rename from include/linux/ext3_fs.h
rename to fs/ext3/ext3.h
index 36c5403..ac02b7f 100644
--- a/include/linux/ext3_fs.h
+++ b/fs/ext3/ext3.h
@@ -1,5 +1,5 @@
 /*
- *  linux/include/linux/ext3_fs.h
+ *  ext3.h
  *
  * Copyright (C) 1992, 1993, 1994, 1995
  * Remy Card (card@masi.ibp.fr)
@@ -18,6 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#include <linux/jbd.h>
 
 /*
  * The second extended filesystem constants/structures
@@ -491,8 +492,8 @@ struct ext3_super_block {
 };
 
 #ifdef __KERNEL__
-#include <linux/ext3_fs_i.h>
-#include <linux/ext3_fs_sb.h>
+#include "ext3_i.h"
+#include "ext3_sb.h"
 static inline struct ext3_sb_info * EXT3_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/include/linux/ext3_fs_i.h b/fs/ext3/ext3_i.h
similarity index 100%
rename from include/linux/ext3_fs_i.h
rename to fs/ext3/ext3_i.h
diff --git a/fs/ext3/ext3_jbd.c b/fs/ext3/ext3_jbd.c
index d401f14..7611de3 100644
--- a/fs/ext3/ext3_jbd.c
+++ b/fs/ext3/ext3_jbd.c
@@ -2,7 +2,8 @@
  * Interface between ext3 and JBD
  */
 
-#include <linux/ext3_jbd.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 
 int __ext3_journal_get_undo_access(const char *where, handle_t *handle,
 				struct buffer_head *bh)
diff --git a/include/linux/ext3_jbd.h b/fs/ext3/ext3_jbd.h
similarity index 99%
rename from include/linux/ext3_jbd.h
rename to fs/ext3/ext3_jbd.h
index 8c43b13..aadbdef 100644
--- a/include/linux/ext3_jbd.h
+++ b/fs/ext3/ext3_jbd.h
@@ -17,7 +17,6 @@
 
 #include <linux/fs.h>
 #include <linux/jbd.h>
-#include <linux/ext3_fs.h>
 
 #define EXT3_JOURNAL(inode)	(EXT3_SB((inode)->i_sb)->s_journal)
 
diff --git a/include/linux/ext3_fs_sb.h b/fs/ext3/ext3_sb.h
similarity index 100%
rename from include/linux/ext3_fs_sb.h
rename to fs/ext3/ext3_sb.h
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index acc4913..9d57f8e 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -20,9 +20,8 @@
 
 #include <linux/time.h>
 #include <linux/fs.h>
-#include <linux/jbd.h>
-#include <linux/ext3_fs.h>
-#include <linux/ext3_jbd.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 #include "xattr.h"
 #include "acl.h"
 
diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index d336341..a785985 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -26,9 +26,8 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/writeback.h>
-#include <linux/jbd.h>
-#include <linux/ext3_fs.h>
-#include <linux/ext3_jbd.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 
 /*
  * akpm: A new design for ext3_sync_file().
diff --git a/fs/ext3/hash.c b/fs/ext3/hash.c
index c30e149..9433d53 100644
--- a/fs/ext3/hash.c
+++ b/fs/ext3/hash.c
@@ -10,9 +10,8 @@
  */
 
 #include <linux/fs.h>
-#include <linux/jbd.h>
-#include <linux/ext3_fs.h>
 #include <linux/cryptohash.h>
+#include "ext3.h"
 
 #define DELTA 0x9E3779B9
 
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 7712682..34daa2b 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -14,15 +14,14 @@
 
 #include <linux/time.h>
 #include <linux/fs.h>
-#include <linux/jbd.h>
-#include <linux/ext3_fs.h>
-#include <linux/ext3_jbd.h>
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/random.h>
 #include <linux/bitops.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 
 #include <asm/byteorder.h>
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 6ae4ecf..beb8569 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -25,8 +25,6 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
-#include <linux/ext3_jbd.h>
-#include <linux/jbd.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
@@ -36,6 +34,8 @@
 #include <linux/mpage.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 #include "xattr.h"
 #include "acl.h"
 
diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
index 0d0c701..0f3d04c 100644
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -8,15 +8,14 @@
  */
 
 #include <linux/fs.h>
-#include <linux/jbd.h>
 #include <linux/capability.h>
-#include <linux/ext3_fs.h>
-#include <linux/ext3_jbd.h>
 #include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/compat.h>
 #include <linux/smp_lock.h>
 #include <asm/uaccess.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 
 int ext3_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 		unsigned long arg)
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 0b8cf80..2bbcc6d 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -26,16 +26,15 @@
 
 #include <linux/fs.h>
 #include <linux/pagemap.h>
-#include <linux/jbd.h>
 #include <linux/time.h>
-#include <linux/ext3_fs.h>
-#include <linux/ext3_jbd.h>
 #include <linux/fcntl.h>
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 
 #include "namei.h"
 #include "xattr.h"
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 28cfd0b..54fb515 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -11,11 +11,10 @@
 
 #define EXT3FS_DEBUG
 
-#include <linux/ext3_jbd.h>
-
 #include <linux/errno.h>
 #include <linux/slab.h>
-
+#include "ext3.h"
+#include "ext3_jbd.h"
 
 #define outside(b, first, last)	((b) < (first) || (b) >= (last))
 #define inside(b, first, last)	((b) >= (first) && (b) < (last))
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fe3119a..e77bb36 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -20,9 +20,6 @@
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/time.h>
-#include <linux/jbd.h>
-#include <linux/ext3_fs.h>
-#include <linux/ext3_jbd.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
@@ -37,6 +34,8 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/log2.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 
 #include <asm/uaccess.h>
 
diff --git a/fs/ext3/symlink.c b/fs/ext3/symlink.c
index ff7b4cc..44b6185 100644
--- a/fs/ext3/symlink.c
+++ b/fs/ext3/symlink.c
@@ -18,9 +18,8 @@
  */
 
 #include <linux/fs.h>
-#include <linux/jbd.h>
-#include <linux/ext3_fs.h>
 #include <linux/namei.h>
+#include "ext3.h"
 #include "xattr.h"
 
 static void * ext3_follow_link(struct dentry *dentry, struct nameidata *nd)
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index d4a4f0e..5b2eb4a 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -53,11 +53,11 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <linux/ext3_jbd.h>
-#include <linux/ext3_fs.h>
 #include <linux/mbcache.h>
 #include <linux/quotaops.h>
 #include <linux/rwsem.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 #include "xattr.h"
 #include "acl.h"
 
diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index 821efaf..afa6f4b 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -6,8 +6,8 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/ext3_jbd.h>
-#include <linux/ext3_fs.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 #include <linux/security.h>
 #include "xattr.h"
 
diff --git a/fs/ext3/xattr_trusted.c b/fs/ext3/xattr_trusted.c
index 0327497..75bceb3 100644
--- a/fs/ext3/xattr_trusted.c
+++ b/fs/ext3/xattr_trusted.c
@@ -9,8 +9,8 @@
 #include <linux/string.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
-#include <linux/ext3_jbd.h>
-#include <linux/ext3_fs.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 #include "xattr.h"
 
 #define XATTR_TRUSTED_PREFIX "trusted."
diff --git a/fs/ext3/xattr_user.c b/fs/ext3/xattr_user.c
index 1abd8f9..abb218b 100644
--- a/fs/ext3/xattr_user.c
+++ b/fs/ext3/xattr_user.c
@@ -8,8 +8,8 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/ext3_jbd.h>
-#include <linux/ext3_fs.h>
+#include "ext3.h"
+#include "ext3_jbd.h"
 #include "xattr.h"
 
 #define XATTR_USER_PREFIX "user."
-- 
1.5.4.1.144.gdfee-dirty

