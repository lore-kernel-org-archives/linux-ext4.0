From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Wed, 02 Sep 2009 17:02:22 -0400
Message-ID: <13135.1251925342@alphaville.usa.hp.com>
References: <4A9D9574.3010606@redhat.com> <20090902055953.GF4197@webber.adilger.int> <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com>  <4A9EA09E.10509@redhat.com>
Reply-To: nicholas.dokos@hp.com
Cc: Justin Maggard <jmaggard10@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:28223 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZIBVCT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 17:02:19 -0400
Cc: nicholas.dokos@hp.com
In-Reply-To: Message from Eric Sandeen <sandeen@redhat.com>
   of "Wed, 02 Sep 2009 11:43:10 CDT." <4A9EA09E.10509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Justin Maggard wrote:
> > On Tue, Sep 1, 2009 at 10:59 PM, Andreas Dilger<adilger@sun.com> wrote:
> >> On Sep 01, 2009  16:43 -0500, Eric Sandeen wrote:
> >>> ext2fs_open2() was only looking at s_blocks_count, and
> >>> when it wrapped to a low number, it was failing the test of:
> >>>
> >>>   fs->super->s_first_data_block >= fs->super->s_blocks_count
> >>>
> >>> which made the superblock look corrupt.
> >> Is this the source of the "e2fsck is finding bad checksums" problem?
> > 
> > I applied this earlier today, and it didn't appear to help in my test case.
> > 
> > -Justin
> 
> Nah, didn't expect it to, but I'm working towards that.  Just have to
> whack down the bugs between where I am, and your bug ;)
> 
> -Eric

The following patch fixes a problem I think, but I'm not sure whether it
resolves Justin's problem. I'm running a test, but I thought I'd send it
out for people to try and/or comment on. Let me know of any problems.

Thanks,
Nick

>From e8c790ab8a0f06b4c89a5b6ddba2a36f033c742c Mon Sep 17 00:00:00 2001
From: Nick Dokos <nicholas.dokos@hp.com>
Date: Wed, 2 Sep 2009 16:52:09 -0400
Subject: [PATCH] Fix counting routines in blknum.c to take/return __u32 counts.

Several routines in lib/ext2fs/blknum.c:

        ext2fs_bg_free_blocks_count()
        ext2fs_bg_free_inodes_count()
        ext2fs_bg_used_dirs_count()
        ext2fs_bg_itable_unused()

and their _set() counterparts, operate as if they are dealing with
blk64_t quantities, but they should be dealing with __u32 counts
instead.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/blknum.c |   48 ++++++++++++++++++++++++------------------------
 lib/ext2fs/ext2fs.h |   16 ++++++++--------
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index fd56d53..1f183f4 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -274,7 +274,7 @@ void ext2fs_inode_table_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 /*
  * Return the free blocks count of a group
  */
-blk64_t ext2fs_bg_free_blocks_count(ext2_filsys fs, dgrp_t group)
+__u32 ext2fs_bg_free_blocks_count(ext2_filsys fs, dgrp_t group)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
@@ -283,7 +283,7 @@ blk64_t ext2fs_bg_free_blocks_count(ext2_filsys fs, dgrp_t group)
 		return gdp->bg_free_blocks_count |
 			(fs->super->s_feature_incompat
 			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u64) gdp->bg_free_blocks_count_hi << 32 : 0);
+			 (__u32) gdp->bg_free_blocks_count_hi << 16 : 0);
 	}
 
 	return fs->group_desc[group].bg_free_blocks_count;
@@ -292,22 +292,22 @@ blk64_t ext2fs_bg_free_blocks_count(ext2_filsys fs, dgrp_t group)
 /*
  * Set the free blocks count of a group
  */
-void ext2fs_bg_free_blocks_count_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
+void ext2fs_bg_free_blocks_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
 		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_free_blocks_count = blk;
+		gdp->bg_free_blocks_count = n;
 		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_free_blocks_count_hi = (__u64) blk >> 32;
+			gdp->bg_free_blocks_count_hi = (__u32) n >> 16;
 	} else
-		fs->group_desc[group].bg_free_blocks_count = blk;
+		fs->group_desc[group].bg_free_blocks_count = n;
 }
 
 /*
  * Return the free inodes count of a group
  */
-blk64_t ext2fs_bg_free_inodes_count(ext2_filsys fs, dgrp_t group)
+__u32 ext2fs_bg_free_inodes_count(ext2_filsys fs, dgrp_t group)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
@@ -316,7 +316,7 @@ blk64_t ext2fs_bg_free_inodes_count(ext2_filsys fs, dgrp_t group)
 		return gdp->bg_free_inodes_count |
 			(fs->super->s_feature_incompat
 			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u64) gdp->bg_free_inodes_count_hi << 32 : 0);
+			 (__u32) gdp->bg_free_inodes_count_hi << 16 : 0);
 	}
 
 	return fs->group_desc[group].bg_free_inodes_count;
@@ -325,22 +325,22 @@ blk64_t ext2fs_bg_free_inodes_count(ext2_filsys fs, dgrp_t group)
 /*
  * Set the free inodes count of a group
  */
