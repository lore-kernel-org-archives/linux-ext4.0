From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 13/47] libext2fs: Create the block bitmap checksum
Date: Sat, 08 Oct 2011 00:34:38 -0700
Message-ID: <20111008073438.17888.63128.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42340 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab1JHHh2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:37:28 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:37:27 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987YfVB168432
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:34:41 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987YdCL005357
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:34:41 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide a field in the block group descriptor to store block bitmap checksum,
and some helper functions to calculate and verify it.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/blknum.c     |   15 +++++++++++++++
 lib/ext2fs/csum.c       |   39 +++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h    |    3 +++
 lib/ext2fs/ext2fs.h     |    6 ++++++
 lib/ext2fs/rw_bitmaps.c |   16 ++++++++++++++++
 5 files changed, 79 insertions(+), 0 deletions(-)


diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index 30987fc..64f9b94 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -203,6 +203,21 @@ static struct ext4_group_desc *ext4fs_group_desc(ext2_filsys fs,
 }
 
 /*
+ * Return the block bitmap checksum of a group
+ */
+__u32 ext2fs_block_bitmap_checksum(ext2_filsys fs, dgrp_t group)
+{
+	struct ext4_group_desc *gdp;
+	__u32 csum;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	csum = gdp->bg_block_bitmap_csum_lo;
+	if (fs->super->s_desc_size < EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION)
+		csum |= ((__u32)gdp->bg_block_bitmap_csum_hi << 16);
+	return csum;
+}
+
+/*
  * Return the block bitmap block of a group
  */
 blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group)
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 91b1892..524d0e5 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -83,6 +83,45 @@ errcode_t ext2fs_inode_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
 	return 0;
 }
 
+int ext2fs_block_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
+				    char *bitmap, int size)
+{
+	struct ext4_group_desc *gdp = (struct ext4_group_desc *)
+			ext2fs_group_desc(fs, fs->group_desc, group);
+	__u32 provided, calculated;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+	provided = gdp->bg_block_bitmap_csum_lo;
+	calculated = ext2fs_bitmap_csum(fs, group, bitmap, size);
+	if (fs->super->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION)
+		provided |= ((__u32)gdp->bg_block_bitmap_csum_hi << 16);
+	else
+		calculated &= 0xFFFF;
+
+	return provided == calculated;
+}
+
+errcode_t ext2fs_block_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
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
+	gdp->bg_block_bitmap_csum_lo = crc & 0xFFFF;
+	if (fs->super->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION)
+		gdp->bg_block_bitmap_csum_hi = crc >> 16;
+
+	return 0;
+}
+
 static errcode_t ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 			       struct ext2_inode_large *inode,
 			       __u32 *crc)
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index e7f8bb4..cdfc4a8 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -194,6 +194,9 @@ struct ext4_group_desc
 #define EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION	\
 	(offsetof(struct ext4_group_desc, bg_inode_bitmap_csum_hi) + \
 	 sizeof(__u16))
+#define EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION	\
+	(offsetof(struct ext4_group_desc, bg_block_bitmap_csum_hi) + \
+	 sizeof(__u16))
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d71181b..3b514a7 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -789,6 +789,7 @@ extern errcode_t ext2fs_get_block_bitmap_range2(ext2fs_block_bitmap bmap,
 
 /* blknum.c */
 extern __u32 ext2fs_inode_bitmap_checksum(ext2_filsys fs, dgrp_t group);
+extern __u32 ext2fs_block_bitmap_checksum(ext2_filsys fs, dgrp_t group);
 extern dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t);
 extern blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group);
@@ -816,6 +817,7 @@ extern void ext2fs_free_blocks_count_add(struct ext2_super_block *super,
 extern struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
 					  struct opaque_ext2_group_desc *gdp,
 					  dgrp_t group);
+extern blk64_t ext2fs_block_bitmap_csum(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 					blk64_t blk);
@@ -927,6 +929,10 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern errcode_t ext2fs_block_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
+					      char *bitmap, int size);
+extern int ext2fs_block_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
+					   char *bitmap, int size);
 extern errcode_t ext2fs_inode_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
 					      char *bitmap, int size);
 extern int ext2fs_inode_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index a325fdb..df755cc 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -92,6 +92,13 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 				for (j = nbits; j < fs->blocksize * 8; j++)
 					ext2fs_set_bit(j, block_buf);
 		}
+
+		retval = ext2fs_block_bitmap_csum_set(fs, i, block_buf,
+						      block_nbytes);
+		if (retval)
+			return retval;
+		ext2fs_group_desc_csum_set(fs, i);
+
 		blk = ext2fs_block_bitmap_loc(fs, i);
 		if (blk) {
 			retval = io_channel_write_blk64(fs->io, blk, 1,
@@ -273,6 +280,15 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					retval = EXT2_ET_BLOCK_BITMAP_READ;
 					goto cleanup;
 				}
+				/* verify block bitmap checksum */
+				gdp = (struct ext4_group_desc *)
+					ext2fs_group_desc(fs, fs->group_desc,
+							  i);
+				if (!(fs->flags &
+				      EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+				    !ext2fs_block_bitmap_csum_verify(fs, i,
+						block_bitmap, block_nbytes))
+					return EXT2_ET_BLOCK_BITMAP_READ;
 			} else
 				memset(block_bitmap, 0, block_nbytes);
 			cnt = block_nbytes << 3;

