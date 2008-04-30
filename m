From: akpm@linux-foundation.org
Subject: + ext4-fix-synchronization-of-quota-files-in-journal=data-mode.patch added to -mm tree
Date: Wed, 30 Apr 2008 10:50:00 -0700
Message-ID: <200804301750.m3UHo00a026655@imap1.linux-foundation.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761209AbYD3Rue (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 13:50:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: fix synchronization of quota files in journal=data mode
has been added to the -mm tree.  Its filename is
     ext4-fix-synchronization-of-quota-files-in-journal=data-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fix synchronization of quota files in journal=data mode
From: Jan Kara <jack@suse.cz>

In journal=data mode, it is not enough to do write_inode_now as done in
vfs_quota_on() to write all data to their final location (which is needed for
quota_read to work correctly).  Calling journal_flush() does its job.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff -puN fs/ext4/super.c~ext4-fix-synchronization-of-quota-files-in-journal=data-mode fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-fix-synchronization-of-quota-files-in-journal=data-mode
+++ a/fs/ext4/super.c
@@ -3159,23 +3159,42 @@ static int ext4_quota_on(struct super_bl
 
 	if (!test_opt(sb, QUOTA))
 		return -EINVAL;
-	/* Not journalling quota? */
-	if ((!EXT4_SB(sb)->s_qf_names[USRQUOTA] &&
-	    !EXT4_SB(sb)->s_qf_names[GRPQUOTA]) || remount)
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
-	/* Quotafile not of fs root? */
-	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
-		printk(KERN_WARNING
-			"EXT4-fs: Quota file not on filesystem root. "
-			"Journalled quota will not work.\n");
+	/* Journaling quota? */
+	if (EXT4_SB(sb)->s_qf_names[type]) {
+		/* Quotafile not of fs root? */
+		if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
+			printk(KERN_WARNING
+				"EXT4-fs: Quota file not on filesystem root. "
+				"Journaled quota will not work.\n");
+ 	}
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
+		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
+		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
+		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+	}
+
 	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path, remount);
 }
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch
quota-le_add_cpu-conversion.patch
ext4-fix-mount-messages-when-quota-disabled.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext4-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext4-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
quota-add-a-convenience-macro-for-filesystems.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
ext4-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch

