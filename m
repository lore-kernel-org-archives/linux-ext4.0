From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix synchronization of quota files in journal=data mode
Date: Tue, 29 Apr 2008 11:58:49 +0200
Message-ID: <1209463129596-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:57253 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751470AbYD2J6v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2008 05:58:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In journal=data mode, it is not enough to do write_inode_now as done in
vfs_quota_on() to write all data to their final location (which is needed
for quota_read to work correctly). Calling journal_flush() does its job.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   42 +++++++++++++++++++++++++++++-------------
 1 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 286acec..fdcd832 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3156,23 +3156,39 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 
 	if (!test_opt(sb, QUOTA))
 		return -EINVAL;
-	/* Not journalling quota? */
-	if (!EXT4_SB(sb)->s_qf_names[USRQUOTA] &&
-	    !EXT4_SB(sb)->s_qf_names[GRPQUOTA])
-		return vfs_quota_on(sb, type, format_id, path);
+
 	err = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (err)
 		return err;
-	/* Quotafile not on the same filesystem? */
-	if (nd.path.mnt->mnt_sb != sb) {
-		path_put(&nd.path);
-		return -EXDEV;
+
+	/* Journaling quota? */
+	if (EXT4_SB(sb)->s_qf_names[type]) {
+		/* Quotafile not on the same filesystem? */
+		if (nd.path.mnt->mnt_sb != sb) {
+			path_put(&nd.path);
+			return -EXDEV;
+		}
+		/* Quotafile not of fs root? */
+		if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
+			printk(KERN_WARNING
+				"EXT4-fs: Quota file not on filesystem root. "
+				"Journaled quota will not work.\n");
 	}
-	/* Quotafile not of fs root? */
-	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
-		printk(KERN_WARNING
-			"EXT4-fs: Quota file not on filesystem root. "
-			"Journalled quota will not work.\n");
+
+	/*
+	 * When we journal data on quota file, we have to flush journal to see
+	 * all updates to the file when we bypass pagecache...
+	 */
+	if (ext4_should_journal_data(nd.path.dentry->d_inode)) {
+		/*
+		 * We don't need to lock updates but journal_flush() could
+		 * otherwise be livelocked...
+		 */
+		journal_lock_updates(EXT4_SB(sb)->s_journal);
+		journal_flush(EXT4_SB(sb)->s_journal);
+		journal_unlock_updates(EXT4_SB(sb)->s_journal);
+	}
+
 	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
-- 
1.5.2.4

