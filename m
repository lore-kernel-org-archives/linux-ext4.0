From: akpm@linux-foundation.org
Subject: [patch 010/123] ext3: allocate ->s_blockgroup_lock separately
Date: Wed, 07 Jan 2009 18:07:25 -0800
Message-ID: <200901080207.n0827P5J011687@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, penberg@cs.helsinki.fi, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbZAHCPH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2009 21:15:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Pekka Enberg <penberg@cs.helsinki.fi>

As spotted by kmemtrace, struct ext3_sb_info is 17152 bytes on 64-bit
which makes it a very bad fit for SLAB allocators.  The culprit of the
wasted memory is ->s_blockgroup_lock which can be as big as 16 KB when
NR_CPUS >= 32.

To fix that, allocate ->s_blockgroup_lock, which fits nicely in a order 2
page in the worst case, separately.  This shinks down struct ext3_sb_info
enough to fit a 1 KB slab cache so now we allocate 16 KB + 1 KB instead of
32 KB saving 15 KB of memory.

Acked-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c            |   10 +++++++++-
 include/linux/ext3_fs_sb.h |    4 ++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/ext3/super.c~ext3-allocate-s_blockgroup_lock-separately fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-allocate-s_blockgroup_lock-separately
+++ a/fs/ext3/super.c
@@ -439,6 +439,7 @@ static void ext3_put_super (struct super
 		ext3_blkdev_remove(sbi);
 	}
 	sb->s_fs_info = NULL;
+	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	return;
 }
@@ -1546,6 +1547,13 @@ static int ext3_fill_super (struct super
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
+
+	sbi->s_blockgroup_lock =
+		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
+	if (!sbi->s_blockgroup_lock) {
+		kfree(sbi);
+		return -ENOMEM;
+	}
 	sb->s_fs_info = sbi;
 	sbi->s_mount_opt = 0;
 	sbi->s_resuid = EXT3_DEF_RESUID;
@@ -1786,7 +1794,7 @@ static int ext3_fill_super (struct super
 		goto failed_mount;
 	}
 
-	bgl_lock_init(&sbi->s_blockgroup_lock);
+	bgl_lock_init(sbi->s_blockgroup_lock);
 
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logic_sb_block, i);
diff -puN include/linux/ext3_fs_sb.h~ext3-allocate-s_blockgroup_lock-separately include/linux/ext3_fs_sb.h
--- a/include/linux/ext3_fs_sb.h~ext3-allocate-s_blockgroup_lock-separately
+++ a/include/linux/ext3_fs_sb.h
@@ -60,7 +60,7 @@ struct ext3_sb_info {
 	struct percpu_counter s_freeblocks_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
-	struct blockgroup_lock s_blockgroup_lock;
+	struct blockgroup_lock *s_blockgroup_lock;
 
 	/* root of the per fs reservation window tree */
 	spinlock_t s_rsv_window_lock;
@@ -86,7 +86,7 @@ struct ext3_sb_info {
 static inline spinlock_t *
 sb_bgl_lock(struct ext3_sb_info *sbi, unsigned int block_group)
 {
-	return bgl_lock_ptr(&sbi->s_blockgroup_lock, block_group);
+	return bgl_lock_ptr(sbi->s_blockgroup_lock, block_group);
 }
 
 #endif	/* _LINUX_EXT3_FS_SB */
_
