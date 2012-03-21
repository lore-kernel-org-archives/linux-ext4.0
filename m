From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH 5/8] ext2: introduce workqueue for superblock synchronization
Date: Wed, 21 Mar 2012 18:14:32 +0200
Message-ID: <1332346475-1441-6-git-send-email-dedekind1@gmail.com>
References: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Introduce a workqueue which will be used for delayed superblock
synchronization in the next patch. So this is just a preparation.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext2/super.c            |   21 ++++++++++++++++++---
 include/linux/ext2_fs_sb.h |    3 +++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 134c750..80ffd22 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -130,6 +130,9 @@ static void ext2_put_super (struct super_block * sb)
 
 	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
+	flush_workqueue(sbi->sync_super_wq);
+	destroy_workqueue(sbi->sync_super_wq);
+
 	ext2_xattr_put_super(sb);
 	if (!(sb->s_flags & MS_RDONLY)) {
 		struct ext2_super_block *es = sbi->s_es;
@@ -1073,15 +1076,23 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_qcop = &dquot_quotactl_ops;
 #endif
 
+	sbi->sync_super_wq = alloc_workqueue("ext2-sync-super",
+					WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+	if (!sbi->sync_super_wq) {
+		ext2_msg(sb, KERN_ERR,
+			"error: failed to create sync_super workqueue");
+		goto failed_mount3;
+	}
+
 	root = ext2_iget(sb, EXT2_ROOT_INO);
 	if (IS_ERR(root)) {
 		ret = PTR_ERR(root);
-		goto failed_mount3;
+		goto failed_mount4;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
 		iput(root);
 		ext2_msg(sb, KERN_ERR, "error: corrupt root inode, run e2fsck");
-		goto failed_mount3;
+		goto failed_mount4;
 	}
 
 	sb->s_root = d_alloc_root(root);
@@ -1089,7 +1100,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		iput(root);
 		ext2_msg(sb, KERN_ERR, "error: get root inode failed");
 		ret = -ENOMEM;
-		goto failed_mount3;
+		goto failed_mount4;
 	}
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		ext2_msg(sb, KERN_WARNING,
@@ -1105,6 +1116,8 @@ cantfind_ext2:
 			"error: can't find an ext2 filesystem on dev %s.",
 			sb->s_id);
 	goto failed_mount;
+failed_mount4:
+	destroy_workqueue(sbi->sync_super_wq);
 failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
@@ -1176,6 +1189,8 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
 
+	flush_workqueue(sbi->sync_super_wq);
+
 	spin_lock(&sbi->s_lock);
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
index db4d9f5..75aa40e 100644
--- a/include/linux/ext2_fs_sb.h
+++ b/include/linux/ext2_fs_sb.h
@@ -19,6 +19,7 @@
 #include <linux/blockgroup_lock.h>
 #include <linux/percpu_counter.h>
 #include <linux/rbtree.h>
+#include <linux/workqueue.h>
 
 /* XXX Here for now... not interested in restructing headers JUST now */
 
@@ -98,6 +99,8 @@ struct ext2_sb_info {
 	u32 s_next_generation;
 	unsigned long s_dir_count;
 	u8 *s_debts;
+	/* workqueue for synchronizing the superblock */
+	struct workqueue_struct *sync_super_wq;
 	struct percpu_counter s_freeblocks_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
-- 
1.7.7.6
