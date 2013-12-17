From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v3 3/3] ext4: Add XIP functionality
Date: Tue, 17 Dec 2013 14:18:28 -0500
Message-ID: <8c17a9e26cda6675e107bec05be7606c6a3de112.1387307259.git.matthew.r.wilcox@intel.com>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51406 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3LQTSk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Dec 2013 14:18:40 -0500
In-Reply-To: <cover.1387307259.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387307259.git.matthew.r.wilcox@intel.com>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46rom: Ross Zwisler <ross.zwisler@linux.intel.com>

This is a port of the XIP functionality found in the current version of
ext2.  This patch set is intended to achieve feature parity with XIP in
ext2 rather than non-XIP in ext4.=C2=A0 In particular, it lacks support=
 for
splice and AIO.=C2=A0 We'll be submitting patches in the future to add =
that
functionality, but we think this is a good start.

The motivation behind this work is that we believe that the XIP feature
will begin to find new uses as various persistent memory devices and
technologies come on to the market.  Having direct, byte-addressable
access to persistent memory without having an additional copy in the
page cache can be a win in terms of I/O latency and overall memory
usage.

This patch applies cleanly to v3.13-rc2, and was tested using brd as ou=
r
block driver.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 Documentation/filesystems/ext4.txt |  2 +
 Documentation/filesystems/xip.txt  |  3 ++
 fs/Kconfig                         |  2 +-
 fs/ext4/Kconfig                    | 11 +++++
 fs/ext4/Makefile                   |  1 +
 fs/ext4/ext4.h                     |  4 +-
 fs/ext4/file.c                     | 17 ++++++++
 fs/ext4/inode.c                    | 86 +++++++++++++++++++++++++++---=
--------
 fs/ext4/namei.c                    | 11 ++++-
 fs/ext4/super.c                    | 36 +++++++++++++++-
 fs/ext4/xip.c                      | 78 ++++++++++++++++++++++++++++++=
++++
 fs/ext4/xip.h                      | 24 +++++++++++
 12 files changed, 244 insertions(+), 31 deletions(-)
 create mode 100644 fs/ext4/xip.c
 create mode 100644 fs/ext4/xip.h

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesys=
tems/ext4.txt
index 919a329..c32c398 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -386,6 +386,8 @@ max_dir_size_kb=3Dn	This limits the size of directo=
ries so that any
 i_version		Enable 64-bit inode version support. This option is
 			off by default.
=20
+xip			Use execute in place (no caching) if possible.
+
 Data Mode
 =3D=3D=3D=3D=3D=3D=3D=3D=3D
 There are 3 different data modes:
diff --git a/Documentation/filesystems/xip.txt b/Documentation/filesyst=
ems/xip.txt
index 0466ee5..3df2d36 100644
--- a/Documentation/filesystems/xip.txt
+++ b/Documentation/filesystems/xip.txt
@@ -37,6 +37,8 @@ alternative, memory technology devices can be used fo=
r this.
=20
 The block device operation is optional, these block devices support it=
 as of
 today:
+- axonram: Axon DDR2 device driver
+- brd: Ram backed block device driver
 - dcssblk: s390 dcss block device driver
=20
 An address space operation named get_xip_mem is used to retrieve refer=
ences
@@ -49,6 +51,7 @@ This address space operation is mutually exclusive wi=
th readpage&writepage that
 do page cache read/write operations.
 The following filesystems support it as of today:
 - ext2: the second extended filesystem, see Documentation/filesystems/=
ext2.txt
+- ext4: the fourth extended filesystem, see Documentation/filesystems/=
ext4.txt
=20
 A set of file operations that do utilize get_xip_page can be found in
 mm/filemap_xip.c . The following file operation implementations are pr=
ovided:
diff --git a/fs/Kconfig b/fs/Kconfig
index c229f82..595cc00 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -17,7 +17,7 @@ source "fs/ext4/Kconfig"
 config FS_XIP
 # execute in place
 	bool
-	depends on EXT2_FS_XIP
+	depends on EXT2_FS_XIP || EXT4_FS_XIP
 	default y
=20
 source "fs/jbd/Kconfig"
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index efea5d5..62952cb 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -73,3 +73,14 @@ config EXT4_DEBUG
 	  If you select Y here, then you will be able to turn on debugging
 	  with a command such as:
 		echo 1 > /sys/module/ext4/parameters/mballoc_debug
