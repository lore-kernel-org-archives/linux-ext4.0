From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/5] ext3: Don't use MAXQUOTAS value
Date: Wed, 10 Sep 2014 21:22:48 +0200
Message-ID: <1410376972-18417-2-git-send-email-jack@suse.cz>
References: <1410376972-18417-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaIJTXD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2014 15:23:03 -0400
In-Reply-To: <1410376972-18417-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

MAXQUOTAS value defines maximum number of quota types VFS supports. This
isn't necessarily the number of types ext3 supports and with addition of
project quotas these two numbers stop matching. So make ext3 use its
private definition.

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/ext3.h  | 12 +++++++-----
 fs/ext3/super.c | 14 +++++++-------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
index e85ff15a060e..fc3cdcf24aed 100644
--- a/fs/ext3/ext3.h
+++ b/fs/ext3/ext3.h
@@ -237,6 +237,8 @@ struct ext3_new_group_data {
 #define EXT3_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
 #define EXT3_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
 
+/* Number of supported quota types */
+#define EXT3_MAXQUOTAS 2
 
 /*
  *  Mount options
@@ -248,7 +250,7 @@ struct ext3_mount_options {
 	unsigned long s_commit_interval;
 #ifdef CONFIG_QUOTA
 	int s_jquota_fmt;
-	char *s_qf_names[MAXQUOTAS];
+	char *s_qf_names[EXT3_MAXQUOTAS];
 #endif
 };
 
@@ -669,7 +671,7 @@ struct ext3_sb_info {
 	unsigned long s_commit_interval;
 	struct block_device *journal_bdev;
 #ifdef CONFIG_QUOTA
-	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled quota */
+	char *s_qf_names[EXT3_MAXQUOTAS];	/* Names of quota files with journalled quota */
 	int s_jquota_fmt;			/* Format of quota to use */
 #endif
 };
@@ -1183,9 +1185,9 @@ extern const struct inode_operations ext3_fast_symlink_inode_operations;
 #define EXT3_QUOTA_INIT_BLOCKS(sb) 0
 #define EXT3_QUOTA_DEL_BLOCKS(sb) 0
 #endif
-#define EXT3_MAXQUOTAS_TRANS_BLOCKS(sb) (MAXQUOTAS*EXT3_QUOTA_TRANS_BLOCKS(sb))
-#define EXT3_MAXQUOTAS_INIT_BLOCKS(sb) (MAXQUOTAS*EXT3_QUOTA_INIT_BLOCKS(sb))
-#define EXT3_MAXQUOTAS_DEL_BLOCKS(sb) (MAXQUOTAS*EXT3_QUOTA_DEL_BLOCKS(sb))
+#define EXT3_MAXQUOTAS_TRANS_BLOCKS(sb) (EXT3_MAXQUOTAS*EXT3_QUOTA_TRANS_BLOCKS(sb))
+#define EXT3_MAXQUOTAS_INIT_BLOCKS(sb) (EXT3_MAXQUOTAS*EXT3_QUOTA_INIT_BLOCKS(sb))
+#define EXT3_MAXQUOTAS_DEL_BLOCKS(sb) (EXT3_MAXQUOTAS*EXT3_QUOTA_DEL_BLOCKS(sb))
 
 int
 ext3_mark_iloc_dirty(handle_t *handle,
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 622e88249024..b79f04bf72fc 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -441,7 +441,7 @@ static void ext3_put_super (struct super_block * sb)
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	brelse(sbi->s_sbh);
 #ifdef CONFIG_QUOTA
-	for (i = 0; i < MAXQUOTAS; i++)
+	for (i = 0; i < EXT3_MAXQUOTAS; i++)
 		kfree(sbi->s_qf_names[i]);
 #endif
 
@@ -1555,7 +1555,7 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 	/* Needed for iput() to work correctly and not trash data */
 	sb->s_flags |= MS_ACTIVE;
 	/* Turn on quotas so that they are updated correctly */
-	for (i = 0; i < MAXQUOTAS; i++) {
+	for (i = 0; i < EXT3_MAXQUOTAS; i++) {
 		if (EXT3_SB(sb)->s_qf_names[i]) {
 			int ret = ext3_quota_on_mount(sb, i);
 			if (ret < 0)
@@ -1606,7 +1606,7 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 		       PLURAL(nr_truncates));
 #ifdef CONFIG_QUOTA
 	/* Turn quotas off */
-	for (i = 0; i < MAXQUOTAS; i++) {
+	for (i = 0; i < EXT3_MAXQUOTAS; i++) {
 		if (sb_dqopt(sb)->files[i])
 			dquot_quota_off(sb, i);
 	}
@@ -2139,7 +2139,7 @@ failed_mount2:
 	kfree(sbi->s_group_desc);
 failed_mount:
 #ifdef CONFIG_QUOTA
-	for (i = 0; i < MAXQUOTAS; i++)
+	for (i = 0; i < EXT3_MAXQUOTAS; i++)
 		kfree(sbi->s_qf_names[i]);
 #endif
 	ext3_blkdev_remove(sbi);
@@ -2659,7 +2659,7 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 	old_opts.s_commit_interval = sbi->s_commit_interval;
 #ifdef CONFIG_QUOTA
 	old_opts.s_jquota_fmt = sbi->s_jquota_fmt;
-	for (i = 0; i < MAXQUOTAS; i++)
+	for (i = 0; i < EXT3_MAXQUOTAS; i++)
 		if (sbi->s_qf_names[i]) {
 			old_opts.s_qf_names[i] = kstrdup(sbi->s_qf_names[i],
 							 GFP_KERNEL);
@@ -2763,7 +2763,7 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 	}
 #ifdef CONFIG_QUOTA
 	/* Release old quota file names */
-	for (i = 0; i < MAXQUOTAS; i++)
+	for (i = 0; i < EXT3_MAXQUOTAS; i++)
 		kfree(old_opts.s_qf_names[i]);
 #endif
 	if (enable_quota)
@@ -2777,7 +2777,7 @@ restore_opts:
 	sbi->s_commit_interval = old_opts.s_commit_interval;
 #ifdef CONFIG_QUOTA
 	sbi->s_jquota_fmt = old_opts.s_jquota_fmt;
-	for (i = 0; i < MAXQUOTAS; i++) {
+	for (i = 0; i < EXT3_MAXQUOTAS; i++) {
 		kfree(sbi->s_qf_names[i]);
 		sbi->s_qf_names[i] = old_opts.s_qf_names[i];
 	}
-- 
1.8.1.4

