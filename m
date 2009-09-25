From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] pu branch: make fs->group_desc opaque
Date: Thu, 24 Sep 2009 21:35:47 -0500
Message-ID: <4ABC2C83.8080504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbZIYCfs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Sep 2009 22:35:48 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8P2ZqvQ016886
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2009 22:35:52 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8P2ZlDN001824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2009 22:35:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To prevent direct array indexing of fs->group_desc[i] (because
the group_desc may be a different size for different filesystems)
make it an opaque pointer that may only be accessed through the
accessor functions in blknum.c.  The type itself is still available
in a public header; if we have a group_desc that we know is one type
or another, it's ok to access its fields directly.  This change only
prevents us from indexing off fs->group_desc[i] directly.

Change the accessors in blknum.c to use ext4fs_group_desc(), a version
of ext2fs_group_desc() which returns a ext3_group_desc pointer.

This simplifies and collapses a fair bit of code in blknum.c

Tested with "make check" but no 64-bit testing yet.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(Note, this applies after my "e2fsprogs: clean up ext2fs_bg_flags interfaces"
patch sent on 9/09/09)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index aa4d94c..9cb67f1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -198,6 +198,8 @@ typedef struct ext2_file *ext2_file_t;
  */
 #define EXT2_MKJOURNAL_V1_SUPER	0x0000001
 
+struct opaque_ext2_group_desc;
+
 struct struct_ext2_filsys {
 	errcode_t			magic;
 	io_channel			io;
@@ -208,7 +210,7 @@ struct struct_ext2_filsys {
 	int				fragsize;
 	dgrp_t				group_desc_count;
 	unsigned long			desc_blocks;
-	struct ext2_group_desc *	group_desc;
+	struct opaque_ext2_group_desc *	group_desc;
 	int				inode_blocks_per_group;
 	ext2fs_inode_bitmap		inode_map;
 	ext2fs_block_bitmap		block_map;
@@ -752,7 +754,7 @@ extern void ext2fs_free_blocks_count_add(struct ext2_super_block *super,
 					 blk64_t blk);
 /* Block group descriptor accessor functions */
 extern struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
-					  struct ext2_group_desc *gdp,
+					  struct opaque_ext2_group_desc *gdp,
 					  dgrp_t group);
 extern blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index 91abdfb..bcbfc72 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -162,7 +162,7 @@ void ext2fs_free_blocks_count_add(struct ext2_super_block *super, blk64_t blk)
  * do the swap there.
  */
 struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
-					  struct ext2_group_desc *gdp,
+					  struct opaque_ext2_group_desc *gdp,
 					  dgrp_t group)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT)
@@ -172,22 +172,26 @@ struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
 		return (struct ext2_group_desc *) gdp + group;
 }
 
+/* Do the same but as an ext4 group desc for internal use here */
+static struct ext4_group_desc *ext4fs_group_desc(ext2_filsys fs,
+					  struct opaque_ext2_group_desc *gdp,
+					  dgrp_t group)
+{
+	return (struct ext4_group_desc *)ext2fs_group_desc(fs, gdp, group);
+}
+
 /*
  * Return the block bitmap block of a group
  */
 blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+	struct ext4_group_desc *gdp;
 
-		return gdp->bg_block_bitmap |
-			(fs->super->s_feature_incompat
-			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u64) gdp->bg_block_bitmap_hi << 32 : 0);
-	}
-
-	return fs->group_desc[group].bg_block_bitmap;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_block_bitmap |
+		(fs->super->s_feature_incompat
+		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		 (__u64)gdp->bg_block_bitmap_hi << 32 : 0);
 }
 
 /*
@@ -195,14 +199,12 @@ blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group)
  */
 void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_block_bitmap = blk;
-		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_block_bitmap_hi = (__u64) blk >> 32;
-	} else
-		fs->group_desc[group].bg_block_bitmap = blk;
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_block_bitmap = blk;
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		gdp->bg_block_bitmap_hi = (__u64) blk >> 32;
 }
 
 /*
@@ -210,17 +212,13 @@ void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
  */
 blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-
-		return gdp->bg_inode_bitmap |
-			(fs->super->s_feature_incompat
-			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u64) gdp->bg_inode_bitmap_hi << 32 : 0);
-	}
+	struct ext4_group_desc *gdp;
 
-	return fs->group_desc[group].bg_inode_bitmap;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_inode_bitmap |
+		(fs->super->s_feature_incompat
+		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		 (__u64) gdp->bg_inode_bitmap_hi << 32 : 0);
 }
 
 /*
@@ -228,14 +226,12 @@ blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group)
  */
 void ext2fs_inode_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_inode_bitmap = blk;
