From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC] A slightly different on-disk format for 64-bit support
Date: Wed, 11 Oct 2006 01:41:53 -0400
Message-ID: <E1GXWqn-00074k-KE@candygram.thunk.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:18326 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1030277AbWJKFmA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 01:42:00 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I'd like to propose that we use a different group descriptor structure
if the group descriptor size is greater than 32 bytes.  We have to code
that checks for the bigger descriptor anyway, and this way we can more
easily get the 64-bit information directly. 

What do folks tihng?

						- Ted


On-disk format for 64-bit support

This patch does things a little different from previous proposals.  It
uses an entirely different group_descriptor structure if the group
descriptor size is greater than 32 bytes.  We need to have separate
code anyway, and this allows for a cleaner data structure on disk.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


Index: e2fsprogs/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2_fs.h	2006-10-11 01:29:36.000000000 -0400
+++ e2fsprogs/lib/ext2fs/ext2_fs.h	2006-10-11 01:30:48.000000000 -0400
@@ -147,6 +147,19 @@
 	__u32	bg_reserved[3];
 };
 
+struct ext4_group_desc
+{
+	__u64	bg_block_bitmap;	/* Blocks bitmap block */
+	__u64	bg_inode_bitmap;	/* Inodes bitmap block */
+	__u64	bg_inode_table;		/* Inodes table block */
+	__u32	bg_free_blocks_count;	/* Free blocks count */
+	__u32	bg_free_inodes_count;	/* Free inodes count */
+	__u32	bg_used_dirs_count;	/* Directories count */
+	__u16	bg_flags;
+	__u16	bg_pad;
+	__u32	bg_reserved[6];
+};
+
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
 
@@ -524,12 +537,15 @@
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
@@ -586,6 +602,7 @@
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008 /* Journal device */
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
 #define EXT3_FEATURE_INCOMPAT_EXTENTS		0x0040
+#define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
