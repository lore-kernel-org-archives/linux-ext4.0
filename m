From: amir73il@users.sourceforge.net
Subject: [PATCH v1 01/36] ext4: EXT4 snapshots (Experimental)
Date: Tue,  7 Jun 2011 18:07:28 +0300
Message-ID: <1307459283-22130-2-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1FGPI7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:08:59 -0400
Received: by wwa36 with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:08:57 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Built-in snapshots support for ext4.
Requires that the filesystem has the has_snapshot and exclude_bitmap
features and that block size is equal to system page size.
Snapshots are not supported with 64bit and meta_bg features and the
filesystem must be mounted with ordered data mode.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/Kconfig           |   11 ++
 fs/ext4/Makefile          |    2 +
 fs/ext4/balloc.c          |    2 +-
 fs/ext4/ext4.h            |   15 +++
 fs/ext4/ext4_jbd2.c       |    3 +
 fs/ext4/ext4_jbd2.h       |   25 +++++
 fs/ext4/extents.c         |    3 +
 fs/ext4/file.c            |    1 +
 fs/ext4/ialloc.c          |    1 +
 fs/ext4/inode.c           |    3 +
 fs/ext4/ioctl.c           |    3 +
 fs/ext4/mballoc.c         |    5 +
 fs/ext4/namei.c           |    1 +
 fs/ext4/resize.c          |    1 +
 fs/ext4/snapshot.c        |   18 ++++
 fs/ext4/snapshot.h        |  193 ++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot_buffer.c |  238 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot_ctl.c    |   22 ++++
 fs/ext4/snapshot_inode.c  |   42 ++++++++
 fs/ext4/super.c           |   43 ++++++++
 20 files changed, 631 insertions(+), 1 deletions(-)
 create mode 100644 fs/ext4/snapshot.c
 create mode 100644 fs/ext4/snapshot.h
 create mode 100644 fs/ext4/snapshot_buffer.c
 create mode 100644 fs/ext4/snapshot_ctl.c
 create mode 100644 fs/ext4/snapshot_debug.c
 create mode 100644 fs/ext4/snapshot_debug.h
 create mode 100644 fs/ext4/snapshot_inode.c

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9ed1bb1..8970525 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -83,3 +83,14 @@ config EXT4_DEBUG
 
 	  If you select Y here, then you will be able to turn on debugging
 	  with a command such as "echo 1 > /sys/kernel/debug/ext4/mballoc-debug"
+
+config EXT4_FS_SNAPSHOT
+	bool "EXT4 snapshots (Experimental)"
+	depends on EXT4_FS && EXPERIMENTAL
+	default n
+	help
+	  Built-in snapshots support for ext4.
+	  Requires that the filesystem has the has_snapshot and exclude_bitmap
+	  features and that block size is equal to system page size.
+	  Snapshots are not supported with 64bit and meta_bg features and the
+	  filesystem must be mounted with ordered data mode.
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index c947e36..a471c2e 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -11,3 +11,5 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
 ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
+ext4-$(CONFIG_EXT4_FS_SNAPSHOT)		+= snapshot.o snapshot_ctl.o
+ext4-$(CONFIG_EXT4_FS_SNAPSHOT)		+= snapshot_inode.o snapshot_buffer.o
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index b2d10da..8f1803f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -20,6 +20,7 @@
 #include "ext4.h"
 #include "ext4_jbd2.h"
 #include "mballoc.h"
+#include "snapshot.h"
 
 #include <trace/events/ext4.h>
 
@@ -156,7 +157,6 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		tmp = ext4_block_bitmap(sb, gdp);
 		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
 			ext4_set_bit(tmp - start, bh->b_data);
