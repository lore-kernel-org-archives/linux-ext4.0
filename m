From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Reserve feature flags and fields needed for the Next3 snapshot feature
Date: Wed,  2 Jun 2010 10:43:15 -0400
Message-ID: <1275489795-25639-1-git-send-email-tytso@mit.edu>
Cc: amir73il@users.sourceforge.net, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33075 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0FBOnR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jun 2010 10:43:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The documentation is not (as of this writing) fully complete, but
there is some documentation here:

http://sourceforge.net/apps/mediawiki/next3/index.php?title=Code_documentation
http://sourceforge.net/apps/mediawiki/next3/index.php?title=On-disk_format
http://sourceforge.net/projects/next3/files/Next3_Snapshots.pdf/download

... which will hopefully be updated soon to be fully up to date with
these assignments and more details about how things work.

For now, the assignments should avoid collisions with other new work
that people might want to do on ext3/4.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2_fs.h |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index cb21318..8735105 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -50,6 +50,7 @@
 #define EXT2_UNDEL_DIR_INO	 6	/* Undelete directory inode */
 #define EXT2_RESIZE_INO		 7	/* Reserved group descriptors inode */
 #define EXT2_JOURNAL_INO	 8	/* Journal inode */
+#define EXT2_EXCLUDE_INO	 9	/* The "exclude" inode, for snapshots */
 
 /* First non-reserved inode for old ext2 filesystems */
 #define EXT2_GOOD_OLD_FIRST_INO	11
@@ -275,6 +276,9 @@ struct ext2_dx_countlimit {
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
+#define EXT4_SNAPFILE_FL		0x01000000  /* Inode is a snapshot */
+#define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
+#define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
 #define EXT2_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
@@ -463,6 +467,9 @@ struct ext2_inode_large {
 #define EXT2_FLAGS_SIGNED_HASH		0x0001  /* Signed dirhash in use */
 #define EXT2_FLAGS_UNSIGNED_HASH	0x0002  /* Unsigned dirhash in use */
 #define EXT2_FLAGS_TEST_FILESYS		0x0004	/* OK for use on development code */
+#define EXT2_FLAGS_IS_SNAPSHOT		0x0010	/* This is a snapshot image */
+#define EXT2_FLAGS_FIX_SNAPSHOT		0x0020	/* Snapshot inodes corrupted */
+#define EXT2_FLAGS_FIX_EXCLUDE		0x0040	/* Exclude bitmaps corrupted */
 
 /*
  * Mount flags
@@ -582,7 +589,12 @@ struct ext2_super_block {
 	__u8    s_reserved_char_pad;
 	__u16	s_reserved_pad;		/* Padding to next 32bits */
 	__u64	s_kbytes_written;	/* nr of lifetime kilobytes written */
-	__u32   s_reserved[160];        /* Padding to the end of the block */
+	__u32	s_snapshot_inum;	/* Inode number of active snapshot */
+	__u32	s_snapshot_id;		/* sequential ID of active snapshot */
+	__u64	s_snapshot_r_blocks_count; /* reserved blocks for active
+					      snapshot's future use */
+	__u32	s_snapshot_list;	/* inode number of the head of the on-disk snapshot list */
+	__u32   s_reserved[155];        /* Padding to the end of the block */
 };
 
 /*
@@ -628,6 +640,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT2_FEATURE_COMPAT_DIR_INDEX		0x0020
 #define EXT2_FEATURE_COMPAT_LAZY_BG		0x0040
+#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE	0x0080
 
 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
@@ -636,6 +649,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
+#define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
-- 
1.6.6.1.1.g974db.dirty

