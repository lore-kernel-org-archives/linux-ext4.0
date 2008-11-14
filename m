From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] ext2/ext3: allocate ->s_blockgroup_lock separately to avoid
 wasting space
Date: Fri, 14 Nov 2008 11:17:54 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0811141115100.29826@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	cl@linux-foundation.org, mpm@selenic.com,
	eduard.munteanu@linux360.ro
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35104 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYKNJR4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 04:17:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Pekka Enberg <penberg@cs.helsinki.fi>

As spotted by kmemtrace, struct ext2_sb_info is 17024 bytes and ext3_sb_info is
17152 bytes on 64-bit which makes them a very bad fit for SLAB allocators. In
fact, both allocations are round up to the next available page size of 
order 3 which is 32 KB.

The culprit if the wasted memory is the ->s_blockgroup_lock which can be as big
as 16 KB when CONFIG_NR_CPUS is set to 32. As struct blockgroup_lock is a
perfect fit for order 2 page in the worst case, allocate ->s_blockgroup_lock
separately to avoid wasting space.

The change shrinks struct ext2_sb_info to 592 bytes and struct ext3_sb_info to
640 bytes which fits into a 1024 byte slab cache so now we allocate 16 KB + 1
KB instead of 32 KB saving 15 KB of memory!

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/ext2/super.c                 |   10 +++++++++-
 fs/ext3/super.c                 |   10 +++++++++-
 include/linux/blockgroup_lock.h |    2 +-
 include/linux/ext2_fs_sb.h      |    2 +-
 include/linux/ext3_fs_sb.h      |    2 +-
 5 files changed, 21 insertions(+), 5 deletions(-)

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
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index f6c94f2..f41df22 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -439,6 +439,7 @@ static void ext3_put_super (struct super_block * sb)
 		ext3_blkdev_remove(sbi);
 	}
 	sb->s_fs_info = NULL;
+	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	return;
 }
@@ -1548,6 +1549,13 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
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
@@ -1788,7 +1796,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	bgl_lock_init(&sbi->s_blockgroup_lock);
+	bgl_lock_init(sbi->s_blockgroup_lock);
 
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logic_sb_block, i);
diff --git a/include/linux/blockgroup_lock.h b/include/linux/blockgroup_lock.h
index 8607312..d6d4787 100644
--- a/include/linux/blockgroup_lock.h
+++ b/include/linux/blockgroup_lock.h
@@ -54,6 +54,6 @@ static inline void bgl_lock_init(struct blockgroup_lock *bgl)
  * superblock types
  */
 #define sb_bgl_lock(sb, block_group) \
-	(&(sb)->s_blockgroup_lock.locks[(block_group) & (NR_BG_LOCKS-1)].lock)
+	(&(sb)->s_blockgroup_lock->locks[(block_group) & (NR_BG_LOCKS-1)].lock)
 
 #endif
diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
index f273415..7e61de9 100644
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
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index b65f028..ec10d96 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
@@ -60,7 +60,7 @@ struct ext3_sb_info {
 	struct percpu_counter s_freeblocks_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
-	struct blockgroup_lock s_blockgroup_lock;
+	struct blockgroup_lock *s_blockgroup_lock;
 
 	/* root of the per fs reservation window tree */
 	spinlock_t s_rsv_window_lock;
-- 
1.5.4.3

