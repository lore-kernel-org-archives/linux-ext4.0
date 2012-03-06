From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 14/54] libext2fs: Create the block bitmap checksum
Date: Tue, 06 Mar 2012 15:58:51 -0800
Message-ID: <20120306235851.11945.33878.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e35.co.us.ibm.com ([32.97.110.153]:41099 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031282Ab2CFX7E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 18:59:04 -0500
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 16:59:04 -0700
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 616B23E40049
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 16:59:02 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q26Nx27k144596
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 16:59:02 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q26Nwt2t014910
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 16:59:01 -0700
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Calculate and verify the block bitmap checksum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/blknum.c     |   17 ++++++++++++++++-
 lib/ext2fs/csum.c       |   40 ++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h    |    3 +++
 lib/ext2fs/ext2fs.h     |    6 ++++++
 lib/ext2fs/rw_bitmaps.c |   16 ++++++++++++++++
 5 files changed, 81 insertions(+), 1 deletions(-)


diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index 212ad48..b3eef6c 100644
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
+	if (fs->super->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION)
+		csum |= ((__u32)gdp->bg_block_bitmap_csum_hi << 16);
+	return csum;
+}
+
+/*
  * Return the block bitmap block of a group
  */
 blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group)
@@ -239,7 +254,7 @@ __u32 ext2fs_inode_bitmap_checksum(ext2_filsys fs, dgrp_t group)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	csum = gdp->bg_inode_bitmap_csum_lo;
-	if (fs->super->s_desc_size < EXT4_BG_INODE_BITMAP_CSUM_HI_END)
+	if (fs->super->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_END)
 		csum |= ((__u32)gdp->bg_inode_bitmap_csum_hi << 16);
 	return csum;
 }
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 90ccd18..5c5b7fb 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -70,6 +70,46 @@ errcode_t ext2fs_inode_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
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
+	calculated = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)bitmap,
+				      size);
+	if (fs->super->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION)
+		provided |= (__u32)gdp->bg_block_bitmap_csum_hi << 16;
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
+	crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)bitmap, size);
+	gdp->bg_block_bitmap_csum_lo = crc & 0xFFFF;
+	if (fs->super->s_desc_size >= EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION)
+		gdp->bg_block_bitmap_csum_hi = crc >> 16;
+
+	return 0;
+}
+
 static errcode_t ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 			       struct ext2_inode_large *inode,
 			       __u32 *crc, int has_hi)
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 7853966..89df977 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -195,6 +195,9 @@ struct ext4_group_desc
 #define EXT4_BG_INODE_BITMAP_CSUM_HI_END	\
 	(offsetof(struct ext4_group_desc, bg_inode_bitmap_csum_hi) + \
 	 sizeof(__u16))
+#define EXT4_BG_BLOCK_BITMAP_CSUM_HI_LOCATION	\
+	(offsetof(struct ext4_group_desc, bg_block_bitmap_csum_hi) + \
+	 sizeof(__u16))
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 58538fe..9d3e8c9 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -810,6 +810,7 @@ extern errcode_t ext2fs_get_block_bitmap_range2(ext2fs_block_bitmap bmap,
 
 /* blknum.c */
 extern __u32 ext2fs_inode_bitmap_checksum(ext2_filsys fs, dgrp_t group);
+extern __u32 ext2fs_block_bitmap_checksum(ext2_filsys fs, dgrp_t group);
 extern dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t);
 extern blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group);
@@ -837,6 +838,7 @@ extern void ext2fs_free_blocks_count_add(struct ext2_super_block *super,
 extern struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
 					  struct opaque_ext2_group_desc *gdp,
 					  dgrp_t group);
+extern blk64_t ext2fs_block_bitmap_csum(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 					blk64_t blk);
@@ -950,6 +952,10 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
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
index 0ad5eb1..a5097c1 100644
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
@@ -272,6 +279,15 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					retval = EXT2_ET_BLOCK_BITMAP_READ;
 					goto cleanup;
 				}
+				/* verify block bitmap checksum */
+				if (!(fs->flags &
+				      EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+				    !ext2fs_block_bitmap_csum_verify(fs, i,
+						block_bitmap, block_nbytes)) {
+					retval =
+					EXT2_ET_BLOCK_BITMAP_READ;
+					goto cleanup;
+				}
 			} else
 				memset(block_bitmap, 0, block_nbytes);
 			cnt = block_nbytes << 3;