+
+config EXT4_FS_XIP
+	bool "Ext4 execute in place support"
+	depends on EXT4_FS && MMU
+	help
+	  Execute in place can be used on memory-backed block devices. If you
+	  enable this option, you can select to mount block devices which are
+	  capable of this feature without using the page cache.
+
+	  If you do not use a block device that is capable of using this,
+	  or if unsure, say N.
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 0310fec..3f1ec56 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -12,3 +12,4 @@ ext4-y	:=3D balloc.o bitmap.o dir.o file.o fsync.o ia=
lloc.o inode.o page-io.o \
=20
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+=3D acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+=3D xattr_security.o
+ext4-$(CONFIG_EXT4_FS_XIP)	 	+=3D xip.o
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e618503..d083ad9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -954,6 +954,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_ERRORS_MASK		0x00070
 #define EXT4_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
 #define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
+#define EXT4_MOUNT_XIP			0x00200 /* Execute in place */
 #define EXT4_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
 #define EXT4_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
 #define EXT4_MOUNT_ORDERED_DATA		0x00800	/* Flush data before commit *=
/
@@ -2121,8 +2122,6 @@ extern int ext4_writepage_trans_blocks(struct ino=
de *);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
-extern int ext4_block_zero_page_range(handle_t *handle,
-		struct address_space *mapping, loff_t from, loff_t length);
 extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *in=
ode,
 			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fau=
lt *vmf);
@@ -2571,6 +2570,7 @@ extern const struct file_operations ext4_dir_oper=
ations;
 /* file.c */
 extern const struct inode_operations ext4_file_inode_operations;
 extern const struct file_operations ext4_file_operations;
+extern const struct file_operations ext4_xip_file_operations;
 extern loff_t ext4_llseek(struct file *file, loff_t offset, int origin=
);
 extern void ext4_unwritten_wait(struct inode *inode);
=20
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3da2194..b9499b2 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -609,6 +609,23 @@ const struct file_operations ext4_file_operations =
=3D {
 	.fallocate	=3D ext4_fallocate,
 };
=20
+#ifdef CONFIG_EXT4_FS_XIP
+const struct file_operations ext4_xip_file_operations =3D {
+	.llseek		=3D ext4_llseek,
+	.read		=3D xip_file_read,
+	.write		=3D xip_file_write,
+	.unlocked_ioctl =3D ext4_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	=3D ext4_compat_ioctl,
+#endif
+	.mmap		=3D xip_file_mmap,
+	.open		=3D ext4_file_open,
+	.release	=3D ext4_release_file,
+	.fsync		=3D ext4_sync_file,
+	.fallocate	=3D ext4_fallocate,
+};
+#endif
+
 const struct inode_operations ext4_file_inode_operations =3D {
 	.setattr	=3D ext4_setattr,
 	.getattr	=3D ext4_getattr,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0757634..7b50832 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -43,6 +43,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "truncate.h"
+#include "xip.h"
=20
 #include <trace/events/ext4.h>
=20
@@ -663,6 +664,23 @@ found:
 			WARN_ON(1);
 		}
