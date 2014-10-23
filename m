From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/6] e2fsprogs: Endian-annotate most on-disk structures
Date: Thu, 23 Oct 2014 16:28:14 -0500
Message-ID: <544972EE.4080907@redhat.com>
References: <54497296.8000708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaJWV2Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 17:28:16 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLSGfK029073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:28:16 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.rdu2.redhat.com [10.11.146.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLSEfB014636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:28:16 -0400
In-Reply-To: <54497296.8000708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This annotates most on-disk structures for endianness;
however it does not annotate some, like the superblock, inodes,
mmp, etc, as these are swapped in-place at this point.  This is
a little inconsistent, but should help catch some endian mistakes,
at least.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/ext2_fs.h      |   13 +++++++------
 lib/ext2fs/ext3_extents.h |   28 ++++++++++++++--------------
 lib/ext2fs/kernel-jbd.h   |    4 ++--
 lib/quota/quotaio.c       |    4 ++--
 lib/quota/quotaio_tree.h  |   10 +++++-----
 lib/quota/quotaio_v2.h    |   36 ++++++++++++++++++------------------
 6 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index f9a4bdb..2b24080 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -233,21 +233,21 @@ struct ext2_dx_root_info {
 #define EXT2_HASH_FLAG_INCOMPAT	0x1
 
 struct ext2_dx_entry {
-	__u32 hash;
-	__u32 block;
+	__le32 hash;
+	__le32 block;
 };
 
 struct ext2_dx_countlimit {
-	__u16 limit;
-	__u16 count;
+	__le16 limit;
+	__le16 count;
 };
 
 /*
  * This goes at the end of each htree block.
  */
 struct ext2_dx_tail {
-	__u32 dt_reserved;
-	__u32 dt_checksum;	/* crc32c(uuid+inum+dxblock) */
+	__le32 dt_reserved;
+	__le32 dt_checksum;	/* crc32c(uuid+inum+dxblock) */
 };
 
 /*
@@ -894,6 +894,7 @@ struct ext2_dir_entry_tail {
 #define EXT4_MMP_SEQ_FSCK  0xE24D4D50U /* mmp_seq value when being fscked */
 #define EXT4_MMP_SEQ_MAX   0xE24D4D4FU /* maximum valid mmp_seq value */
 
+/* Not endian-annotated; it's swapped at read/write time */
 struct mmp_struct {
 	__u32	mmp_magic;		/* Magic number for MMP */
 	__u32	mmp_seq;		/* Sequence no. updated periodically */
diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
index a18d705..66c23fd 100644
--- a/lib/ext2fs/ext3_extents.h
+++ b/lib/ext2fs/ext3_extents.h
@@ -26,7 +26,7 @@
  * crammed into the end of the block without having to rebalance the tree.
  */
 struct ext3_extent_tail {
-	__u32	et_checksum;	/* crc32c(uuid+inum+extent_block) */
+	__le32	et_checksum;	/* crc32c(uuid+inum+extent_block) */
 };
 
 /*
@@ -34,10 +34,10 @@ struct ext3_extent_tail {
  * it's used at the bottom of the tree
  */
 struct ext3_extent {
-	__u32	ee_block;	/* first logical block extent covers */
-	__u16	ee_len;		/* number of blocks covered by extent */
-	__u16	ee_start_hi;	/* high 16 bits of physical block */
-	__u32	ee_start;	/* low 32 bigs of physical block */
+	__le32	ee_block;	/* first logical block extent covers */
+	__le16	ee_len;		/* number of blocks covered by extent */
+	__le16	ee_start_hi;	/* high 16 bits of physical block */
+	__le32	ee_start;	/* low 32 bigs of physical block */
 };
 
 /*
@@ -45,22 +45,22 @@ struct ext3_extent {
  * it's used at all the levels, but the bottom
  */
 struct ext3_extent_idx {
-	__u32	ei_block;	/* index covers logical blocks from 'block' */
-	__u32	ei_leaf;	/* pointer to the physical block of the next *
+	__le32	ei_block;	/* index covers logical blocks from 'block' */
+	__le32	ei_leaf;	/* pointer to the physical block of the next *
 				 * level. leaf or next index could bet here */
-	__u16	ei_leaf_hi;	/* high 16 bits of physical block */
-	__u16	ei_unused;
+	__le16	ei_leaf_hi;	/* high 16 bits of physical block */
+	__le16	ei_unused;
 };
 
 /*
  * each block (leaves and indexes), even inode-stored has header
  */
 struct ext3_extent_header {
-	__u16	eh_magic;	/* probably will support different formats */
-	__u16	eh_entries;	/* number of valid entries */
-	__u16	eh_max;		/* capacity of store in entries */
-	__u16	eh_depth;	/* has tree real underlaying blocks? */
-	__u32	eh_generation;	/* generation of the tree */
+	__le16	eh_magic;	/* probably will support different formats */
+	__le16	eh_entries;	/* number of valid entries */
+	__le16	eh_max;		/* capacity of store in entries */
+	__le16	eh_depth;	/* has tree real underlaying blocks? */
+	__le32	eh_generation;	/* generation of the tree */
 };
 
 #define EXT3_EXT_MAGIC		0xf30a
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index 4020429..56efe21 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -170,7 +170,7 @@ typedef struct journal_block_tag_s
 
 /* Tail of descriptor block, for checksumming */
 struct journal_block_tail {
-	__u32		t_checksum;
+	__be32		t_checksum;
 };
 
 /*
@@ -185,7 +185,7 @@ typedef struct journal_revoke_header_s
 
 /* Tail of revoke block, for checksumming */
 struct journal_revoke_tail {
-	__u32		r_checksum;
+	__be32		r_checksum;
 };
 
 /* Definitions for the journal tag flags word: */
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 65fccaa..c7e5f87 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -30,8 +30,8 @@ static const char * const basenames[] = {
 
 /* Header in all newer quotafiles */
 struct disk_dqheader {
-	__u32 dqh_magic;
-	__u32 dqh_version;
+	__le32 dqh_magic;
+	__le32 dqh_version;
 } __attribute__ ((packed));
 
 /**
diff --git a/lib/quota/quotaio_tree.h b/lib/quota/quotaio_tree.h
index be34edb..0db0ca1 100644
--- a/lib/quota/quotaio_tree.h
+++ b/lib/quota/quotaio_tree.h
@@ -20,13 +20,13 @@ typedef __u32 qid_t;        /* Type in which we store ids in memory */
  *  so there will be space for exactly 21 quota-entries in a block
  */
 struct qt_disk_dqdbheader {
-	__u32 dqdh_next_free;	/* Number of next block with free
+	__le32 dqdh_next_free;	/* Number of next block with free
 					 * entry */
-	__u32 dqdh_prev_free; /* Number of previous block with free
+	__le32 dqdh_prev_free; /* Number of previous block with free
 				   * entry */
-	__u16 dqdh_entries; /* Number of valid entries in block */
-	__u16 dqdh_pad1;
-	__u32 dqdh_pad2;
+	__le16 dqdh_entries; /* Number of valid entries in block */
+	__le16 dqdh_pad1;
+	__le32 dqdh_pad2;
 } __attribute__ ((packed));
 
 struct dquot;
diff --git a/lib/quota/quotaio_v2.h b/lib/quota/quotaio_v2.h
index 646c698..de2db27 100644
--- a/lib/quota/quotaio_v2.h
+++ b/lib/quota/quotaio_v2.h
@@ -16,8 +16,8 @@
 #define V2_VERSION 1
 
 struct v2_disk_dqheader {
-	__u32 dqh_magic;	/* Magic number identifying file */
-	__u32 dqh_version;	/* File version */
+	__le32 dqh_magic;	/* Magic number identifying file */
+	__le32 dqh_version;	/* File version */
 } __attribute__ ((packed));
 
 /* Flags for version specific files */
@@ -25,30 +25,30 @@ struct v2_disk_dqheader {
 
 /* Header with type and version specific information */
 struct v2_disk_dqinfo {
-	__u32 dqi_bgrace;	/* Time before block soft limit becomes
+	__le32 dqi_bgrace;	/* Time before block soft limit becomes
 				 * hard limit */
-	__u32 dqi_igrace;	/* Time before inode soft limit becomes
+	__le32 dqi_igrace;	/* Time before inode soft limit becomes
 				 * hard limit */
-	__u32 dqi_flags;	/* Flags for quotafile (DQF_*) */
-	__u32 dqi_blocks;	/* Number of blocks in file */
-	__u32 dqi_free_blk;	/* Number of first free block in the list */
-	__u32 dqi_free_entry;	/* Number of block with at least one
+	__le32 dqi_flags;	/* Flags for quotafile (DQF_*) */
+	__le32 dqi_blocks;	/* Number of blocks in file */
+	__le32 dqi_free_blk;	/* Number of first free block in the list */
+	__le32 dqi_free_entry;	/* Number of block with at least one
 					 * free entry */
 } __attribute__ ((packed));
 
 struct v2r1_disk_dqblk {
-	__u32 dqb_id;	/* id this quota applies to */
-	__u32 dqb_pad;
-	__u64 dqb_ihardlimit;	/* absolute limit on allocated inodes */
-	__u64 dqb_isoftlimit;	/* preferred inode limit */
-	__u64 dqb_curinodes;	/* current # allocated inodes */
-	__u64 dqb_bhardlimit;	/* absolute limit on disk space
+	__le32 dqb_id;	/* id this quota applies to */
+	__le32 dqb_pad;
+	__le64 dqb_ihardlimit;	/* absolute limit on allocated inodes */
+	__le64 dqb_isoftlimit;	/* preferred inode limit */
+	__le64 dqb_curinodes;	/* current # allocated inodes */
+	__le64 dqb_bhardlimit;	/* absolute limit on disk space
 					 * (in QUOTABLOCK_SIZE) */
-	__u64 dqb_bsoftlimit;	/* preferred limit on disk space
+	__le64 dqb_bsoftlimit;	/* preferred limit on disk space
 					 * (in QUOTABLOCK_SIZE) */
-	__u64 dqb_curspace;	/* current space occupied (in bytes) */
-	__u64 dqb_btime;	/* time limit for excessive disk use */
-	__u64 dqb_itime;	/* time limit for excessive inode use */
+	__le64 dqb_curspace;	/* current space occupied (in bytes) */
+	__le64 dqb_btime;	/* time limit for excessive disk use */
+	__le64 dqb_itime;	/* time limit for excessive inode use */
 } __attribute__ ((packed));
 
 #endif
-- 1.7.1