-
 		tmp = ext4_inode_bitmap(sb, gdp);
 		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
 			ext4_set_bit(tmp - start, bh->b_data);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 076c5d2..756848f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -873,6 +873,20 @@ struct ext4_inode_info {
 #define EXT2_FLAGS_SIGNED_HASH		0x0001  /* Signed dirhash in use */
 #define EXT2_FLAGS_UNSIGNED_HASH	0x0002  /* Unsigned dirhash in use */
 #define EXT2_FLAGS_TEST_FILESYS		0x0004	/* to test development code */
+#define EXT4_FLAGS_IS_SNAPSHOT		0x0010 /* Is a snapshot image */
+#define EXT4_FLAGS_FIX_SNAPSHOT		0x0020 /* Corrupted snapshot */
+#define EXT4_FLAGS_FIX_EXCLUDE		0x0040 /* Bad exclude bitmap */
+
+#define EXT4_SET_FLAGS(sb, mask)				 \
+	do {							 \
+		EXT4_SB(sb)->s_es->s_flags |= cpu_to_le32(mask); \
+	} while (0)
+#define EXT4_CLEAR_FLAGS(sb, mask)				 \
+	do {							 \
+		EXT4_SB(sb)->s_es->s_flags &= ~cpu_to_le32(mask);\
+	} while (0)
+#define EXT4_TEST_FLAGS(sb, mask)				 \
+	(EXT4_SB(sb)->s_es->s_flags & cpu_to_le32(mask))
 
 /*
  * Mount flags
@@ -1338,6 +1352,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
+#define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080 /* Ext4 has snapshots */
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 6e272ef..560020d 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -1,8 +1,11 @@
 /*
  * Interface between ext4 and JBD
+ *
+ * Snapshot metadata COW hooks, Amir Goldstein <amir73il@users.sf.net>, 2011
  */
 
 #include "ext4_jbd2.h"
+#include "snapshot.h"
 
 #include <trace/events/ext4.h>
 
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index d0f5353..3da2092 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -10,6 +10,8 @@
  * option, any later version, incorporated herein by reference.
  *
  * Ext4-specific journaling extensions.
+ *
+ * Snapshot extra COW credits, Amir Goldstein <amir73il@users.sf.net>, 2011
  */
 
 #ifndef _EXT4_JBD2_H
@@ -18,6 +20,7 @@
 #include <linux/fs.h>
 #include <linux/jbd2.h>
 #include "ext4.h"
+#include "snapshot.h"
 
 #define EXT4_JOURNAL(inode)	(EXT4_SB((inode)->i_sb)->s_journal)
 
@@ -272,6 +275,11 @@ static inline int ext4_should_journal_data(struct inode *inode)
 		return 0;
 	if (!S_ISREG(inode->i_mode))
 		return 1;
+#ifdef CONFIG_EXT4_FS_SNAPSHOT
+	if (EXT4_SNAPSHOTS(inode->i_sb))
+		/* snapshots enforce ordered data */
+		return 0;
+#endif
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 		return 1;
 	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
@@ -285,6 +293,11 @@ static inline int ext4_should_order_data(struct inode *inode)
 		return 0;
 	if (!S_ISREG(inode->i_mode))
 		return 0;
+#ifdef CONFIG_EXT4_FS_SNAPSHOT
+	if (EXT4_SNAPSHOTS(inode->i_sb))
+		/* snapshots enforce ordered data */
+		return 1;
+#endif
 	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
 		return 0;
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
@@ -298,6 +311,11 @@ static inline int ext4_should_writeback_data(struct inode *inode)
 		return 0;
 	if (EXT4_JOURNAL(inode) == NULL)
 		return 1;
+#ifdef CONFIG_EXT4_FS_SNAPSHOT
+	if (EXT4_SNAPSHOTS(inode->i_sb))
+		/* snapshots enforce ordered data */
+		return 0;
+#endif
 	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
 		return 0;
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
@@ -320,6 +338,11 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
 		return 0;
 	if (!S_ISREG(inode->i_mode))
 		return 0;
+#ifdef CONFIG_EXT4_FS_SNAPSHOT
+	if (EXT4_SNAPSHOTS(inode->i_sb))
+		/* XXX: should snapshots support dioread_nolock? */
+		return 0;
+#endif
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return 0;
 	if (ext4_should_journal_data(inode))
@@ -327,4 +350,6 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
 	return 1;
 }
 
+#ifdef CONFIG_EXT4_FS_SNAPSHOT
+#endif
 #endif	/* _EXT4_JBD2_H */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e363f21..7598224 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -18,6 +18,8 @@
  * You should have received a copy of the GNU General Public Licens
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-
+ *
+ * Snapshot move-on-write (MOW), Yongqiang Yang <xiaoqiangnk@gmail.com>, 2011
  */
 
 /*
@@ -43,6 +45,7 @@
 #include <linux/fiemap.h>
 #include "ext4_jbd2.h"
 #include "ext4_extents.h"
+#include "snapshot.h"
 
 #include <trace/events/ext4.h>
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 7b80d54..60b3b19 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -28,6 +28,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "snapshot.h"
 
 /*
  * Called when an inode is released. Note that this is different
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..40ca5bc 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -28,6 +28,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "snapshot.h"
 
 #include <trace/events/ext4.h>
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..9dbd806 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -20,6 +20,8 @@
  *	(jj@sunsite.ms.mff.cuni.cz)
  *
  *  Assorted race fixes, rewrite of ext4_get_block() by Al Viro, 2000
+ *
+ *  Snapshot inode extensions, Amir Goldstein <amir73il@users.sf.net>, 2011
  */
 
 #include <linux/module.h>
