From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4: optimize ext4_force_commit
Date: Mon,  1 Apr 2013 13:03:57 +0400
Message-ID: <1364807037-21664-2-git-send-email-dmonakhov@openvz.org>
References: <1364807037-21664-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:25165 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab3DAJFJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 05:05:09 -0400
In-Reply-To: <1364807037-21664-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We do not have to use jbd2_journal_force_commit() because it explicitly
start and stop SYNC transaction. This is very suboptimal because the only
users of ext4_force_commit() are ext4_sync_file and ext4_write_inode().
Both functions just want to commit and wait any uncommitted transaction
similar to ext4_sync_fs().

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e3e6a06..280a918 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4436,13 +4436,14 @@ static void ext4_clear_journal_err(struct super_block *sb,
  */
 int ext4_force_commit(struct super_block *sb)
 {
-	journal_t *journal;
+	tid_t target;
 
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-	journal = EXT4_SB(sb)->s_journal;
-	return ext4_journal_force_commit(journal);
+	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target))
+		return jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
+	return 0;
 }
 
 static int ext4_sync_fs(struct super_block *sb, int wait)
@@ -4460,7 +4461,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 	dquot_writeback_dquots(sb, -1);
 	if (jbd2_journal_start_commit(sbi->s_journal, &target)) {
 		if (wait)
-			jbd2_log_wait_commit(sbi->s_journal, target);
+			ret = jbd2_log_wait_commit(sbi->s_journal, target);
 	}
 	return ret;
 }
-- 
1.7.1

