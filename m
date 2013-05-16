From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] ext4: Fix fsync error handling after filesysteb abort.
Date: Thu, 16 May 2013 16:28:07 +0400
Message-ID: <1368707290-26185-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:14337 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab3EPM2S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 08:28:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If filesystem was aborted after inode's write back complete
but before it's metadata was updated we may return success
due to (sb->s_flags & MS_RDONLY) which is incorrect and
result in data loss.
In order to handle fs abort correctly we have to check
fs state once we discover that it is in MS_RDONLY state

Test case: http://patchwork.ozlabs.org/patch/244297/

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/fsync.c |    8 ++++++--
 fs/ext4/super.c |   13 ++++++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index e0ba8a4..d7df2f1 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -129,9 +129,13 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		return ret;
 	mutex_lock(&inode->i_mutex);
 
-	if (inode->i_sb->s_flags & MS_RDONLY)
+	if (inode->i_sb->s_flags & MS_RDONLY) {
+		/* Make shure that we read updated s_mount_flags value */
+		smp_rmb();
+		if (EXT4_SB(inode->i_sb)->s_mount_flags & EXT4_MF_FS_ABORTED)
+			ret = -EROFS;
 		goto out;
-
+	}
 	ret = ext4_flush_unwritten_io(inode);
 	if (ret < 0)
 		goto out;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dbc7c09..6c91c8e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -398,6 +398,11 @@ static void ext4_handle_error(struct super_block *sb)
 	}
 	if (test_opt(sb, ERRORS_RO)) {
 		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
+		/*
+		 * Make shure updated value of ->s_mount_flags will be visiable
+		 * before ->s_flags update
+		 */
+		smp_wmb();
 		sb->s_flags |= MS_RDONLY;
 	}
 	if (test_opt(sb, ERRORS_PANIC))
@@ -552,6 +557,7 @@ void __ext4_std_error(struct super_block *sb, const char *function,
  *
  * We unconditionally force the filesystem into an ABORT|READONLY state,
  * unless the error response on the fs has been set to panic in which
+
  * case we take the easy way out and panic immediately.
  */
 
@@ -570,8 +576,13 @@ void __ext4_abort(struct super_block *sb, const char *function,
 
 	if ((sb->s_flags & MS_RDONLY) == 0) {
 		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
-		sb->s_flags |= MS_RDONLY;
 		EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
+		/*
+		 * Make shure updated value of ->s_mount_flags will be visiable
+		 * before ->s_flags update
+		 */
+		smp_wmb();
+		sb->s_flags |= MS_RDONLY;
 		if (EXT4_SB(sb)->s_journal)
 			jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
 		save_error_info(sb, function, line);
-- 
1.7.1

