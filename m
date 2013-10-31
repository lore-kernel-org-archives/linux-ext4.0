From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] mmp: fix 64-bit handling of s_mmp_block
Date: Thu, 31 Oct 2013 15:01:00 -0600
Message-ID: <1383253260-22873-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-03.shaw.ca ([64.59.136.139]:34393 "EHLO
	smtp-out-02.shaw.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752693Ab3JaVKp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Oct 2013 17:10:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix the checking of s_mmp_block in e2fsck_pass1() and
ext2fs_mmp_read() to handle the high 32 bits of s_blocks_count.
Remove redundant check of s_mmp_block in do_dump_mmp() right before
ext2fs_mmp_read() is called.

Also fix s_blocks_count_hi in check_backup_super_block(), since it
cannot use the ext2fs_blocks_count() helper easily.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/debugfs.c |    7 +------
 e2fsck/pass1.c    |    4 ++--
 e2fsck/super.c    |    1 +
 lib/ext2fs/mmp.c  |    2 +-
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 5590295..5502570 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2311,12 +2311,7 @@ void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 	if (check_fs_open(argv[0]))
 		return;
 
-	sb  = current_fs->super;
-	if (sb->s_mmp_block <= sb->s_first_data_block ||
-	    sb->s_mmp_block >= ext2fs_blocks_count(sb)) {
-		com_err(argv[0], EXT2_ET_MMP_BAD_BLOCK, "while dumping it.\n");
-		return;
-	}
+	sb = current_fs->super;
 
 	if (current_fs->mmp_buf == NULL) {
 		retval = ext2fs_get_mem(current_fs->blocksize,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 311706e..13028b2 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -716,8 +716,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 		busted_fs_time = 1;
 
 	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
-	    !(fs->super->s_mmp_block <= fs->super->s_first_data_block ||
-	      fs->super->s_mmp_block >= fs->super->s_blocks_count))
+	    fs->super->s_mmp_block > fs->super->s_first_data_block &&
+	    fs->super->s_mmp_block < ext2fs_blocks_count(fs->super))
 		ext2fs_mark_block_bitmap2(ctx->block_found_map,
 					  fs->super->s_mmp_block);
 
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 352f16d..db3e63a 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -956,6 +956,7 @@ int check_backup_super_block(e2fsck_t ctx)
 		    SUPER_INCOMPAT_DIFFERENT(s_feature_incompat) ||
 		    SUPER_RO_COMPAT_DIFFERENT(s_feature_ro_compat) ||
 		    SUPER_DIFFERENT(s_blocks_count) ||
+		    SUPER_DIFFERENT(s_blocks_count_hi) ||
 		    SUPER_DIFFERENT(s_inodes_count) ||
 		    memcmp(fs->super->s_uuid, backup_sb->s_uuid,
 			   sizeof(fs->super->s_uuid)))
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index 98562e7..fb266d1 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -37,7 +37,7 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 	errcode_t retval = 0;
 
 	if ((mmp_blk <= fs->super->s_first_data_block) ||
-	    (mmp_blk >= fs->super->s_blocks_count))
+	    (mmp_blk >= ext2fs_blocks_count(fs->super)))
 		return EXT2_ET_MMP_BAD_BLOCK;
 
 	/* ext2fs_open() reserves fd0,1,2 to avoid stdio collision, so checking
-- 
1.7.3.4

