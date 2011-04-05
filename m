From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v1] ext4:Allow an active handle to be started when freezing.
Date: Tue, 5 Apr 2011 15:47:25 +0800
Message-ID: <BANLkTikqLrAyVaULk5UQsM7TzGk73ihsKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47241 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1DEHr0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 03:47:26 -0400
Received: by pwi15 with SMTP id 15so65162pwi.19
        for <linux-ext4@vger.kernel.org>; Tue, 05 Apr 2011 00:47:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

v0->v1:
  check s_frozen in nojournal case only if there is no an active handle.
  get reference to an active handle by jbd2_journal_start().

ext4_journal_start_sb() should not prevent an active handle from being
started due to s_frozen.  Otherwise, deadlock is easy to happen, below
is a situation.

================================================
     freeze         |       truncate
================================================
                    |  ext4_ext_truncate()
    freeze_super()  |   starts a handle
    sets s_frozen   |
                    |  ext4_ext_truncate()
                    |  holds i_data_sem
  ext4_freeze()     |
  waits for updates |
                    |  ext4_free_blocks()
                    |  calls dquot_free_block()
                    |
                    |  dquot_free_blocks()
                    |  calls ext4_dirty_inode()
                    |
                    |  ext4_dirty_inode()
                    |  trys to start an active
                    |  handle
                    |
                    |  block due to s_frozen
================================================

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Reported-by: Amir Goldstein <amir73il@users.sf.net>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   45 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ccfa686..53920bd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -242,27 +242,45 @@ static void ext4_put_nojournal(handle_t *handle)
  * journal_end calls result in the superblock being marked dirty, so
  * that sync() will call the filesystem's write_super callback if
  * appropriate.
+ *
+ * To avoid j_barrier hold in userspace when a user calls freeze(),
+ * ext4 prevents a new handle from being started by s_frozen, which
+ * is in an upper layer.
  */
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 {
 	journal_t *journal;
+	handle_t  *handle;

 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);

-	vfs_check_frozen(sb, SB_FREEZE_TRANS);
-	/* Special case here: if the journal has aborted behind our
-	 * backs (eg. EIO in the commit thread), then we still need to
-	 * take the FS itself readonly cleanly. */
 	journal = EXT4_SB(sb)->s_journal;
-	if (journal) {
-		if (is_journal_aborted(journal)) {
-			ext4_abort(sb, "Detected aborted journal");
-			return ERR_PTR(-EROFS);
-		}
-		return jbd2_journal_start(journal, nblocks);
+	handle = ext4_journal_current_handle();
+
+	/*
+	 * Before vfs_check_frozen(), the current handle should be allowed
+	 * to finish, otherwise deadlock would happen when the filesystem
+	 * is freezed && active handles are not stopped.
+	 */
+	if (!journal) {
+		if (!handle)
+			vfs_check_frozen(sb, SB_FREEZE_TRANS);
+		return ext4_get_nojournal();
 	}
-	return ext4_get_nojournal();
+
+	if (!handle)
+		vfs_check_frozen(sb, SB_FREEZE_TRANS);
+	/*
+	 * Special case here: if the journal has aborted behind our
+	 * backs (eg. EIO in the commit thread), then we still need to
+	 * take the FS itself readonly cleanly.
+	 */
+	if (is_journal_aborted(journal)) {
+		ext4_abort(sb, "Detected aborted journal");
+		return ERR_PTR(-EROFS);
+	}
+	return jbd2_journal_start(journal, nblocks);
 }

 /*
@@ -4131,6 +4149,11 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 /*
  * LVM calls this function before a (read-only) snapshot is created.  This
  * gives us a chance to flush the journal completely and mark the fs clean.
+ *
+ * Note that only this function cannot bring a filesystem to be in a clean
+ * state independently, because ext4 prevents a new handle from being started
+ * by @sb->s_frozen, which stays in an upper layer.  It thus needs help from
+ * the upper layer.
  */
 static int ext4_freeze(struct super_block *sb)
 {
-- 
1.7.4