=20
+		if (ext4_use_xip(inode->i_sb)) {
+			ext4_fsblk_t fs_blk;
+
+			for (fs_blk =3D map->m_pblk;
+			     fs_blk < map->m_pblk + map->m_len; fs_blk++) {
+				/*
+				 * we need to clear the block
+				 */
+				ret =3D ext4_clear_xip_target(inode, fs_blk);
+
+				if (ret) {
+					retval =3D ret;
+					goto has_zeroout;
+				}
+			}
+		}
+
 		/*
 		 * If the extent has been zeroed out, we don't need to update
 		 * extent status tree.
@@ -3270,6 +3288,11 @@ static const struct address_space_operations ext=
4_aops =3D {
 	.error_remove_page	=3D generic_error_remove_page,
 };
=20
+const struct address_space_operations ext4_xip_aops =3D {
+	.bmap			=3D ext4_bmap,
+	.get_xip_mem		=3D ext4_get_xip_mem,
+};
+
 static const struct address_space_operations ext4_journalled_aops =3D =
{
 	.readpage		=3D ext4_readpage,
 	.readpages		=3D ext4_readpages,
@@ -3317,40 +3340,22 @@ void ext4_set_aops(struct inode *inode)
 	default:
 		BUG();
 	}
-	if (test_opt(inode->i_sb, DELALLOC))
+	if (ext4_use_xip(inode->i_sb))
+		inode->i_mapping->a_ops =3D &ext4_xip_aops;
+	else if (test_opt(inode->i_sb, DELALLOC))
 		inode->i_mapping->a_ops =3D &ext4_da_aops;
 	else
 		inode->i_mapping->a_ops =3D &ext4_aops;
 }
=20
 /*
- * ext4_block_truncate_page() zeroes out a mapping from file offset `f=
rom'
- * up to the end of the block which corresponds to `from'.
- * This required during truncate. We need to physically zero the tail =
end
- * of that block so it doesn't yield old data if the file is later gro=
wn.
- */
-int ext4_block_truncate_page(handle_t *handle,
-		struct address_space *mapping, loff_t from)
-{
-	unsigned offset =3D from & (PAGE_CACHE_SIZE-1);
-	unsigned length;
-	unsigned blocksize;
-	struct inode *inode =3D mapping->host;
-
-	blocksize =3D inode->i_sb->s_blocksize;
-	length =3D blocksize - (offset & (blocksize - 1));
-
-	return ext4_block_zero_page_range(handle, mapping, from, length);
-}
-
-/*
- * ext4_block_zero_page_range() zeros out a mapping of length 'length'
+ * __ext4_block_zero_page_range() zeros out a mapping of length 'lengt=
h'
  * starting from file offset 'from'.  The range to be zero'd must
  * be contained with in one block.  If the specified range exceeds
  * the end of the block it will be shortened to end of the block
  * that cooresponds to 'from'
  */
-int ext4_block_zero_page_range(handle_t *handle,
+static int __ext4_block_zero_page_range(handle_t *handle,
 		struct address_space *mapping, loff_t from, loff_t length)
 {
 	ext4_fsblk_t index =3D from >> PAGE_CACHE_SHIFT;
@@ -3440,6 +3445,34 @@ unlock:
 	return err;
 }
=20
+static int ext4_block_zero_page_range(handle_t *handle,
+		struct address_space *mapping, loff_t from, loff_t length)
+{
+	if (mapping_is_xip(mapping))
+		return xip_zero_page_range(mapping, from, length);
+	return __ext4_block_zero_page_range(handle, mapping, from, length);
+}
+
+/*
+ * ext4_block_truncate_page() zeroes out a mapping from file offset `f=
rom'
+ * up to the end of the block which corresponds to `from'.
+ * This required during truncate. We need to physically zero the tail =
end
+ * of that block so it doesn't yield old data if the file is later gro=
wn.
+ */
+int ext4_block_truncate_page(handle_t *handle,
+		struct address_space *mapping, loff_t from)
+{
+	unsigned offset =3D from & (PAGE_CACHE_SIZE-1);
+	unsigned length;
+	unsigned blocksize;
+	struct inode *inode =3D mapping->host;
+
+	blocksize =3D inode->i_sb->s_blocksize;
+	length =3D blocksize - (offset & (blocksize - 1));
+
+	return ext4_block_zero_page_range(handle, mapping, from, length);
+}
+
 int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t length)
 {
@@ -4201,7 +4234,10 @@ struct inode *ext4_iget(struct super_block *sb, =
unsigned long ino)
=20
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op =3D &ext4_file_inode_operations;
-		inode->i_fop =3D &ext4_file_operations;
+		if (ext4_use_xip(inode->i_sb))
+			inode->i_fop =3D &ext4_xip_file_operations;
+		else
+			inode->i_fop =3D &ext4_file_operations;
 		ext4_set_aops(inode);
 	} else if (S_ISDIR(inode->i_mode)) {
 		inode->i_op =3D &ext4_dir_inode_operations;
@@ -4653,7 +4689,7 @@ int ext4_setattr(struct dentry *dentry, struct ia=
ttr *attr)
 		 * Truncate pagecache after we've waited for commit
 		 * in data=3Djournal mode to make pages freeable.
 		 */
-			truncate_pagecache(inode, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 	}
 	/*
 	 * We want to call ext4_truncate() even if attr->ia_size =3D=3D
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5a0408d..20a9cf8 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -39,6 +39,7 @@
=20
 #include "xattr.h"
 #include "acl.h"
+#include "xip.h"
=20
 #include <trace/events/ext4.h>
 /*
@@ -2250,7 +2251,10 @@ retry:
 	err =3D PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op =3D &ext4_file_inode_operations;
-		inode->i_fop =3D &ext4_file_operations;
+		if (ext4_use_xip(inode->i_sb))
+			inode->i_fop =3D &ext4_xip_file_operations;
+		else
+			inode->i_fop =3D &ext4_file_operations;
 		ext4_set_aops(inode);
 		err =3D ext4_add_nondir(handle, dentry, inode);
 		if (!err && IS_DIRSYNC(dir))
@@ -2314,7 +2318,10 @@ retry:
 	err =3D PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op =3D &ext4_file_inode_operations;
-		inode->i_fop =3D &ext4_file_operations;
+		if (ext4_use_xip(inode->i_sb))
+			inode->i_fop =3D &ext4_xip_file_operations;
+		else
+			inode->i_fop =3D &ext4_file_operations;
 		ext4_set_aops(inode);
 		d_tmpfile(dentry, inode);
 		err =3D ext4_orphan_add(handle, inode);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c977f4e..144dfd5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -50,6 +50,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "xip.h"
=20
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
@@ -1162,7 +1163,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
-	Opt_max_dir_size_kb,
+	Opt_max_dir_size_kb, Opt_xip,
 };
=20
 static const match_table_t tokens =3D {
@@ -1243,6 +1244,7 @@ static const match_table_t tokens =3D {
 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
 	{Opt_removed, "noreservation"}, /* mount option from ext2/3 */
 	{Opt_removed, "journal=3D%u"},	/* mount option from ext2/3 */
+	{Opt_xip, "xip"},
 	{Opt_err, NULL},
 };
