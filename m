From: akpm@linux-foundation.org
Subject: [patch 1/1] ext4: allocate ->s_blockgroup_lock separately
Date: Mon, 01 Dec 2008 14:27:04 -0800
Message-ID: <200812012227.mB1MR4ot016548@imap1.linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	penberg@cs.helsinki.fi, adilger@sun.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYLAW15 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 17:27:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Pekka Enberg <penberg@cs.helsinki.fi>

As spotted by kmemtrace, struct ext4_sb_info is 17664 bytes on 64-bit
which makes it a very bad fit for SLAB allocators.  The culprit of the
wasted memory is ->s_blockgroup_lock which can be as big as 16 KB when
NR_CPUS >= 32.

To fix that, allocate ->s_blockgroup_lock, which fits nicely in a order 2
page in the worst case, separately.  This shinks down struct ext4_sb_info
enough to fit a 2 KB slab cache so now we allocate 16 KB + 2 KB instead of
32 KB saving 14 KB of memory.

Acked-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4_sb.h |    4 ++--
 fs/ext4/super.c   |   10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/ext4/ext4_sb.h~ext4-allocate-s_blockgroup_lock-separately fs/ext4/ext4_sb.h
--- a/fs/ext4/ext4_sb.h~ext4-allocate-s_blockgroup_lock-separately
+++ a/fs/ext4/ext4_sb.h
@@ -62,7 +62,7 @@ struct ext4_sb_info {
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
 	struct percpu_counter s_dirtyblocks_counter;
-	struct blockgroup_lock s_blockgroup_lock;
+	struct blockgroup_lock *s_blockgroup_lock;
 	struct proc_dir_entry *s_proc;
 
 	/* root of the per fs reservation window tree */
@@ -150,7 +150,7 @@ struct ext4_sb_info {
 static inline spinlock_t *
 sb_bgl_lock(struct ext4_sb_info *sbi, unsigned int block_group)
 {
-	return bgl_lock_ptr(&sbi->s_blockgroup_lock, block_group);
+	return bgl_lock_ptr(sbi->s_blockgroup_lock, block_group);
 }
 
 #endif	/* _EXT4_SB */
diff -puN fs/ext4/super.c~ext4-allocate-s_blockgroup_lock-separately fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-allocate-s_blockgroup_lock-separately
+++ a/fs/ext4/super.c
@@ -497,6 +497,7 @@ static void ext4_put_super(struct super_
 		ext4_blkdev_remove(sbi);
 	}
 	sb->s_fs_info = NULL;
+	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	return;
 }
@@ -1886,6 +1887,13 @@ static int ext4_fill_super(struct super_
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
 	sbi->s_resuid = EXT4_DEF_RESUID;
@@ -2194,7 +2202,7 @@ static int ext4_fill_super(struct super_
 				 &sbi->s_inode_readahead_blks);
 #endif
 
-	bgl_lock_init(&sbi->s_blockgroup_lock);
+	bgl_lock_init(sbi->s_blockgroup_lock);
 
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
_