-		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_inode_bitmap_hi = (__u64) blk >> 32;
-	} else
-		fs->group_desc[group].bg_inode_bitmap = blk;
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_inode_bitmap = blk;
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		gdp->bg_inode_bitmap_hi = (__u64) blk >> 32;
 }
 
 /*
@@ -243,17 +239,13 @@ void ext2fs_inode_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
  */
 blk64_t ext2fs_inode_table_loc(ext2_filsys fs, dgrp_t group)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-
-		return gdp->bg_inode_table |
-			(fs->super->s_feature_incompat
-			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u64) gdp->bg_inode_table_hi << 32 : 0);
-	}
+	struct ext4_group_desc *gdp;
 
-	return fs->group_desc[group].bg_inode_table;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_inode_table |
+		(fs->super->s_feature_incompat
+		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		 (__u64) gdp->bg_inode_table_hi << 32 : 0);
 }
 
 /*
@@ -261,14 +253,12 @@ blk64_t ext2fs_inode_table_loc(ext2_filsys fs, dgrp_t group)
  */
 void ext2fs_inode_table_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_inode_table = blk;
-		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_inode_table_hi = (__u64) blk >> 32;
-	} else
-		fs->group_desc[group].bg_inode_table = blk;
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_inode_table = blk;
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		gdp->bg_inode_table_hi = (__u64) blk >> 32;
 }
 
 /*
@@ -276,17 +266,13 @@ void ext2fs_inode_table_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
  */
 __u32 ext2fs_bg_free_blocks_count(ext2_filsys fs, dgrp_t group)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+	struct ext4_group_desc *gdp;
 
-		return gdp->bg_free_blocks_count |
-			(fs->super->s_feature_incompat
-			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u32) gdp->bg_free_blocks_count_hi << 16 : 0);
-	}
-
-	return fs->group_desc[group].bg_free_blocks_count;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_free_blocks_count |
+		(fs->super->s_feature_incompat
+		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		 (__u32) gdp->bg_free_blocks_count_hi << 16 : 0);
 }
 
 /*
@@ -294,14 +280,13 @@ __u32 ext2fs_bg_free_blocks_count(ext2_filsys fs, dgrp_t group)
  */
 void ext2fs_bg_free_blocks_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_free_blocks_count = n;
-		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_free_blocks_count_hi = (__u32) n >> 16;
-	} else
-		fs->group_desc[group].bg_free_blocks_count = n;
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_free_blocks_count = n;
+
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		gdp->bg_free_blocks_count_hi = (__u32) n >> 16;
 }
 
 /*
@@ -309,17 +294,13 @@ void ext2fs_bg_free_blocks_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
  */
 __u32 ext2fs_bg_free_inodes_count(ext2_filsys fs, dgrp_t group)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+	struct ext4_group_desc *gdp;
 
-		return gdp->bg_free_inodes_count |
-			(fs->super->s_feature_incompat
-			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u32) gdp->bg_free_inodes_count_hi << 16 : 0);
-	}
-
-	return fs->group_desc[group].bg_free_inodes_count;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_free_inodes_count |
+		(fs->super->s_feature_incompat
+		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		 (__u32) gdp->bg_free_inodes_count_hi << 16 : 0);
 }
 
 /*
@@ -327,14 +308,12 @@ __u32 ext2fs_bg_free_inodes_count(ext2_filsys fs, dgrp_t group)
  */
 void ext2fs_bg_free_inodes_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_free_inodes_count = n;
-		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_free_inodes_count_hi = (__u32) n >> 16;
-	} else
-		fs->group_desc[group].bg_free_inodes_count = n;
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_free_inodes_count = n;
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		gdp->bg_free_inodes_count_hi = (__u32) n >> 16;
 }
 
 /*
@@ -342,17 +321,13 @@ void ext2fs_bg_free_inodes_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
  */
 __u32 ext2fs_bg_used_dirs_count(ext2_filsys fs, dgrp_t group)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-
-		return gdp->bg_used_dirs_count |
-			(fs->super->s_feature_incompat
-			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u32) gdp->bg_used_dirs_count_hi << 16 : 0);
-	}
+	struct ext4_group_desc *gdp;
 
-	return fs->group_desc[group].bg_used_dirs_count;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_used_dirs_count |
+		(fs->super->s_feature_incompat
+		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		 (__u32) gdp->bg_used_dirs_count_hi << 16 : 0);
 }
 
 /*
@@ -360,14 +335,12 @@ __u32 ext2fs_bg_used_dirs_count(ext2_filsys fs, dgrp_t group)
  */
 void ext2fs_bg_used_dirs_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_used_dirs_count = n;
