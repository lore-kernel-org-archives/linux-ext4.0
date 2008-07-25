From: akpm@linux-foundation.org
Subject: - ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:56:18 -0700
Message-ID: <200807252256.m6PMuID7003076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: jack@suse.cz, gentuu@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: fix synchronization of quota files in journal=data mode
has been removed from the -mm tree.  Its filename was
     ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: fix synchronization of quota files in journal=data mode
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

Patches currently in -mm which might be from jack@suse.cz are

origin.patch

