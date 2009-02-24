From: akpm@linux-foundation.org
Subject: [merged] ext4-allocate-s_blockgroup_lock-separately.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:32:54 -0800
Message-ID: <200902241932.n1OJWs5h004466@imap1.linux-foundation.org>
To: penberg@cs.helsinki.fi, adilger@sun.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754069AbZBXTdc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 14:33:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: allocate ->s_blockgroup_lock separately
has been removed from the -mm tree.  Its filename was
     ext4-allocate-s_blockgroup_lock-separately.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: allocate ->s_blockgroup_lock separately
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
 
 	/* Journaling */
@@ -149,7 +149,7 @@ struct ext4_sb_info {
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
@@ -615,6 +615,7 @@ static void ext4_put_super(struct super_
 		ext4_blkdev_remove(sbi);
 	}
 	sb->s_fs_info = NULL;
+	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	return;
 }
@@ -2021,6 +2022,13 @@ static int ext4_fill_super(struct super_
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
@@ -2332,7 +2340,7 @@ static int ext4_fill_super(struct super_
 				 &sbi->s_inode_readahead_blks);
 #endif
 
-	bgl_lock_init(&sbi->s_blockgroup_lock);
+	bgl_lock_init(sbi->s_blockgroup_lock);
 
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
cifs-use-kzfree.patch
md-use-kzfree.patch
s390-use-kzfree.patch
usb-use-kzfree.patch
crypto-use-kzfree.patch
mm-fix-lazy-vmap-purging-use-after-free-error.patch
oom_kill-dont-call-for-int_sqrt0.patch
ecryptfs-use-kzfree.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
nilfs2-clean-up-indirect-function-calling-conventions.patch
nilfs2-use-unlocked_ioctl.patch
nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl.patch
slab-leaks3-default-y.patch

