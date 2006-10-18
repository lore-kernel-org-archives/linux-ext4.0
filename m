From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, E2FSPROGS] On-disk format definition for 64-bit support
Date: Wed, 18 Oct 2006 02:18:33 -0400
Message-ID: <E1Ga4l7-0003mU-46@candygram.thunk.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:7821 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751439AbWJRGSj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 02:18:39 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


After thinking about it some more, and looking at the code committed
into the kernel git tree, I've changed my mind and agree that the
extending current group descriptor is simpler than having two versions
of the structure depending on the size of the group descriptor.

Does everyone agree this is what the 64-bit on-desk definition should
be?  Should 64-bit support also imply BIG_BG support?

						- Ted

- EXT4_FEATURE_INCOMPAT_64BIT (0x0080) - support for 64-bit block count
  fields in the superblock (s_blocks_count_hi, s_free_blocks_count_hi),
  large group descriptors (s_desc_size), extents with high 16 bits
  (ee_start_hi, ei_leaf_hi), inode ACL (i_file_acl_hi).  May also grow
  to encompass the previously proposed BIG_BG.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Index: e2fsprogs/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2_fs.h	2006-10-18 00:33:56.000000000 -0400
+++ e2fsprogs/lib/ext2fs/ext2_fs.h	2006-10-18 01:08:06.000000000 -0400
@@ -147,6 +147,25 @@
 	__u32	bg_reserved[3];
 };
 
+struct ext4_group_desc
+{
+	__u32	bg_block_bitmap;		/* Blocks bitmap block */
+	__u32	bg_inode_bitmap;		/* Inodes bitmap block */
+	__u32	bg_inode_table;			/* Inodes table block */
+	__u16	bg_free_blocks_count;		/* Free blocks count */
+	__u16	bg_free_inodes_count;		/* Free inodes count */
+	__u16	bg_used_dirs_count;		/* Directories count */
+	__u16	bg_flags;
+	__u32	bg_reserved[3];
+	__u32	bg_block_bitmap_hi;		/* Blocks bitmap block MSB */
+	__u32	bg_inode_bitmap_hi;		/* Inodes bitmap block MSB */
+	__u32	bg_inode_table_hi;		/* Inodes table block MSB */
+	__u16	bg_free_blocks_count_hi;	/* Free blocks count MSB */
+	__u16	bg_free_inodes_count_hi;	/* Free inodes count MSB */
+	__u16	bg_used_dirs_count_hi;		/* Directories count MSB */
+	__u32	bg_reserved2[3];
+};
+
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
 
@@ -524,12 +543,15 @@
 	__u32	s_hash_seed[4];		/* HTREE hash seed */
 	__u8	s_def_hash_version;	/* Default hash version to use */
 	__u8	s_jnl_backup_type; 	/* Default type of journal backup */
-	__u16	s_reserved_word_pad;
+	__u16	s_desc_size;		/* Group desc. size: INCOMPAT_64BIT */
 	__u32	s_default_mount_opts;
 	__u32	s_first_meta_bg;	/* First metablock group */
 	__u32	s_mkfs_time;		/* When the filesystem was created */
 	__u32	s_jnl_blocks[17]; 	/* Backup of the journal inode */
-	__u32	s_reserved[172];	/* Padding to the end of the block */
+	__u32	s_blocks_count_hi;	/* Blocks count high 32bits */
+	__u32	s_r_blocks_count_hi;	/* Reserved blocks count high 32 bits*/
+	__u32	s_free_blocks_hi; 	/* Free blocks count */
+	__u32	s_reserved[169];	/* Padding to the end of the block */
 };
 
 /*
@@ -586,6 +608,7 @@
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008 /* Journal device */
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
 #define EXT3_FEATURE_INCOMPAT_EXTENTS		0x0040
+#define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
