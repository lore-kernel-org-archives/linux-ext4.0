From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 09/47] libext2fs: Create the inode bitmap checksum
Date: Sat, 08 Oct 2011 00:34:13 -0700
Message-ID: <20111008073413.17888.75831.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48781 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1JHHg2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:36:28 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p986F56k013125
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 02:15:05 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987YFbn202108
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:34:15 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987YE05013061
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:34:15 -0400
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide a field in the block group descriptor to store inode bitmap checksum,
and some helper functions to calculate and verify it.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/blknum.c     |   15 +++++++++++++
 lib/ext2fs/closefs.c    |   29 +++++++++++++++-----------
 lib/ext2fs/csum.c       |   53 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h    |    4 ++++
 lib/ext2fs/ext2fs.h     |    6 +++++
 lib/ext2fs/rw_bitmaps.c |   17 +++++++++++++++
 6 files changed, 112 insertions(+), 12 deletions(-)


diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index fd203b4..30987fc 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -230,6 +230,21 @@ void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 }
 
 /*
+ * Return the inode bitmap checksum of a group
+ */
+__u32 ext2fs_inode_bitmap_checksum(ext2_filsys fs, dgrp_t group)
+{
+	struct ext4_group_desc *gdp;
+	__u32 csum;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	csum = gdp->bg_inode_bitmap_csum_lo;
+	if (fs->super->s_desc_size < EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION)
+		csum |= ((__u32)gdp->bg_inode_bitmap_csum_hi << 16);
+	return csum;
+}
+
+/*
  * Return the inode bitmap block of a group
  */
 blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group)
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 973c2a2..1867be3 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -288,6 +288,23 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 
 	fs->super->s_wtime = fs->now ? fs->now : time(NULL);
 	fs->super->s_block_group_nr = 0;
+
+	/*
+	 * If the write_bitmaps() function is present, call it to
+	 * flush the bitmaps.  This is done this way so that a simple
+	 * program that doesn't mess with the bitmaps doesn't need to
+	 * drag in the bitmaps.c code.
+	 *
+	 * Bitmap checksums live in the group descriptor, so the
+	 * bitmaps need to be written before the descriptors.
+	 */
+	if (fs->write_bitmaps) {
+		retval = fs->write_bitmaps(fs);
+		if (retval)
+			goto errout;
+	}
+
+	/* Prepare the group descriptors for writing */
 #ifdef WORDS_BIGENDIAN
 	retval = EXT2_ET_NO_MEMORY;
 	retval = ext2fs_get_mem(SUPERBLOCK_SIZE, &super_shadow);
@@ -378,18 +395,6 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 
 	ext2fs_numeric_progress_close(fs, &progress, NULL);
 
-	/*
-	 * If the write_bitmaps() function is present, call it to
-	 * flush the bitmaps.  This is done this way so that a simple
-	 * program that doesn't mess with the bitmaps doesn't need to
-	 * drag in the bitmaps.c code.
-	 */
-	if (fs->write_bitmaps) {
-		retval = fs->write_bitmaps(fs);
-		if (retval)
-			goto errout;
-	}
-
 write_primary_superblock_only:
 	/*
 	 * Write out master superblock.  This has to be done
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index b8945ad..91b1892 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,59 @@
 #define STATIC static
 #endif
 
+static __u32 ext2fs_bitmap_csum(ext2_filsys fs, dgrp_t group, char *bitmap,
+				int size)
+{
+	__u32 crc;
+
+	group = ext2fs_cpu_to_le32(group);
+	crc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+			       sizeof(fs->super->s_uuid));
+	crc = ext2fs_crc32c_le(crc, (unsigned char *)&group, sizeof(group));
+	crc = ext2fs_crc32c_le(crc, (unsigned char *)bitmap, size);
+
+	return crc;
+}
+
+int ext2fs_inode_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
+				    char *bitmap, int size)
+{
+	struct ext4_group_desc *gdp = (struct ext4_group_desc *)
+			ext2fs_group_desc(fs, fs->group_desc, group);
+	__u32 provided, calculated;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+	provided = gdp->bg_inode_bitmap_csum_lo;
+	calculated = ext2fs_bitmap_csum(fs, group, bitmap, size);
+	if (fs->super->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION)
+		provided |= ((__u32)gdp->bg_inode_bitmap_csum_hi << 16);
+	else
+		calculated &= 0xFFFF;
+
+	return provided == calculated;
+}
+
+errcode_t ext2fs_inode_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
+				       char *bitmap, int size)
+{
+	__u32 crc;
+	struct ext4_group_desc *gdp = (struct ext4_group_desc *)
+			ext2fs_group_desc(fs, fs->group_desc, group);
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	crc = ext2fs_bitmap_csum(fs, group, bitmap, size);
+	gdp->bg_inode_bitmap_csum_lo = crc & 0xFFFF;
+	if (fs->super->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION)
+		gdp->bg_inode_bitmap_csum_hi = crc >> 16;
+
+	return 0;
+}
+
 static errcode_t ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 			       struct ext2_inode_large *inode,
 			       __u32 *crc)
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 6fd82f1..e7f8bb4 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -191,6 +191,10 @@ struct ext4_group_desc
 	__u32	bg_reserved;
 };
 
+#define EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION	\
+	(offsetof(struct ext4_group_desc, bg_inode_bitmap_csum_hi) + \
+	 sizeof(__u16))
+
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
 #define EXT2_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 04db632..d71181b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -788,6 +788,7 @@ extern errcode_t ext2fs_get_block_bitmap_range2(ext2fs_block_bitmap bmap,
 					 void *out);
 
 /* blknum.c */
+extern __u32 ext2fs_inode_bitmap_checksum(ext2_filsys fs, dgrp_t group);
 extern dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t);
 extern blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group);
@@ -818,6 +819,7 @@ extern struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
 extern blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 					blk64_t blk);
+extern __u32 ext2fs_inode_bitmap_csum(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_inode_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 					blk64_t blk);
@@ -925,6 +927,10 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern errcode_t ext2fs_inode_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
+					      char *bitmap, int size);
+extern int ext2fs_inode_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
+					   char *bitmap, int size);
 extern errcode_t ext2fs_inode_csum_set(ext2_filsys fs, ext2_ino_t inum,
 				       struct ext2_inode_large *inode);
 extern int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 1d5f7b2..a325fdb 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -117,6 +117,12 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		if (retval)
 			goto errout;
 
+		retval = ext2fs_inode_bitmap_csum_set(fs, i, inode_buf,
+						      inode_nbytes);
+		if (retval)
+			goto errout;
+		ext2fs_group_desc_csum_set(fs, i);
+
 		blk = ext2fs_inode_bitmap_loc(fs, i);
 		if (blk) {
 			retval = io_channel_write_blk64(fs->io, blk, 1,
@@ -163,6 +169,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	blk64_t   blk_cnt;
 	ext2_ino_t ino_itr = 1;
 	ext2_ino_t ino_cnt;
+	struct ext4_group_desc *gdp;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -288,6 +295,16 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					retval = EXT2_ET_INODE_BITMAP_READ;
 					goto cleanup;
 				}
+
+				/* verify inode bitmap checksum */
+				gdp = (struct ext4_group_desc *)
+					ext2fs_group_desc(fs, fs->group_desc,
+							  i);
+				if (!(fs->flags &
+				      EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+				    !ext2fs_inode_bitmap_csum_verify(fs, i,
+						inode_bitmap, inode_nbytes))
+					return EXT2_ET_INODE_BITMAP_READ;
 			} else
 				memset(inode_bitmap, 0, inode_nbytes);
 			cnt = inode_nbytes << 3;