=20
@@ -1436,6 +1438,7 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
+	{Opt_xip, EXT4_MOUNT_XIP, MOPT_SET},
 	{Opt_err, 0, 0}
 };
=20
@@ -1638,6 +1641,11 @@ static int handle_mount_opt(struct super_block *=
sb, char *opt, int token,
 		}
 		sbi->s_jquota_fmt =3D m->mount_opt;
 #endif
+#ifndef CONFIG_EXT4_FS_XIP
+	} else if (token =3D=3D Opt_xip) {
+		ext4_msg(sb, KERN_INFO, "xip option not supported");
+		return -1;
+#endif
 	} else {
 		if (!args->from)
 			arg =3D 1;
@@ -3553,11 +3561,23 @@ static int ext4_fill_super(struct super_block *=
sb, void *data, int silent)
 		}
 		if (test_opt(sb, DELALLOC))
 			clear_opt(sb, DELALLOC);
+		if (test_opt(sb, XIP)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "both data=3Djournal and xip");
+			goto failed_mount;
+		}
 	}
=20
 	sb->s_flags =3D (sb->s_flags & ~MS_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
=20
+	if ((sbi->s_mount_opt & EXT4_MOUNT_XIP) &&
+	    !sb->s_bdev->bd_disk->fops->direct_access) {
+		ext4_msg(sb, KERN_ERR, "can't mount with xip - "
+				       "not supported by bdev");
+		goto failed_mount;
+	}
+
 	if (le32_to_cpu(es->s_rev_level) =3D=3D EXT4_GOOD_OLD_REV &&
 	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT4_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
@@ -3604,6 +3624,12 @@ static int ext4_fill_super(struct super_block *s=
b, void *data, int silent)
 		goto failed_mount;
 	}
=20
+	if (ext4_use_xip(sb) && blocksize !=3D PAGE_SIZE) {
+		ext4_msg(sb, KERN_ERR, "Unsupported blocksize %d for xip",
+				blocksize);
+		goto failed_mount;
+	}
+
 	if (sb->s_blocksize !=3D blocksize) {
 		/* Validate the filesystem blocksize */
 		if (!sb_set_blocksize(sb, blocksize)) {
@@ -4740,6 +4766,7 @@ static int ext4_remount(struct super_block *sb, i=
nt *flags, char *data)
 	struct ext4_super_block *es;
 	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
 	unsigned long old_sb_flags;
+	unsigned long old_mount_opt =3D sbi->s_mount_opt;
 	struct ext4_mount_options old_opts;
 	int enable_quota =3D 0;
 	ext4_group_t g;
@@ -4808,6 +4835,13 @@ static int ext4_remount(struct super_block *sb, =
int *flags, char *data)
=20
 	es =3D sbi->s_es;
=20
+	if ((sbi->s_mount_opt ^ old_mount_opt) & EXT4_MOUNT_XIP) {
+		ext4_msg(sb, KERN_WARNING, "warning: refusing change of "
+			 "xip flag while remounting");
+		sbi->s_mount_opt &=3D ~EXT4_MOUNT_XIP;
+		sbi->s_mount_opt |=3D old_mount_opt & EXT4_MOUNT_XIP;
+	}
+
 	if (sbi->s_journal) {
 		ext4_init_journal_params(sb, sbi->s_journal);
 		set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
diff --git a/fs/ext4/xip.c b/fs/ext4/xip.c
new file mode 100644
index 0000000..5853345
--- /dev/null
+++ b/fs/ext4/xip.c
@@ -0,0 +1,78 @@
+/*
+ *  linux/fs/ext4/xip.c
+ *
+ * Copyright (C) 2005 IBM Corporation
+ * Author: Carsten Otte (cotte@de.ibm.com)
+ */
+
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/genhd.h>
+#include <linux/buffer_head.h>
+#include <linux/blkdev.h>
+#include "ext4.h"
+#include "xip.h"
+
+static inline int
+__inode_direct_access(struct inode *inode, sector_t block,
+		      void **kaddr, unsigned long *pfn)
+{
+	struct block_device *bdev =3D inode->i_sb->s_bdev;
+	const struct block_device_operations *ops =3D bdev->bd_disk->fops;
+	sector_t sector;
+
+	sector =3D block * (PAGE_SIZE / 512); /* ext4 block to bdev sector */
+
+	BUG_ON(!ops->direct_access);
+	return ops->direct_access(bdev, sector, kaddr, pfn);
+}
+
+static inline int
+__ext4_get_block(struct inode *inode, pgoff_t pgoff, int create,
+		   sector_t *result)
+{
+	struct buffer_head bh;
+	int rc;
+
+	memset(&bh, 0, sizeof(bh));
+	bh.b_size =3D inode->i_sb->s_blocksize;
+	rc =3D ext4_get_block(inode, pgoff, &bh, create);
+	*result =3D bh.b_blocknr;
+
+	/* did we get a sparse block (hole in the file)? */
+	if (!rc && !buffer_mapped(&bh)) {
+		BUG_ON(create);
+		rc =3D -ENODATA;
+	}
+
+	return rc;
+}
+
+int
+ext4_clear_xip_target(struct inode *inode, sector_t block)
+{
+	void *kaddr;
+	unsigned long pfn;
+	int rc;
+
+	rc =3D __inode_direct_access(inode, block, &kaddr, &pfn);
+	if (!rc)
+		clear_page(kaddr);
+	return rc;
+}
+
+int ext4_get_xip_mem(struct address_space *mapping, pgoff_t pgoff, int=
 create,
+				void **kmem, unsigned long *pfn)
+{
+	int rc;
+	sector_t block;
+
+	/* first, retrieve the sector number */
+	rc =3D __ext4_get_block(mapping->host, pgoff, create, &block);
+	if (rc)
+		return rc;
+
+	/* retrieve address of the target data */
+	rc =3D __inode_direct_access(mapping->host, block, kmem, pfn);
+	return rc;
+}
diff --git a/fs/ext4/xip.h b/fs/ext4/xip.h
new file mode 100644
index 0000000..af0d553
--- /dev/null
+++ b/fs/ext4/xip.h
@@ -0,0 +1,24 @@
+/*
+ *  linux/fs/ext4/xip.h
+ *
+ * Copyright (C) 2005 IBM Corporation
+ * Author: Carsten Otte (cotte@de.ibm.com)
+ */
+
+#ifdef CONFIG_EXT4_FS_XIP
+extern int ext4_clear_xip_target(struct inode *, sector_t);
+
+static inline int ext4_use_xip(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
+	return sbi->s_mount_opt & EXT4_MOUNT_XIP;
+}
+int ext4_get_xip_mem(struct address_space *, pgoff_t, int,
+				void **, unsigned long *);
+#define mapping_is_xip(map) unlikely(map->a_ops->get_xip_mem)
+#else
+#define mapping_is_xip(map)			0
+#define ext4_use_xip(sb)			0
+#define ext4_clear_xip_target(inode, chain)	0
+#define ext4_get_xip_mem			NULL
+#endif
--=20
1.8.4.rc3

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