@@ -49,6 +51,7 @@
 #include "ext4_extents.h"
 
 #include <trace/events/ext4.h>
+#include "snapshot.h"
 
 #define MPAGE_DA_EXTENT_TAIL 0x01
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 808c554..a8b1254 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -5,6 +5,8 @@
  * Remy Card (card@masi.ibp.fr)
  * Laboratoire MASI - Institut Blaise Pascal
  * Universite Pierre et Marie Curie (Paris VI)
+ *
+ * Snapshot control API, Amir Goldstein <amir73il@users.sf.net>, 2011
  */
 
 #include <linux/fs.h>
@@ -17,6 +19,7 @@
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
+#include "snapshot.h"
 
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 42fbca9..5a930d6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -25,6 +25,7 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <trace/events/ext4.h>
+#include "snapshot.h"
 
 /*
  * MUSTDO:
@@ -2740,6 +2741,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	sbi = EXT4_SB(sb);
 
 	err = -EIO;
+
 	bitmap_bh = ext4_read_block_bitmap(sb, ac->ac_b_ex.fe_group);
 	if (!bitmap_bh)
 		goto out_err;
@@ -2791,6 +2793,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	}
 #endif
 	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,ac->ac_b_ex.fe_len);
+
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 		ext4_free_blks_set(sb, gdp,
@@ -2820,6 +2823,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 	if (err)
 		goto out_err;
+
+
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3c7a06e..93196b6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -39,6 +39,7 @@
 
 #include "xattr.h"
 #include "acl.h"
+#include "snapshot.h"
 
 #include <trace/events/ext4.h>
 /*
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 80bbc9c..ebff8a1 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 
 #include "ext4_jbd2.h"
+#include "snapshot.h"
 
 #define outside(b, first, last)	((b) < (first) || (b) >= (last))
 #define inside(b, first, last)	((b) >= (first) && (b) < (last))
diff --git a/fs/ext4/snapshot.c b/fs/ext4/snapshot.c
new file mode 100644
index 0000000..e8db8ca
--- /dev/null
+++ b/fs/ext4/snapshot.c
@@ -0,0 +1,18 @@
+/*
+ * linux/fs/ext4/snapshot.c
+ *
+ * Written by Amir Goldstein <amir73il@users.sf.net>, 2008
+ *
+ * Copyright (C) 2008-2011 CTERA Networks
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * Ext4 snapshots core functions.
+ */
+
+#include <linux/quotaops.h>
+#include "snapshot.h"
+#include "ext4.h"
+#include "mballoc.h"
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
new file mode 100644
index 0000000..8a60ae1
--- /dev/null
+++ b/fs/ext4/snapshot.h
@@ -0,0 +1,193 @@
+/*
+ * linux/fs/ext4/snapshot.h
+ *
+ * Written by Amir Goldstein <amir73il@users.sf.net>, 2008
+ *
+ * Copyright (C) 2008-2011 CTERA Networks
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * Ext4 snapshot extensions.
+ */
+
+#ifndef _LINUX_EXT4_SNAPSHOT_H
+#define _LINUX_EXT4_SNAPSHOT_H
+
+#include <linux/version.h>
+#include <linux/delay.h>
+#include "ext4.h"
+
+
+/*
+ * use signed 64bit for snapshot image addresses
+ * negative addresses are used to reference snapshot meta blocks
+ */
+#define ext4_snapblk_t long long
+
+/*
+ * We assert that file system block size == page size (on mount time)
+ * and that the first file system block is block 0 (on snapshot create).
+ * Snapshot inode direct blocks are reserved for snapshot meta blocks.
+ * Snapshot inode single indirect blocks are not used.
+ * Snapshot image starts at the first double indirect block, so all blocks in
+ * Snapshot image block group blocks are mapped by a single DIND block:
+ * 4k: 32k blocks_per_group = 32 IND (4k) blocks = 32 groups per DIND
+ * 8k: 64k blocks_per_group = 32 IND (8k) blocks = 64 groups per DIND
+ * 16k: 128k blocks_per_group = 32 IND (16k) blocks = 128 groups per DIND
+ */
+#define SNAPSHOT_BLOCK_SIZE		PAGE_SIZE
+#define SNAPSHOT_BLOCK_SIZE_BITS	PAGE_SHIFT
+#define	SNAPSHOT_ADDR_PER_BLOCK		(SNAPSHOT_BLOCK_SIZE / sizeof(__u32))
+#define SNAPSHOT_ADDR_PER_BLOCK_BITS	(SNAPSHOT_BLOCK_SIZE_BITS - 2)
+#define SNAPSHOT_DIR_BLOCKS		EXT4_NDIR_BLOCKS
+#define SNAPSHOT_IND_BLOCKS		SNAPSHOT_ADDR_PER_BLOCK
+
+#define SNAPSHOT_BLOCKS_PER_GROUP_BITS	(SNAPSHOT_BLOCK_SIZE_BITS + 3)
+#define SNAPSHOT_BLOCKS_PER_GROUP				\
+	(1<<SNAPSHOT_BLOCKS_PER_GROUP_BITS) /* 8*PAGE_SIZE */
+#define SNAPSHOT_BLOCK_GROUP(block)				\
+	((block)>>SNAPSHOT_BLOCKS_PER_GROUP_BITS)
+#define SNAPSHOT_BLOCK_GROUP_OFFSET(block)			\
+	((block)&(SNAPSHOT_BLOCKS_PER_GROUP-1))
+#define SNAPSHOT_BLOCK_TUPLE(block)				\
+	(ext4_fsblk_t)SNAPSHOT_BLOCK_GROUP_OFFSET(block),	\
+	(ext4_fsblk_t)SNAPSHOT_BLOCK_GROUP(block)
+#define SNAPSHOT_IND_PER_BLOCK_GROUP_BITS			\
+	(SNAPSHOT_BLOCKS_PER_GROUP_BITS-SNAPSHOT_ADDR_PER_BLOCK_BITS)
+#define SNAPSHOT_IND_PER_BLOCK_GROUP				\
+	(1<<SNAPSHOT_IND_PER_BLOCK_GROUP_BITS) /* 32 */
+#define SNAPSHOT_DIND_BLOCK_GROUPS_BITS				\
+	(SNAPSHOT_ADDR_PER_BLOCK_BITS-SNAPSHOT_IND_PER_BLOCK_GROUP_BITS)
+#define SNAPSHOT_DIND_BLOCK_GROUPS				\
+	(1<<SNAPSHOT_DIND_BLOCK_GROUPS_BITS)
+
+#define SNAPSHOT_BLOCK_OFFSET					\
+	(SNAPSHOT_DIR_BLOCKS+SNAPSHOT_IND_BLOCKS)
+#define SNAPSHOT_BLOCK(iblock)					\
+	((ext4_snapblk_t)(iblock) - SNAPSHOT_BLOCK_OFFSET)
+#define SNAPSHOT_IBLOCK(block)					\
+	(ext4_fsblk_t)((block) + SNAPSHOT_BLOCK_OFFSET)
+
+
+
+#ifdef CONFIG_EXT4_FS_SNAPSHOT
+#define EXT4_SNAPSHOT_VERSION "ext4 snapshot v1.0.13-7 (1-Jun-2010)"
+
+#define SNAPSHOT_BYTES_OFFSET					\
+	(SNAPSHOT_BLOCK_OFFSET << SNAPSHOT_BLOCK_SIZE_BITS)
+#define SNAPSHOT_ISIZE(size)					\
+	((size) + SNAPSHOT_BYTES_OFFSET)
+/* Snapshot block device size is recorded in i_disksize */
+#define SNAPSHOT_SET_SIZE(inode, size)				\
+	(EXT4_I(inode)->i_disksize = SNAPSHOT_ISIZE(size))
+#define SNAPSHOT_SIZE(inode)					\
+	(EXT4_I(inode)->i_disksize - SNAPSHOT_BYTES_OFFSET)
+#define SNAPSHOT_SET_BLOCKS(inode, blocks)			\
+	SNAPSHOT_SET_SIZE((inode),				\
+			(loff_t)(blocks) << SNAPSHOT_BLOCK_SIZE_BITS)
+#define SNAPSHOT_BLOCKS(inode)					\
+	(ext4_fsblk_t)(SNAPSHOT_SIZE(inode) >> SNAPSHOT_BLOCK_SIZE_BITS)
+/* Snapshot shrink/merge/clean progress is exported via i_size */
+#define SNAPSHOT_PROGRESS(inode)				\
+	(ext4_fsblk_t)((inode)->i_size >> SNAPSHOT_BLOCK_SIZE_BITS)
+#define SNAPSHOT_SET_ENABLED(inode)				\
+	i_size_write((inode), SNAPSHOT_SIZE(inode))
+#define SNAPSHOT_SET_PROGRESS(inode, blocks)			\
+	snapshot_size_extend((inode), (blocks))
+/* Disabled/deleted snapshot i_size is 1 block, to allow read of super block */
+#define SNAPSHOT_SET_DISABLED(inode)				\
+	snapshot_size_truncate((inode), 1)
+/* Removed snapshot i_size and i_disksize are 0, since all blocks were freed */
+#define SNAPSHOT_SET_REMOVED(inode)				\
+	do {							\
+		EXT4_I(inode)->i_disksize = 0;			\
+		snapshot_size_truncate((inode), 0);		\
+	} while (0)
+
+static inline void snapshot_size_extend(struct inode *inode,
+			ext4_fsblk_t blocks)
+{
+	i_size_write((inode), (loff_t)(blocks) << SNAPSHOT_BLOCK_SIZE_BITS);
+}
+
+static inline void snapshot_size_truncate(struct inode *inode,
+			ext4_fsblk_t blocks)
+{
+	loff_t i_size = (loff_t)blocks << SNAPSHOT_BLOCK_SIZE_BITS;
+
+	i_size_write(inode, i_size);
+	truncate_inode_pages(&inode->i_data, i_size);
+}
+
+/* Is ext4 configured for snapshots support? */
+static inline int EXT4_SNAPSHOTS(struct super_block *sb)
+{
+	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT);
+}
+
+#define ext4_snapshot_cow(handle, inode, block, bh, cow) 0
+
+#define ext4_snapshot_move(handle, inode, block, pcount, move) (0)
+
+/*
+ * Block access functions
+ */
+
+
+
+/* snapshot_ctl.c */
+
+
+static inline int init_ext4_snapshot(void)
+{
+	return 0;
+}
+
+static inline void exit_ext4_snapshot(void)
+{
+}
+
+
+
+
+
+#else /* CONFIG_EXT4_FS_SNAPSHOT */
+
+/* Snapshot NOP macros */
+#define EXT4_SNAPSHOTS(sb) (0)
+#define SNAPMAP_ISCOW(cmd)	(0)
+#define SNAPMAP_ISMOVE(cmd)     (0)
+#define SNAPMAP_ISSYNC(cmd)	(0)
+#define IS_COWING(handle)	(0)
+
+#define ext4_snapshot_load(sb, es, ro) (0)
+#define ext4_snapshot_destroy(sb)
+#define init_ext4_snapshot() (0)
+#define exit_ext4_snapshot()
+#define ext4_snapshot_active(sbi) (0)
+#define ext4_snapshot_file(inode) (0)
+#define ext4_snapshot_should_move_data(inode) (0)
+#define ext4_snapshot_test_excluded(handle, inode, block_to_free, count) (0)
+#define ext4_snapshot_list(inode) (0)
+#define ext4_snapshot_get_flags(ei, filp)
+#define ext4_snapshot_set_flags(handle, inode, flags) (0)
+#define ext4_snapshot_take(inode) (0)
+#define ext4_snapshot_update(inode_i_sb, cleanup, zero) (0)
+#define ext4_snapshot_has_active(sb) (NULL)
+#define ext4_snapshot_get_bitmap_access(handle, sb, grp, bh) (0)
+#define ext4_snapshot_get_write_access(handle, inode, bh) (0)
+#define ext4_snapshot_get_create_access(handle, bh) (0)
+#define ext4_snapshot_excluded(ac_inode) (0)
+#define ext4_snapshot_get_delete_access(handle, inode, block, pcount) (0)
+
+#define ext4_snapshot_get_move_access(handle, inode, block, pcount, move) (0)
+#define ext4_snapshot_start_pending_cow(sbh)
+#define ext4_snapshot_end_pending_cow(sbh)
+#define ext4_snapshot_is_active(inode)		(0)
+#define ext4_snapshot_mow_in_tid(inode)		(1)
+
+#endif /* CONFIG_EXT4_FS_SNAPSHOT */
+#endif	/* _LINUX_EXT4_SNAPSHOT_H */
diff --git a/fs/ext4/snapshot_buffer.c b/fs/ext4/snapshot_buffer.c
new file mode 100644
index 0000000..acea9a3
--- /dev/null
+++ b/fs/ext4/snapshot_buffer.c
@@ -0,0 +1,238 @@
+/*
+ *  linux/fs/ext4/snapshot_buffer.c
+ *
+ *  Tracked buffer read implementation for ext4 snapshots
+ *  by Amir Goldstein <amir73il@users.sf.net>, 2008
+ *
+ *  Copyright (C) 2008-2011 CTERA Networks
+ *
+ *  from
+ *
+ *  linux/fs/buffer.c
+ *
+ *  Copyright (C) 1991, 1992, 2002  Linus Torvalds
+ */
+
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/percpu.h>
+#include <linux/slab.h>
+#include <linux/capability.h>
+#include <linux/blkdev.h>
+#include <linux/file.h>
+#include <linux/quotaops.h>
+#include <linux/highmem.h>
+#include <linux/module.h>
+#include <linux/writeback.h>
+#include <linux/hash.h>
+#include <linux/suspend.h>
+#include <linux/buffer_head.h>
+#include <linux/task_io_accounting_ops.h>
+#include <linux/bio.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/bitops.h>
+#include <linux/mpage.h>
+#include <linux/bit_spinlock.h>
+#include "snapshot.h"
+
+static int quiet_error(struct buffer_head *bh)
+{
+	if (printk_ratelimit())
+		return 0;
+	return 1;
+}
+
+
+static void buffer_io_error(struct buffer_head *bh)
+{
+	char b[BDEVNAME_SIZE];
+	printk(KERN_ERR "Buffer I/O error on device %s, logical block %llu\n",
+			bdevname(bh->b_bdev, b),
+			(unsigned long long)bh->b_blocknr);
+}
+
+/*
+ * I/O completion handler for ext4_read_full_page() - pages
+ * which come unlocked at the end of I/O.
+ */
+static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
+{
+	unsigned long flags;
+	struct buffer_head *first;
+	struct buffer_head *tmp;
+	struct page *page;
+	int page_uptodate = 1;
+
+	BUG_ON(!buffer_async_read(bh));
+
+	page = bh->b_page;
+	if (uptodate) {
+		set_buffer_uptodate(bh);
+	} else {
+		clear_buffer_uptodate(bh);
+		if (!quiet_error(bh))
+			buffer_io_error(bh);
+		SetPageError(page);
+	}
+
+	/*
+	 * Be _very_ careful from here on. Bad things can happen if
+	 * two buffer heads end IO at almost the same time and both
+	 * decide that the page is now completely done.
+	 */
+	first = page_buffers(page);
+	local_irq_save(flags);
+	bit_spin_lock(BH_Uptodate_Lock, &first->b_state);
+	clear_buffer_async_read(bh);
+	unlock_buffer(bh);
+	tmp = bh;
+	do {
+		if (!buffer_uptodate(tmp))
+			page_uptodate = 0;
+		if (buffer_async_read(tmp)) {
+			BUG_ON(!buffer_locked(tmp));
+			goto still_busy;
+		}
+		tmp = tmp->b_this_page;
+	} while (tmp != bh);
+	bit_spin_unlock(BH_Uptodate_Lock, &first->b_state);
+	local_irq_restore(flags);
+
+	/*
+	 * If none of the buffers had errors and they are all
+	 * uptodate then we can set the page uptodate.
+	 */
+	if (page_uptodate && !PageError(page))
+		SetPageUptodate(page);
+	unlock_page(page);
+	return;
+
+still_busy:
+	bit_spin_unlock(BH_Uptodate_Lock, &first->b_state);
+	local_irq_restore(flags);
+	return;
+}
+
+/*
+ * If a page's buffers are under async readin (end_buffer_async_read
+ * completion) then there is a possibility that another thread of
+ * control could lock one of the buffers after it has completed
+ * but while some of the other buffers have not completed.  This
+ * locked buffer would confuse end_buffer_async_read() into not unlocking
+ * the page.  So the absence of BH_Async_Read tells end_buffer_async_read()
+ * that this buffer is not under async I/O.
+ *
+ * The page comes unlocked when it has no locked buffer_async buffers
+ * left.
+ *
+ * PageLocked prevents anyone starting new async I/O reads any of
+ * the buffers.
+ *
+ * PageWriteback is used to prevent simultaneous writeout of the same
+ * page.
+ *
+ * PageLocked prevents anyone from starting writeback of a page which is
+ * under read I/O (PageWriteback is only ever set against a locked page).
+ */
+static void mark_buffer_async_read(struct buffer_head *bh)
+{
+	bh->b_end_io = end_buffer_async_read;
+	set_buffer_async_read(bh);
+}
+
+/*
+ * Generic "read page" function for block devices that have the normal
+ * get_block functionality. This is most of the block device filesystems.
+ * Reads the page asynchronously --- the unlock_buffer() and
+ * set/clear_buffer_uptodate() functions propagate buffer state into the
+ * page struct once IO has completed.
+ */
+int ext4_read_full_page(struct page *page, get_block_t *get_block)
+{
+	struct inode *inode = page->mapping->host;
+	sector_t iblock, lblock;
+	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
+	unsigned int blocksize;
+	int nr, i;
+	int fully_mapped = 1;
+
+	BUG_ON(!PageLocked(page));
+	blocksize = 1 << inode->i_blkbits;
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, blocksize, 0);
+	head = page_buffers(page);
+
+	iblock = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	lblock = (i_size_read(inode)+blocksize-1) >> inode->i_blkbits;
+	bh = head;
+	nr = 0;
+	i = 0;
+
+	do {
+		if (buffer_uptodate(bh))
+			continue;
+
+		if (!buffer_mapped(bh)) {
+			int err = 0;
+
+			fully_mapped = 0;
+			if (iblock < lblock) {
+				WARN_ON(bh->b_size != blocksize);
+				err = get_block(inode, iblock, bh, 0);
+				if (err)
+					SetPageError(page);
+			}
+			if (!buffer_mapped(bh)) {
+				zero_user(page, i * blocksize, blocksize);
+				if (!err)
+					set_buffer_uptodate(bh);
+				continue;
+			}
+			/*
+			 * get_block() might have updated the buffer
+			 * synchronously
+			 */
+			if (buffer_uptodate(bh))
+				continue;
+		}
+		arr[nr++] = bh;
+	} while (i++, iblock++, (bh = bh->b_this_page) != head);
+
+	if (fully_mapped)
+		SetPageMappedToDisk(page);
+
+	if (!nr) {
+		/*
+		 * All buffers are uptodate - we can set the page uptodate
+		 * as well. But not if get_block() returned an error.
+		 */
+		if (!PageError(page))
+			SetPageUptodate(page);
+		unlock_page(page);
+		return 0;
+	}
+
+	/* Stage two: lock the buffers */
+	for (i = 0; i < nr; i++) {
+		bh = arr[i];
+		lock_buffer(bh);
+		mark_buffer_async_read(bh);
+	}
+
+	/*
+	 * Stage 3: start the IO.  Check for uptodateness
+	 * inside the buffer lock in case another process reading
+	 * the underlying blockdev brought it uptodate (the sct fix).
+	 */
+	for (i = 0; i < nr; i++) {
+		bh = arr[i];
+		if (buffer_uptodate(bh))
+			end_buffer_async_read(bh, 1);
+		else
+			submit_bh(READ, bh);
+	}
+	return 0;
+}
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
new file mode 100644
index 0000000..201ef20
--- /dev/null
+++ b/fs/ext4/snapshot_ctl.c
@@ -0,0 +1,22 @@
+/*
+ * linux/fs/ext4/snapshot_ctl.c
+ *
+ * Written by Amir Goldstein <amir73il@users.sf.net>, 2008
+ *
+ * Copyright (C) 2008-2011 CTERA Networks
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * Ext4 snapshots control functions.
+ */
+
+#include <linux/statfs.h>
+#include "ext4_jbd2.h"
+#include "snapshot.h"
+#define ext4_snapshot_reset_bitmap_cache(sb, init) 0
+
+/*
+ * Snapshot constructor/destructor
+ */
diff --git a/fs/ext4/snapshot_debug.c b/fs/ext4/snapshot_debug.c
new file mode 100644
index 0000000..e69de29
diff --git a/fs/ext4/snapshot_debug.h b/fs/ext4/snapshot_debug.h
new file mode 100644
index 0000000..e69de29
diff --git a/fs/ext4/snapshot_inode.c b/fs/ext4/snapshot_inode.c
new file mode 100644
index 0000000..2de017a
--- /dev/null
+++ b/fs/ext4/snapshot_inode.c
@@ -0,0 +1,42 @@
+/*
+ * linux/fs/ext4/snapshot_inode.c
+ *
+ * Written by Amir Goldstein <amir73il@users.sf.net>, 2008
+ *
+ * Copyright (C) 2008-2011 CTERA Networks
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * Ext4 snapshots inode functions.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/time.h>
+#include <linux/jbd2.h>
+#include <linux/highuid.h>
+#include <linux/pagemap.h>
+#include <linux/quotaops.h>
+#include <linux/string.h>
+#include <linux/buffer_head.h>
+#include <linux/writeback.h>
+#include <linux/pagevec.h>
+#include <linux/mpage.h>
+#include <linux/namei.h>
+#include <linux/uio.h>
+#include <linux/bio.h>
+#include <linux/workqueue.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include "ext4_jbd2.h"
+#include "xattr.h"
+#include "acl.h"
+#include "ext4_extents.h"
+
+#include <trace/events/ext4.h>
+#include "snapshot.h"
+#ifdef CONFIG_EXT4_DEBUG
+#endif
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb22783..61e9173 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -48,6 +48,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "snapshot.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
@@ -2625,6 +2626,24 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 			return 0;
 		}
 	}
+	/* Enforce snapshots requirements: */
+	if (EXT4_SNAPSHOTS(sb)) {
+		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+					EXT4_FEATURE_INCOMPAT_META_BG|
+					EXT4_FEATURE_INCOMPAT_64BIT)) {
+			ext4_msg(sb, KERN_ERR,
+				"has_snapshot feature cannot be mixed with "
+				"features: meta_bg, 64bit");
+			return 0;
+		}
+		if (EXT4_TEST_FLAGS(sb, EXT4_FLAGS_IS_SNAPSHOT)) {
+			ext4_msg(sb, KERN_ERR,
+				"A snapshot image must be mounted read-only. "
+				"If this is an exported snapshot image, you "
+				"must run fsck -xy to make it writable.");
+			return 0;
+		}
+	}
 	return 1;
 }
 
