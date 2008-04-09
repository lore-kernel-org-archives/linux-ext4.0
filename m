From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [E2FSPROGS, PATCH] Add support for the HUGE_FILE feature
Date: Wed,  9 Apr 2008 11:50:36 -0400
Message-ID: <1207756236-7775-1-git-send-email-tytso@mit.edu>
References: <20080408210048.GA16108@mit.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52135 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbYDIPun (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 11:50:43 -0400
In-Reply-To: <20080408210048.GA16108@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/emptydir.c      |    3 +-
 e2fsck/message.c       |    7 ++++-
 e2fsck/pass1.c         |   12 ++++++-
 e2fsck/pass2.c         |    2 +-
 e2fsck/pass3.c         |    6 ++--
 e2fsck/rehash.c        |    2 +-
 e2fsck/super.c         |    3 +-
 lib/e2p/pf.c           |    1 +
 lib/ext2fs/Makefile.in |    2 +
 lib/ext2fs/bb_inode.c  |    2 +-
 lib/ext2fs/bmap.c      |    2 +-
 lib/ext2fs/expanddir.c |    2 +-
 lib/ext2fs/ext2_fs.h   |    1 +
 lib/ext2fs/ext2fs.h    |   14 ++++++--
 lib/ext2fs/i_block.c   |   76 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/mkdir.c     |    2 +-
 lib/ext2fs/mkjournal.c |    2 +-
 lib/ext2fs/read_bb.c   |   11 ++++--
 lib/ext2fs/res_gdt.c   |    8 ++---
 misc/dumpe2fs.c        |    7 ++++-
 resize/resize2fs.c     |    2 +-
 21 files changed, 135 insertions(+), 32 deletions(-)
 create mode 100644 lib/ext2fs/i_block.c

diff --git a/e2fsck/emptydir.c b/e2fsck/emptydir.c
index 5dbf021..6baab76 100644
--- a/e2fsck/emptydir.c
+++ b/e2fsck/emptydir.c
@@ -168,8 +168,7 @@ static int fix_directory(ext2_filsys fs,
 
 	if (edi->freed_blocks) {
 		edi->inode.i_size -= edi->freed_blocks * fs->blocksize;
-		edi->inode.i_blocks -= edi->freed_blocks *
-			(fs->blocksize / 512);
+		ext2fs_iblk_add_blocks(fs, &edi->inode, edi->freed_blocks);
 		retval = ext2fs_write_inode(fs, db->ino, &edi->inode);
 		if (retval)
 			return 0;
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 8a3705e..184e824 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -275,7 +275,12 @@ static _INLINE_ void expand_inode_expression(char ch,
 		printf("%u", large_inode->i_extra_isize);
 		break;
 	case 'b':
-		printf("%u", inode->i_blocks);
+		if (inode->i_flags & EXT4_HUGE_FILE_FL)
+			printf("%llu", inode->i_blocks +
+			       (((long long) inode->osd2.linux2.l_i_blocks_hi) 
+				<< 32));
+		else
+			printf("%u", inode->i_blocks);
 		break;
 	case 'l':
 		printf("%d", inode->i_links_count);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index b85f04f..18cb916 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1847,7 +1847,10 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
-	pb.num_blocks *= (fs->blocksize / 512);
+	if (!(fs->super->s_feature_ro_compat &
+	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	    (inode->i_flags & EXT4_HUGE_FILE_FL))
+		pb.num_blocks *= (fs->blocksize / 512);
 #if 0
 	printf("inode %u, i_size = %lu, last_block = %lld, i_blocks=%lu, num_blocks = %lu\n",
 	       ino, inode->i_size, pb.last_block, inode->i_blocks,
@@ -1891,10 +1894,15 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	if (LINUX_S_ISREG(inode->i_mode) &&
 	    (inode->i_size_high || inode->i_size & 0x80000000UL))
 		ctx->large_files++;
-	if (pb.num_blocks != inode->i_blocks) {
+	if ((pb.num_blocks != inode->i_blocks) ||
+	    ((fs->super->s_feature_ro_compat &
+	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+	     (inode->i_flags & EXT4_HUGE_FILE_FL) &&
+	     (inode->osd2.linux2.l_i_blocks_hi != 0))) {
 		pctx->num = pb.num_blocks;
 		if (fix_problem(ctx, PR_1_BAD_I_BLOCKS, pctx)) {
 			inode->i_blocks = pb.num_blocks;
+			inode->osd2.linux2.l_i_blocks_hi = 0;
 			dirty_inode++;
 		}
 		pctx->num = 0;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 906662d..7aa693b 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1429,7 +1429,7 @@ static int allocate_dir_block(e2fsck_t ctx,
 	 * Update the inode block count
 	 */
 	e2fsck_read_inode(ctx, db->ino, &inode, "allocate_dir_block");
-	inode.i_blocks += fs->blocksize / 512;
+	ext2fs_iblk_add_blocks(fs, &inode, 1);
 	if (inode.i_size < (db->blockcnt+1) * fs->blocksize)
 		inode.i_size = (db->blockcnt+1) * fs->blocksize;
 	e2fsck_write_inode(ctx, db->ino, &inode, "allocate_dir_block");
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 867cbf8..4ef1446 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -227,7 +227,7 @@ static void check_root(e2fsck_t ctx)
 	inode.i_size = fs->blocksize;
 	inode.i_atime = inode.i_ctime = inode.i_mtime = ctx->now;
 	inode.i_links_count = 2;
-	inode.i_blocks = fs->blocksize / 512;
+	ext2fs_iblk_set(fs, &inode, 1);
 	inode.i_block[0] = blk;
 
 	/*
@@ -472,7 +472,7 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 	inode.i_size = fs->blocksize;
 	inode.i_atime = inode.i_ctime = inode.i_mtime = ctx->now;
 	inode.i_links_count = 2;
-	inode.i_blocks = fs->blocksize / 512;
+	ext2fs_iblk_set(fs, &inode, 1);
 	inode.i_block[0] = blk;
 
 	/*
@@ -803,7 +803,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 		return retval;
 	
 	inode.i_size = (es.last_block + 1) * fs->blocksize;
-	inode.i_blocks += (fs->blocksize / 512) * es.newblocks;
+	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
 
 	e2fsck_write_inode(ctx, dir, &inode, "expand_directory");
 
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index a1f75ef..e75774a 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -668,7 +668,7 @@ static errcode_t write_directory(e2fsck_t ctx, ext2_filsys fs,
 	else
 		inode.i_flags |= EXT2_INDEX_FL;
 	inode.i_size = outdir->num * fs->blocksize;
-	inode.i_blocks -= (fs->blocksize / 512) * wd.cleared;
+	ext2fs_iblk_sub_blocks(fs, &inode, wd.cleared);
 	e2fsck_write_inode(ctx, ino, &inode, "rehash_dir");
 
 	return 0;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 87a0d78..b8a1df7 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -195,8 +195,7 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 	e2fsck_read_inode(ctx, ino, inode, "release_inode_blocks");
 
 	if (pb.truncated_blocks)
-		inode->i_blocks -= pb.truncated_blocks *
-			(fs->blocksize / 512);
+		ext2fs_iblk_sub_blocks(fs, inode, pb.truncated_blocks);
 
 	if (inode->i_file_acl) {
 		retval = ext2fs_adjust_ea_refcount(fs, inode->i_file_acl,
diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index 3e9a7cd..05a961a 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -45,6 +45,7 @@ static struct flags_name flags_array[] = {
 	{ EXT2_NOTAIL_FL, "t", "No_Tailmerging" },
 	{ EXT2_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
 	{ EXT4_EXTENTS_FL, "e", "Extents" },
+	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
 	{ 0, NULL, NULL }
 };
 
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 2766493..677e2d6 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -47,6 +47,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	get_pathname.o \
 	getsize.o \
 	getsectsize.o \
+	i_block.o \
 	icount.o \
 	ind_block.o \
 	initialize.o \
@@ -106,6 +107,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/get_pathname.c \
 	$(srcdir)/getsize.c \
 	$(srcdir)/getsectsize.c \
+	$(srcdir)/i_block.c \
 	$(srcdir)/icount.c \
 	$(srcdir)/ind_block.c \
 	$(srcdir)/initialize.c \
diff --git a/lib/ext2fs/bb_inode.c b/lib/ext2fs/bb_inode.c
index 1f5b4e8..dbda79f 100644
--- a/lib/ext2fs/bb_inode.c
+++ b/lib/ext2fs/bb_inode.c
@@ -127,7 +127,7 @@ errcode_t ext2fs_update_bb_inode(ext2_filsys fs, ext2_badblocks_list bb_list)
 	inode.i_atime = inode.i_mtime = fs->now ? fs->now : time(0);
 	if (!inode.i_ctime)
 		inode.i_ctime = fs->now ? fs->now : time(0);
-	inode.i_blocks = rec.bad_block_count * (fs->blocksize / 512);
+	ext2fs_iblk_set(fs, &inode, rec.bad_block_count);
 	inode.i_size = rec.bad_block_count * fs->blocksize;
 
 	retval = ext2fs_write_inode(fs, EXT2_BAD_INO, &inode);
diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 5fe0986..ceb352e 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -297,7 +297,7 @@ done:
 	if (handle)
 		ext2fs_extent_free(handle);
 	if ((retval == 0) && (blocks_alloc || inode_dirty)) {
-		inode->i_blocks += (blocks_alloc * fs->blocksize) / 512;
+		ext2fs_iblk_add_blocks(fs, inode, blocks_alloc);
 		retval = ext2fs_write_inode(fs, ino, inode);
 	}
 	return retval;
diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 10a5149..c124d3e 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -116,7 +116,7 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 		return retval;
 	
 	inode.i_size += fs->blocksize;
-	inode.i_blocks += (fs->blocksize / 512) * es.newblocks;
+	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
 
 	retval = ext2fs_write_inode(fs, dir, &inode);
 	if (retval)
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 444211d..ad42cf8 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -271,6 +271,7 @@ struct ext2_dx_countlimit {
 #define EXT2_NOTAIL_FL			0x00008000 /* file tail should not be merged */
 #define EXT2_DIRSYNC_FL 		0x00010000 /* Synchronous directory modifications */
 #define EXT2_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
+#define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1a7cb86..e5988cd 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -516,6 +516,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
+					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
@@ -524,10 +525,8 @@ typedef struct ext2_icount *ext2_icount_t;
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
  * to ext2fs_openfs()
  */
-#define EXT2_LIB_SOFTSUPP_INCOMPAT	(EXT3_FEATURE_INCOMPAT_EXTENTS)
-#define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
-					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)
+#define EXT2_LIB_SOFTSUPP_INCOMPAT	(0)
+#define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)
 
 /*
  * function prototypes
@@ -899,6 +898,13 @@ extern errcode_t ext2fs_get_device_size(const char *file, int blocksize,
 /* getsectsize.c */
 errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize);
 
+/* i_block.c */
+errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
+				 blk64_t num_blocks);
+errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
+				 blk64_t num_blocks);
+errcode_t ext2fs_iblk_set(ext2_filsys fs, struct ext2_inode *inode, blk64_t b);
+
 /* imager.c */
 extern errcode_t ext2fs_image_inode_write(ext2_filsys fs, int fd, int flags);
 extern errcode_t ext2fs_image_inode_read(ext2_filsys fs, int fd, int flags);
diff --git a/lib/ext2fs/i_block.c b/lib/ext2fs/i_block.c
new file mode 100644
index 0000000..90e2a2b
--- /dev/null
+++ b/lib/ext2fs/i_block.c
@@ -0,0 +1,76 @@
+/*
+ * i_block.c --- Manage the i_block field for i_blocks
+ *
+ * Copyright (C) 2008 Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ * 
+ */
+
+#include <stdio.h>
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <time.h>
+#include <string.h>
+#if HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+
+errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
+				 blk64_t num_blocks)
+{
+	unsigned long long b;
+
+	if ((fs->super->s_feature_ro_compat &
+	     EXT4_FEATURE_RO_COMPAT_HUGE_FILE) && 
+	    (inode->i_flags & EXT4_HUGE_FILE_FL)) {
+		b = inode->i_blocks + 
+			(((long long) inode->osd2.linux2.l_i_blocks_hi) << 32);
+		b += num_blocks;
+		inode->i_blocks = b & 0xFFFFFFFF;
+		inode->osd2.linux2.l_i_blocks_hi = b >> 32;
+	} else
+		inode->i_blocks += (fs->blocksize / 512) * num_blocks;
+	return 0;
+}
+
+
+errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
+				 blk64_t num_blocks)
+{
+	unsigned long long b;
+
+	if ((fs->super->s_feature_ro_compat &
+	     EXT4_FEATURE_RO_COMPAT_HUGE_FILE) && 
+	    (inode->i_flags & EXT4_HUGE_FILE_FL)) {
+		b = inode->i_blocks + 
+			(((long long) inode->osd2.linux2.l_i_blocks_hi) << 32);
+		b -= num_blocks;
+		inode->i_blocks = b & 0xFFFFFFFF;
+		inode->osd2.linux2.l_i_blocks_hi = b >> 32;
+	} else
+		inode->i_blocks -= (fs->blocksize / 512) * num_blocks;
+	return 0;
+}
+
+errcode_t ext2fs_iblk_set(ext2_filsys fs, struct ext2_inode *inode, blk64_t b)
+{
+	if ((fs->super->s_feature_ro_compat &
+	     EXT4_FEATURE_RO_COMPAT_HUGE_FILE) && 
+	    (inode->i_flags & EXT4_HUGE_FILE_FL)) {
+		inode->i_blocks = b & 0xFFFFFFFF;
+		inode->osd2.linux2.l_i_blocks_hi = b >> 32;
+	} else
+		inode->i_blocks = (fs->blocksize / 512) * b;
+	return 0;
+}
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 45e6820..34242df 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -82,7 +82,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	memset(&inode, 0, sizeof(struct ext2_inode));
 	inode.i_mode = LINUX_S_IFDIR | (0777 & ~fs->umask);
 	inode.i_uid = inode.i_gid = 0;
-	inode.i_blocks = fs->blocksize / 512;
+	ext2fs_iblk_set(fs, &inode, 1);
 	inode.i_block[0] = blk;
 	inode.i_links_count = 2;
 	inode.i_ctime = inode.i_atime = inode.i_mtime = fs->now ? fs->now : time(NULL);
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 61d10a6..23cc60c 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -228,7 +228,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 		goto errout;
 
  	inode.i_size += fs->blocksize * size;
-	inode.i_blocks += (fs->blocksize / 512) * es.newblocks;
+	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
 	inode.i_mtime = inode.i_ctime = fs->now ? fs->now : time(0);
 	inode.i_links_count = 1;
 	inode.i_mode = LINUX_S_IFREG | 0600;
diff --git a/lib/ext2fs/read_bb.c b/lib/ext2fs/read_bb.c
index ff7e292..5a9aede 100644
--- a/lib/ext2fs/read_bb.c
+++ b/lib/ext2fs/read_bb.c
@@ -74,10 +74,13 @@ errcode_t ext2fs_read_bb_inode(ext2_filsys fs, ext2_badblocks_list *bb_list)
 		retval = ext2fs_read_inode(fs, EXT2_BAD_INO, &inode);
 		if (retval)
 			return retval;
-		if (inode.i_blocks < 500)
-			numblocks = (inode.i_blocks /
-				     (fs->blocksize / 512)) + 20;
-		else
+		numblocks = inode.i_blocks;
+		if ((fs->super->s_feature_ro_compat &
+		     EXT4_FEATURE_RO_COMPAT_HUGE_FILE) && 
+		    (inode.i_flags & EXT4_HUGE_FILE_FL))
+			numblocks = numblocks / (fs->blocksize / 512);
+		numblocks += 20;
+		if (numblocks < 500)
 			numblocks = 500;
 		retval = ext2fs_badblocks_list_create(bb_list, numblocks);
 		if (retval)
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index ef87ab7..848a02a 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -64,7 +64,6 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys fs)
 	struct ext2_super_block	*sb;
 	struct ext2_inode	inode;
 	__u32			*dindir_buf, *gdt_buf;
-	int			rsv_add;
 	unsigned long long	apb, inode_size;
 	blk_t			dindir_blk, rsv_off, gdt_off, gdt_blk;
 	int			dindir_dirty = 0, inode_dirty = 0;
@@ -84,7 +83,6 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys fs)
 
 	/* Maximum possible file size (we donly use the dindirect blocks) */
 	apb = EXT2_ADDR_PER_BLOCK(sb);
-	rsv_add = fs->blocksize / 512;
 	if ((dindir_blk = inode.i_block[EXT2_DIND_BLOCK])) {
 #ifdef RES_GDT_DEBUG
 		printf("reading GDT dindir %u\n", dindir_blk);
@@ -103,7 +101,7 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys fs)
 		inode.i_mode = LINUX_S_IFREG | 0600;
 		inode.i_links_count = 1;
 		inode.i_block[EXT2_DIND_BLOCK] = dindir_blk;
-		inode.i_blocks = rsv_add;
+		ext2fs_iblk_set(fs, &inode, 1);
 		memset(dindir_buf, 0, fs->blocksize);
 #ifdef RES_GDT_DEBUG
 		printf("allocated GDT dindir %u\n", dindir_blk);
@@ -144,7 +142,7 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys fs)
 			gdt_dirty = dindir_dirty = inode_dirty = 1;
 			memset(gdt_buf, 0, fs->blocksize);
 			dindir_buf[gdt_off] = gdt_blk;
-			inode.i_blocks += rsv_add;
+			ext2fs_iblk_add_blocks(fs, &inode, 1);
 #ifdef RES_GDT_DEBUG
 			printf("added primary GDT block %u at %u[%u]\n",
 			       gdt_blk, dindir_blk, gdt_off);
@@ -175,7 +173,7 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys fs)
 				       expect, grp, gdt_blk, last);
 #endif
 				gdt_buf[last] = expect;
