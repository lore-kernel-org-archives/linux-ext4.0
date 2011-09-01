From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 15/37] libext2fs: Create the block bitmap checksum
Date: Wed, 31 Aug 2011 17:36:47 -0700
Message-ID: <20110901003647.1176.41150.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45744 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab1IAAgv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:36:51 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810DSup007524
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:13:28 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810aooV1847468
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:36:50 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VKaZl4008361
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 17:36:37 -0300
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide a field in the block group descriptor to store block bitmap checksum,
and some helper functions to calculate and verify it.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/blknum.c     |   11 +++++++++++
 lib/ext2fs/csum.c       |   15 +++++++++++++++
 lib/ext2fs/ext2_fs.h    |    3 ++-
 lib/ext2fs/ext2fs.h     |    1 +
 lib/ext2fs/rw_bitmaps.c |   14 ++++++++++++++
 lib/ext2fs/swapfs.c     |    1 +
 6 files changed, 44 insertions(+), 1 deletions(-)


diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index 47d3fda..07b2cb3 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -183,6 +183,17 @@ static struct ext4_group_desc *ext4fs_group_desc(ext2_filsys fs,
 }
 
 /*
+ * Return the block bitmap checksum of a group
+ */
+blk64_t ext2fs_block_bitmap_checksum(ext2_filsys fs, dgrp_t group)
+{
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_block_bitmap_csum;
+}
+
+/*
  * Return the block bitmap block of a group
  */
 blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group)
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 56b75da..f594c90 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -74,6 +74,21 @@ void ext2fs_inode_bitmap_csum_set(ext2_filsys fs, dgrp_t group, char *bitmap,
 	gdp->bg_inode_bitmap_csum = ext2fs_bitmap_csum(fs, group, bitmap, size);
 }
 
+void ext2fs_block_bitmap_csum_set(ext2_filsys fs, dgrp_t group, char *bitmap,
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
+	gdp->bg_block_bitmap_csum = ext2fs_bitmap_csum(fs, group, bitmap, size);
+}
+
 __u32 ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 			struct ext2_inode_large *inode)
 {
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 367bfdf..ec28fac 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -159,7 +159,8 @@ struct ext4_group_desc
 	__u16	bg_free_inodes_count;	/* Free inodes count */
 	__u16	bg_used_dirs_count;	/* Directories count */
 	__u16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
-	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
+	__u32	bg_reserved[1];		/* unclaimed */
+	__u32	bg_block_bitmap_csum;	/* crc32c(uuid+group+bbitmap) */
 	__u16	bg_itable_unused;	/* Unused inodes count */
 	__u16	bg_checksum;		/* crc16(sb_uuid+group+desc) */
 	__u32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 0899e34..0cc3012 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -782,6 +782,7 @@ extern void ext2fs_free_blocks_count_add(struct ext2_super_block *super,
 extern struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
 					  struct opaque_ext2_group_desc *gdp,
 					  dgrp_t group);
+extern blk64_t ext2fs_block_bitmap_csum(ext2_filsys fs, dgrp_t group);
 extern blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 					blk64_t blk);
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 57aba59..802ce9f 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -91,6 +91,10 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 				for (j = nbits; j < fs->blocksize * 8; j++)
 					ext2fs_set_bit(j, block_buf);
 		}
+
+		ext2fs_block_bitmap_csum_set(fs, i, block_buf, block_nbytes);
+		ext2fs_group_desc_csum_set(fs, i);
+
 		blk = ext2fs_block_bitmap_loc(fs, i);
 		if (blk) {
 			retval = io_channel_write_blk64(fs->io, blk, 1,
@@ -259,6 +263,16 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					retval = EXT2_ET_BLOCK_BITMAP_READ;
 					goto cleanup;
 				}
+				/* verify block bitmap checksum */
+				gdp = (struct ext4_group_desc *)
+					ext2fs_group_desc(fs, fs->group_desc,
+							  i);
+				if (!(fs->flags &
+				      EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+				    !ext2fs_bitmap_csum_verify(fs, i,
+					gdp->bg_block_bitmap_csum,
+					block_bitmap, block_nbytes))
+					return EXT2_ET_BLOCK_BITMAP_READ;
 			} else
 				memset(block_bitmap, 0, block_nbytes);
 			cnt = block_nbytes << 3;
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 747e130..f657c47 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -126,6 +126,7 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
 		ext2fs_swab16(gdp4->bg_used_dirs_count_hi);
 	gdp4->bg_itable_unused_hi = ext2fs_swab16(gdp4->bg_itable_unused_hi);
 	gdp4->bg_inode_bitmap_csum = ext2fs_swab32(gdp4->bg_inode_bitmap_csum);
+	gdp4->bg_block_bitmap_csum = ext2fs_swab32(gdp4->bg_block_bitmap_csum);
 }
 
 void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)