@@ -3235,6 +3254,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
 
+	/* Enforce snapshots blocksize == pagesize */
+	if (EXT4_SNAPSHOTS(sb) && blocksize != PAGE_SIZE) {
+		ext4_msg(sb, KERN_ERR,
+				"snapshots require that filesystem blocksize "
+				"(%d) be equal to system page size (%lu)",
+				blocksize, PAGE_SIZE);
+		goto failed_mount;
+	}
+
 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
 	    blocksize > EXT4_MAX_BLOCK_SIZE) {
 		ext4_msg(sb, KERN_ERR,
@@ -3592,6 +3620,15 @@ no_journal:
 		goto failed_mount_wq;
 	}
 
+	/* Enforce journal ordered mode with snapshots */
+	if (EXT4_SNAPSHOTS(sb) && !(sb->s_flags & MS_RDONLY) &&
+		(!EXT4_SB(sb)->s_journal ||
+		 test_opt(sb, DATA_FLAGS) != EXT4_MOUNT_ORDERED_DATA)) {
+		ext4_msg(sb, KERN_ERR,
+				"snapshots require journal ordered mode");
+		goto failed_mount4;
+	}
+
 	/*
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
@@ -4959,10 +4996,15 @@ static int __init ext4_init_fs(void)
 	err = register_filesystem(&ext4_fs_type);
 	if (err)
 		goto out;
+	err = init_ext4_snapshot();
+	if (err)
+		goto out_fs;
 
 	ext4_li_info = NULL;
 	mutex_init(&ext4_li_mtx);
 	return 0;
+out_fs:
+	unregister_filesystem(&ext4_fs_type);
 out:
 	unregister_as_ext2();
 	unregister_as_ext3();
@@ -4986,6 +5028,7 @@ out7:
 
 static void __exit ext4_exit_fs(void)
 {
+	exit_ext4_snapshot();
 	ext4_destroy_lazyinit_thread();
 	unregister_as_ext2();
 	unregister_as_ext3();
-- 
1.7.4.1