-				inode.i_blocks += rsv_add;
+				ext2fs_iblk_add_blocks(fs, &inode, 1);
 				gdt_dirty = inode_dirty = 1;
 			} else if (gdt_buf[last] != expect) {
 #ifdef RES_GDT_DEBUG
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index b0bdd7d..4e2ce0f 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -296,7 +296,12 @@ static void print_inline_journal_information(ext2_filsys fs)
 		exit(1);
 	}
 	fputs(_("Journal size:             "), stdout);
-	size = inode.i_blocks >> 1;
+	if ((fs->super->s_feature_ro_compat &
+	     EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+	    (inode.i_flags & EXT4_HUGE_FILE_FL))
+		size = inode.i_blocks / (fs->blocksize / 1024);
+	else
+		size = inode.i_blocks >> 1;
 	if (size < 8192)
 		printf("%uk\n", size);
 	else
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 1062ffa..5fb3501 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1536,7 +1536,7 @@ static errcode_t fix_resize_inode(ext2_filsys fs)
 	retval = ext2fs_read_inode(fs, EXT2_RESIZE_INO, &inode);
 	if (retval) goto errout;
 
-	inode.i_blocks = fs->blocksize/512;
+	ext2fs_iblk_set(fs, &inode, 1);
 
 	retval = ext2fs_write_inode(fs, EXT2_RESIZE_INO, &inode);
 	if (retval) goto errout;
-- 
1.5.4.1.144.gdfee-dirty

