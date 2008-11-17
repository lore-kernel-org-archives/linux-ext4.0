From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 2/4] ext2: allocate ->s_blockgroup_lock separately
Date: Mon, 17 Nov 2008 23:55:07 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0811172354450.18904@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: adilger@sun.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, cl@linux-foundation.org,
	mpm@selenic.com, eduard.munteanu@linux360.ro
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42483 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbYKQVzI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 16:55:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Pekka Enberg <penberg@cs.helsinki.fi>

As spotted by kmemtrace, struct ext2_sb_info is 17024 bytes on 64-bit which
makes it a very bad fit for SLAB allocators. The culprit of the wasted memory
is ->s_blockgroup_lock which can be as big as 16 KB when NR_CPUS >= 32.

To fix that, allocate ->s_blockgroup_lock, which fits nicely in a order 2 page
in the worst case, separately. This shinks down struct ext2_sb_info enough to
fit a 1 KB slab cache so now we allocate 16 KB + 1 KB instead of 32 KB saving
15 KB of memory.

Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/ext2/super.c            |   10 +++++++++-
 include/linux/ext2_fs_sb.h |    4 ++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 647cd88..da8bdea 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -132,6 +132,7 @@ static void ext2_put_super (struct super_block * sb)
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	brelse (sbi->s_sbh);
 	sb->s_fs_info = NULL;
+	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 
 	return;
@@ -756,6 +757,13 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
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
 
@@ -983,7 +991,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		printk ("EXT2-fs: not enough memory\n");
 		goto failed_mount;
 	}
-	bgl_lock_init(&sbi->s_blockgroup_lock);
+	bgl_lock_init(sbi->s_blockgroup_lock);
 	sbi->s_debts = kcalloc(sbi->s_groups_count, sizeof(*sbi->s_debts), GFP_KERNEL);
 	if (!sbi->s_debts) {
 		printk ("EXT2-fs: not enough memory\n");
diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
index dc541f3..1cdb663 100644
--- a/include/linux/ext2_fs_sb.h
+++ b/include/linux/ext2_fs_sb.h
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
-- 
1.5.4.3

