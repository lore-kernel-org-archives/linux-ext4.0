From: akpm@linux-foundation.org
Subject: - ext2-allocate-s_blockgroup_lock-separately.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:52 -0800
Message-ID: <200901082246.n08Mkqnh026384@imap1.linux-foundation.org>
To: penberg@cs.helsinki.fi, adilger@sun.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757599AbZAHWr0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jan 2009 17:47:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext2: allocate ->s_blockgroup_lock separately
has been removed from the -mm tree.  Its filename was
     ext2-allocate-s_blockgroup_lock-separately.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: allocate ->s_blockgroup_lock separately
From: Pekka J Enberg <penberg@cs.helsinki.fi>

As spotted by kmemtrace, struct ext2_sb_info is 17024 bytes on 64-bit
which makes it a very bad fit for SLAB allocators.  The culprit of the
wasted memory is ->s_blockgroup_lock which can be as big as 16 KB when
NR_CPUS >= 32.

To fix that, allocate ->s_blockgroup_lock, which fits nicely in a order 2
page in the worst case, separately.  This shinks down struct ext2_sb_info
enough to fit a 1 KB slab cache so now we allocate 16 KB + 1 KB instead of
32 KB saving 15 KB of memory.

Acked-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c            |   10 +++++++++-
 include/linux/ext2_fs_sb.h |    4 ++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/ext2/super.c~ext2-allocate-s_blockgroup_lock-separately fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-allocate-s_blockgroup_lock-separately
+++ a/fs/ext2/super.c
@@ -132,6 +132,7 @@ static void ext2_put_super (struct super
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	brelse (sbi->s_sbh);
 	sb->s_fs_info = NULL;
+	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 
 	return;
@@ -756,6 +757,13 @@ static int ext2_fill_super(struct super_
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
 	sbi->s_sb_block = sb_block;
 
@@ -983,7 +991,7 @@ static int ext2_fill_super(struct super_
 		printk ("EXT2-fs: not enough memory\n");
 		goto failed_mount;
 	}
-	bgl_lock_init(&sbi->s_blockgroup_lock);
+	bgl_lock_init(sbi->s_blockgroup_lock);
 	sbi->s_debts = kcalloc(sbi->s_groups_count, sizeof(*sbi->s_debts), GFP_KERNEL);
 	if (!sbi->s_debts) {
 		printk ("EXT2-fs: not enough memory\n");
diff -puN include/linux/ext2_fs_sb.h~ext2-allocate-s_blockgroup_lock-separately include/linux/ext2_fs_sb.h
--- a/include/linux/ext2_fs_sb.h~ext2-allocate-s_blockgroup_lock-separately
+++ a/include/linux/ext2_fs_sb.h
@@ -101,7 +101,7 @@ struct ext2_sb_info {
 	struct percpu_counter s_freeblocks_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
-	struct blockgroup_lock s_blockgroup_lock;
+	struct blockgroup_lock *s_blockgroup_lock;
 	/* root of the per fs reservation window tree */
 	spinlock_t s_rsv_window_lock;
 	struct rb_root s_rsv_window_root;
@@ -111,7 +111,7 @@ struct ext2_sb_info {
 static inline spinlock_t *
 sb_bgl_lock(struct ext2_sb_info *sbi, unsigned int block_group)
 {
-	return bgl_lock_ptr(&sbi->s_blockgroup_lock, block_group);
+	return bgl_lock_ptr(sbi->s_blockgroup_lock, block_group);
 }
 
 #endif	/* _LINUX_EXT2_FS_SB */
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
ext4-allocate-s_blockgroup_lock-separately.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
slab-leaks3-default-y.patch

