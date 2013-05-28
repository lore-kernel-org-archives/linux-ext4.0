From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/6] ext3: Fix fsync error handling after filesystem abort.
Date: Tue, 28 May 2013 13:19:01 +0400
Message-ID: <1369732741-26070-7-git-send-email-dmonakhov@openvz.org>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:16063 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933752Ab3E1JTQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 05:19:16 -0400
In-Reply-To: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If filesystem was aborted we will return success
due to (sb->s_flags & MS_RDONLY) which is incorrect and
results in data loss.
In order to handle fs abort correctly we have to check
fs state once we discover that it is in MS_RDONLY state

Test case: http://patchwork.ozlabs.org/patch/244297/
Changes from V1:
 - fix spelling
 - fix smp_rmb()/debug order

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/fsync.c |    8 ++++++--
 fs/ext3/super.c |   13 ++++++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index b31dbd4..5412916 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -48,9 +48,13 @@ int ext3_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	trace_ext3_sync_file_enter(file, datasync);
 
-	if (inode->i_sb->s_flags & MS_RDONLY)
+	if (inode->i_sb->s_flags & MS_RDONLY) {
+		/* Make shure that we read updated state */
+		smp_rmb();
+		if (EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS)
+			return -EROFS;
 		return 0;
-
+	}
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (ret)
 		goto out;
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index c8a4e17..b788bae 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -174,6 +174,11 @@ static void ext3_handle_error(struct super_block *sb)
 	if (test_opt (sb, ERRORS_RO)) {
 		ext3_msg(sb, KERN_CRIT,
 			"error: remounting filesystem read-only");
+		/*
+		 * Make shure updated value of ->s_mount_state will be visiable
+		 * before ->s_flags update.
+		 */
+		smp_wmb();
 		sb->s_flags |= MS_RDONLY;
 	}
 	ext3_commit_super(sb, es, 1);
@@ -291,8 +296,14 @@ void ext3_abort(struct super_block *sb, const char *function,
 	ext3_msg(sb, KERN_CRIT,
 		"error: remounting filesystem read-only");
 	EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
-	sb->s_flags |= MS_RDONLY;
 	set_opt(EXT3_SB(sb)->s_mount_opt, ABORT);
+	/*
+	 * Make shure updated value of ->s_mount_state will be visiable
+	 * before ->s_flags update.
+	 */
+	smp_wmb();
+	sb->s_flags |= MS_RDONLY;
+
 	if (EXT3_SB(sb)->s_journal)
 		journal_abort(EXT3_SB(sb)->s_journal, -EIO);
 }
-- 
1.7.1