-void ext2fs_bg_free_inodes_count_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
+void ext2fs_bg_free_inodes_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
 		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_free_inodes_count = blk;
+		gdp->bg_free_inodes_count = n;
 		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_free_inodes_count_hi = (__u64) blk >> 32;
+			gdp->bg_free_inodes_count_hi = (__u32) n >> 16;
 	} else
-		fs->group_desc[group].bg_free_inodes_count = blk;
+		fs->group_desc[group].bg_free_inodes_count = n;
 }
 
 /*
  * Return the used dirs count of a group
  */
-blk64_t ext2fs_bg_used_dirs_count(ext2_filsys fs, dgrp_t group)
+__u32 ext2fs_bg_used_dirs_count(ext2_filsys fs, dgrp_t group)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
@@ -349,7 +349,7 @@ blk64_t ext2fs_bg_used_dirs_count(ext2_filsys fs, dgrp_t group)
 		return gdp->bg_used_dirs_count |
 			(fs->super->s_feature_incompat
 			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u64) gdp->bg_used_dirs_count_hi << 32 : 0);
+			 (__u32) gdp->bg_used_dirs_count_hi << 16 : 0);
 	}
 
 	return fs->group_desc[group].bg_used_dirs_count;
@@ -358,22 +358,22 @@ blk64_t ext2fs_bg_used_dirs_count(ext2_filsys fs, dgrp_t group)
 /*
  * Set the used dirs count of a group
  */
-void ext2fs_bg_used_dirs_count_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
+void ext2fs_bg_used_dirs_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
 		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_used_dirs_count = blk;
+		gdp->bg_used_dirs_count = n;
 		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_used_dirs_count_hi = (__u64) blk >> 32;
+			gdp->bg_used_dirs_count_hi = (__u32) n >> 16;
 	} else
-		fs->group_desc[group].bg_used_dirs_count = blk;
+		fs->group_desc[group].bg_used_dirs_count = n;
 }
 
 /*
  * Return the unused inodes count of a group
  */
-blk64_t ext2fs_bg_itable_unused(ext2_filsys fs, dgrp_t group)
+__u32 ext2fs_bg_itable_unused(ext2_filsys fs, dgrp_t group)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
@@ -382,7 +382,7 @@ blk64_t ext2fs_bg_itable_unused(ext2_filsys fs, dgrp_t group)
 		return gdp->bg_itable_unused |
 			(fs->super->s_feature_incompat
 			 & EXT4_FEATURE_INCOMPAT_64BIT ?
-			 (__u64) gdp->bg_itable_unused_hi << 32 : 0);
+			 (__u32) gdp->bg_itable_unused_hi << 16 : 0);
 	}
 
 	return fs->group_desc[group].bg_itable_unused;
@@ -391,16 +391,16 @@ blk64_t ext2fs_bg_itable_unused(ext2_filsys fs, dgrp_t group)
 /*
  * Set the unused inodes count of a group
  */
-void ext2fs_bg_itable_unused_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
+void ext2fs_bg_itable_unused_set(ext2_filsys fs, dgrp_t group, __u32 n)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
 		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
-		gdp->bg_itable_unused = blk;
+		gdp->bg_itable_unused = n;
 		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
-			gdp->bg_itable_unused_hi = (__u64) blk >> 32;
+			gdp->bg_itable_unused_hi = (__u32) n >> 16;
 	} else
-		fs->group_desc[group].bg_itable_unused = blk;
+		fs->group_desc[group].bg_itable_unused = n;
 }
 
 /*
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c564acf..4c5313c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -763,18 +763,18 @@ extern void ext2fs_inode_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 extern blk64_t ext2fs_inode_table_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_inode_table_loc_set(ext2_filsys fs, dgrp_t group,
 				       blk64_t blk);
-extern blk64_t ext2fs_bg_free_blocks_count(ext2_filsys fs, dgrp_t group);
+extern __u32 ext2fs_bg_free_blocks_count(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_bg_free_blocks_count_set(ext2_filsys fs, dgrp_t group,
-					 blk64_t blk);
-extern blk64_t ext2fs_bg_free_inodes_count(ext2_filsys fs, dgrp_t group);
+					 __u32 n);
+extern __u32 ext2fs_bg_free_inodes_count(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_bg_free_inodes_count_set(ext2_filsys fs, dgrp_t group,
-					 blk64_t blk);
-extern blk64_t ext2fs_bg_used_dirs_count(ext2_filsys fs, dgrp_t group);
+					 __u32 n);
+extern __u32 ext2fs_bg_used_dirs_count(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_bg_used_dirs_count_set(ext2_filsys fs, dgrp_t group,
-				       blk64_t blk);
-extern blk64_t ext2fs_bg_itable_unused(ext2_filsys fs, dgrp_t group);
+				       __u32 n);
+extern __u32 ext2fs_bg_itable_unused(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_bg_itable_unused_set(ext2_filsys fs, dgrp_t group,
-				     blk64_t blk);
+				     __u32 n);
 extern __u16 ext2fs_bg_flags(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
 extern void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group,
-- 
1.6.0.6

