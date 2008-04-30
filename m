From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Fix synchronization of quota files in journal=data mode
Date: Wed, 30 Apr 2008 17:06:12 +0200
Message-ID: <12095679813226-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36416 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762102AbYD3PGW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 11:06:22 -0400
In-Reply-To: y
References: y
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In journal=data mode, it is not enough to do write_inode_now as done in
vfs_quota_on() to write all data to their final location (which is needed
for quota_read to work correctly). Calling journal_flush() does its job.

Reported-by: Nick <gentuu@gmail.com>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fe3119a..1c7b0fc 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2759,23 +2759,42 @@ static int ext3_quota_on(struct super_block *sb, int type, int format_id,
 
 	if (!test_opt(sb, QUOTA))
 		return -EINVAL;
-	/* Not journalling quota or remount? */
-	if ((!EXT3_SB(sb)->s_qf_names[USRQUOTA] &&
-	    !EXT3_SB(sb)->s_qf_names[GRPQUOTA]) || remount)
+	/* When remounting, no checks are needed and in fact, path is NULL */
+	if (remount)
 		return vfs_quota_on(sb, type, format_id, path, remount);
+
 	err = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (err)
 		return err;
+
 	/* Quotafile not on the same filesystem? */
 	if (nd.path.mnt->mnt_sb != sb) {
 		path_put(&nd.path);
 		return -EXDEV;
 	}
-	/* Quotafile not in fs root? */
-	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
-		printk(KERN_WARNING
-			"EXT3-fs: Quota file not on filesystem root. "
-			"Journalled quota will not work.\n");
+	/* Journaling quota? */
+	if (EXT3_SB(sb)->s_qf_names[type]) {
+		/* Quotafile not of fs root? */
+		if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
+			printk(KERN_WARNING
+				"EXT3-fs: Quota file not on filesystem root. "
+				"Journaled quota will not work.\n");
+	}
+
+	/*
+	 * When we journal data on quota file, we have to flush journal to see
+	 * all updates to the file when we bypass pagecache...
+	 */
+	if (ext3_should_journal_data(nd.path.dentry->d_inode)) {
+		/*
+		 * We don't need to lock updates but journal_flush() could
+		 * otherwise be livelocked...
+		 */
+		journal_lock_updates(EXT3_SB(sb)->s_journal);
+		journal_flush(EXT3_SB(sb)->s_journal);
+		journal_unlock_updates(EXT3_SB(sb)->s_journal);
+	}
+
 	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path, remount);
 }
-- 
1.5.2.4