-		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_used_dirs_count_hi = (__u32) n >> 16;
-	} else
-		fs->group_desc[group].bg_used_dirs_count = n;
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_used_dirs_count = n;
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		gdp->bg_used_dirs_count_hi = (__u32) n >> 16;
 }
 
 /*
@@ -375,17 +348,13 @@ void ext2fs_bg_used_dirs_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
  */
 __u32 ext2fs_bg_itable_unused(ext2_filsys fs, dgrp_t group)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-
-		return gdp->bg_itable_unused |
-			(fs->super->s_feature_incompat
-			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u32) gdp->bg_itable_unused_hi << 16 : 0);
-	}
+	struct ext4_group_desc *gdp;
 
-	return fs->group_desc[group].bg_itable_unused;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_itable_unused |
+		(fs->super->s_feature_incompat
+		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		 (__u32) gdp->bg_itable_unused_hi << 16 : 0);
 }
 
 /*
@@ -393,14 +362,12 @@ __u32 ext2fs_bg_itable_unused(ext2_filsys fs, dgrp_t group)
  */
 void ext2fs_bg_itable_unused_set(ext2_filsys fs, dgrp_t group, __u32 n)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_itable_unused = n;
-		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_itable_unused_hi = (__u32) n >> 16;
-	} else
-		fs->group_desc[group].bg_itable_unused = n;
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_itable_unused = n;
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		gdp->bg_itable_unused_hi = (__u32) n >> 16;
 }
 
 /*
@@ -408,14 +375,10 @@ void ext2fs_bg_itable_unused_set(ext2_filsys fs, dgrp_t group, __u32 n)
  */
 __u16 ext2fs_bg_flags(ext2_filsys fs, dgrp_t group)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+	struct ext4_group_desc *gdp;
 
-		return gdp->bg_flags;
-	}
-
-	return fs->group_desc[group].bg_flags;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_flags;
 }
 
 /*
@@ -423,15 +386,11 @@ __u16 ext2fs_bg_flags(ext2_filsys fs, dgrp_t group)
  */
 void ext2fs_bg_flags_zap(ext2_filsys fs, dgrp_t group)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-
-		gdp->bg_flags = 0;
-		return;
-	}
+	struct ext4_group_desc *gdp;
 
-	fs->group_desc[group].bg_flags = 0;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_flags = 0;
+	return;
 }
 
 /*
@@ -439,14 +398,10 @@ void ext2fs_bg_flags_zap(ext2_filsys fs, dgrp_t group)
  */
 int ext2fs_bg_flag_test(ext2_filsys fs, dgrp_t group, __u16 bg_flag)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-
-		return gdp->bg_flags & bg_flag;
-	}
+	struct ext4_group_desc *gdp;
 
-	return fs->group_desc[group].bg_flags & bg_flag;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_flags & bg_flag;
 }
 
 /*
@@ -454,15 +409,11 @@ int ext2fs_bg_flag_test(ext2_filsys fs, dgrp_t group, __u16 bg_flag)
  */
 void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+	struct ext4_group_desc *gdp;
 
-		gdp->bg_flags |= bg_flags;
-		return;
-	}
-
-	fs->group_desc[group].bg_flags |= bg_flags;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_flags |= bg_flags;
+	return;
 }
 
 /*
@@ -470,15 +421,11 @@ void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags)
  */
 void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flags)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-
-		gdp->bg_flags &= ~bg_flags;
-		return;
-	}
+	struct ext4_group_desc *gdp;
 
-	fs->group_desc[group].bg_flags &= ~bg_flags;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_flags &= ~bg_flags;
+	return;
 }
 
 /*
@@ -486,14 +433,10 @@ void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flags)
  */
 __u16 ext2fs_bg_checksum(ext2_filsys fs, dgrp_t group)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-
-		return gdp->bg_checksum;
-	}
+	struct ext4_group_desc *gdp;
 
-	return fs->group_desc[group].bg_checksum;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_checksum;
 }
 
 /*
@@ -501,15 +444,11 @@ __u16 ext2fs_bg_checksum(ext2_filsys fs, dgrp_t group)
  */
 void ext2fs_bg_checksum_set(ext2_filsys fs, dgrp_t group, __u16 checksum)
 {
-	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
-		struct ext4_group_desc *gdp;
-		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		
-		gdp->bg_checksum = checksum;
-		return;
-	}
+	struct ext4_group_desc *gdp;
 
-	fs->group_desc[group].bg_checksum = checksum;
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_checksum = checksum;
+	return;
 }
 
 /*


