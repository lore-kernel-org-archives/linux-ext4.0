From: akpm@linux-foundation.org
Subject: [patch 061/277] ext3: fix synchronization of quota files in journal=data mode
Date: Fri, 25 Jul 2008 01:46:16 -0700
Message-ID: <200807250846.m6P8kGu3001087@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz, gentuu@gmail.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbYGYJN3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 05:13:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

In journal=data mode, it is not enough to do write_inode_now as done in
vfs_quota_on() to write all data to their final location (which is needed for
quota_read to work correctly).  Calling journal_flush() does its job.

Reported-by: Nick <gentuu@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff -puN fs/ext3/super.c~ext3-fix-synchronization-of-quota-files-in-journal=data-mode fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-fix-synchronization-of-quota-files-in-journal=data-mode
+++ a/fs/ext3/super.c
@@ -2759,23 +2759,42 @@ static int ext3_quota_on(struct super_bl
 
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
_
