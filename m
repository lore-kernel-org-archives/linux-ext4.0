From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 11/37] libext2fs: Create the inode bitmap checksum
Date: Wed, 31 Aug 2011 17:36:22 -0700
Message-ID: <20110901003622.1176.1504.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e36.co.us.ibm.com ([32.97.110.154]:43500 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab1IAAgc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:36:32 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810TqkW032230
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:29:52 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810aQWN169970
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:36:26 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VIaNKO008961
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:36:24 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide a field in the block group descriptor to store inode bitmap checksum,
and some helper functions to calculate and verify it.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/blknum.c     |   11 +++++++++++
 lib/ext2fs/closefs.c    |   29 +++++++++++++++++------------
 lib/ext2fs/csum.c       |   45 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h    |    3 ++-
 lib/ext2fs/ext2fs.h     |    7 +++++++
 lib/ext2fs/rw_bitmaps.c |   15 +++++++++++++++
 lib/ext2fs/swapfs.c     |    1 +
 7 files changed, 98 insertions(+), 13 deletions(-)


diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index 7e7fcd8..47d3fda 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -210,6 +210,17 @@ void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 }
 
 /*
+ * Return the inode bitmap checksum of a group
+ */
+blk64_t ext2fs_inode_bitmap_checksum(ext2_filsys fs, dgrp_t group)
+{
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_inode_bitmap_csum;
+}
+
+/*
  * Return the inode bitmap block of a group
  */
 blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group)
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 952f496..73dc136 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -289,6 +289,23 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 
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
@@ -379,18 +396,6 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 
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
index 57adc4c..56b75da 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -29,6 +29,51 @@
 #define STATIC static
 #endif
 
+__u32 ext2fs_bitmap_csum(ext2_filsys fs, dgrp_t group, char *bitmap, int size)
+{
+	__u32 crc = 0;
+
+	if (fs->super->s_desc_size < EXT2_MIN_DESC_SIZE_64BIT)
+		return 0;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	group = ext2fs_cpu_to_le32(group);
+	crc = crc32c_le(~0, fs->super->s_uuid, sizeof(fs->super->s_uuid));
+	crc = crc32c_le(crc, (char *)&group, sizeof(group));
+	crc = crc32c_le(crc, (char *)bitmap, size);
+
+	return crc;
+}
+
+int ext2fs_bitmap_csum_verify(ext2_filsys fs, dgrp_t group, __u32 provided,
+			      char *bitmap, int size)
+{
+	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT &&
+	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    (provided != ext2fs_bitmap_csum(fs, group, bitmap, size)))
+		return 0;
+	return 1;
+}
+
+void ext2fs_inode_bitmap_csum_set(ext2_filsys fs, dgrp_t group, char *bitmap,
+				  int size)
+{
+	struct ext4_group_desc *gdp = (struct ext4_group_desc *)
+			ext2fs_group_desc(fs, fs->group_desc, group);
+
+	if (fs->super->s_desc_size < EXT2_MIN_DESC_SIZE_64BIT)
+		return;
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	gdp->bg_inode_bitmap_csum = ext2fs_bitmap_csum(fs, group, bitmap, size);
+}
+
 __u32 ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 			struct ext2_inode_large *inode)
 {
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 1f08673..367bfdf 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -169,7 +169,8 @@ struct ext4_group_desc
 	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
 	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
 	__u16	bg_itable_unused_hi;	/* Unused inodes count MSB */
-	__u32	bg_reserved2[3];
+	__u32	bg_inode_bitmap_csum;	/* crc32c(uuid+group+ibitmap) */
+	__u32	bg_reserved2[2];
 };
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index db8b28b..0899e34 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -785,6 +785,7 @@ extern struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
 extern blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 					blk64_t blk);
+extern blk64_t ext2fs_inode_bitmap_csum(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_inode_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 					blk64_t blk);
@@ -892,6 +893,12 @@ extern __u32 crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern __u32 ext2fs_bitmap_csum(ext2_filsys fs, dgrp_t group, char *bitmap,
+				int size);
+extern int ext2fs_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
+				     __u32 provided, char *bitmap, int size);
+extern void ext2fs_inode_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
+					 char *bitmap, int size);
 extern __u32 ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 			      struct ext2_inode_large *inode);
 extern void ext2fs_inode_csum_set(ext2_filsys fs, ext2_ino_t inum,
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index f8c8a9f..57aba59 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -114,6 +114,9 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		if (retval)
 			return retval;
 
+		ext2fs_inode_bitmap_csum_set(fs, i, inode_buf, inode_nbytes);
+		ext2fs_group_desc_csum_set(fs, i);
+
 		blk = ext2fs_inode_bitmap_loc(fs, i);
 		if (blk) {
 			retval = io_channel_write_blk64(fs->io, blk, 1,
@@ -152,6 +155,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	blk64_t   blk_cnt;
 	ext2_ino_t ino_itr = 1;
 	ext2_ino_t ino_cnt;
+	struct ext4_group_desc *gdp;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -277,6 +281,17 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
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
+				    !ext2fs_bitmap_csum_verify(fs, i,
+					gdp->bg_inode_bitmap_csum,
+					inode_bitmap, inode_nbytes))
+					return EXT2_ET_INODE_BITMAP_READ;
 			} else
 				memset(inode_bitmap, 0, inode_nbytes);
 			cnt = inode_nbytes << 3;
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index df604ba..747e130 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -125,6 +125,7 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
 	gdp4->bg_used_dirs_count_hi =
 		ext2fs_swab16(gdp4->bg_used_dirs_count_hi);
 	gdp4->bg_itable_unused_hi = ext2fs_swab16(gdp4->bg_itable_unused_hi);
+	gdp4->bg_inode_bitmap_csum = ext2fs_swab32(gdp4->bg_inode_bitmap_csum);
 }
 
 void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)

