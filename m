From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/3] ext4: Fix fsync error handling after filesystem abort.
Date: Mon, 10 Jun 2013 20:41:01 +0400
Message-ID: <1370882461-12786-3-git-send-email-dmonakhov@openvz.org>
References: <1370882461-12786-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:17467 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab3FJQlU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jun 2013 12:41:20 -0400
In-Reply-To: <1370882461-12786-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If filesystem was aborted after inode's write back is complete
but before its metadata was updated we may return success
results in data loss.
In order to handle fs abort correctly we have to check
fs state once we discover that it is in MS_RDONLY state

Test case: http://patchwork.ozlabs.org/patch/244297

Changes from V2:
 - more spelling fixes

Changes from V1:
 - fix spelling

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/fsync.c |    7 ++++++-
 fs/ext4/super.c |   12 +++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index fc938eb..a8bc47f 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -98,8 +98,13 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	trace_ext4_sync_file_enter(file, datasync);
 
-	if (inode->i_sb->s_flags & MS_RDONLY)
+	if (inode->i_sb->s_flags & MS_RDONLY) {
+		/* Make sure that we read updated s_mount_flags value */
+		smp_rmb();
+		if (EXT4_SB(inode->i_sb)->s_mount_flags & EXT4_MF_FS_ABORTED)
+			ret = -EROFS;
 		goto out;
+	}
 
 	if (!journal) {
 		ret = generic_file_fsync(file, start, end, datasync);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0f77c2e..f23daaa 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -399,6 +399,11 @@ static void ext4_handle_error(struct super_block *sb)
 	}
 	if (test_opt(sb, ERRORS_RO)) {
 		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
+		/*
+		 * Make shure updated value of ->s_mount_flags will be visible
+		 * before ->s_flags update
+		 */
+		smp_wmb();
 		sb->s_flags |= MS_RDONLY;
 	}
 	if (test_opt(sb, ERRORS_PANIC))
@@ -571,8 +576,13 @@ void __ext4_abort(struct super_block *sb, const char *function,
 
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

