From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext3: optimize ext3_force_commit
Date: Mon,  1 Apr 2013 13:03:56 +0400
Message-ID: <1364807037-21664-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:1479 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab3DAJFI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 05:05:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We do not have to use journal_force_commit() because it explicitly
start and stop SYNC transaction. This is very suboptimal because the only
users of ext3_force_commit() are ext3_sync_file and ext3_write_inode().
Both functions just want to commit and wait any uncommitted transaction
similar to ext3_sync_fs().

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/super.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fb5120a..1853031 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2507,15 +2507,14 @@ static void ext3_clear_journal_err(struct super_block *sb,
  */
 int ext3_force_commit(struct super_block *sb)
 {
-	journal_t *journal;
-	int ret;
+	tid_t target;
 
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-	journal = EXT3_SB(sb)->s_journal;
-	ret = ext3_journal_force_commit(journal);
-	return ret;
+	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target))
+		return log_wait_commit(EXT3_SB(sb)->s_journal, target);
+	return 0;
 }
 
 static int ext3_sync_fs(struct super_block *sb, int wait)
@@ -2530,7 +2529,7 @@ static int ext3_sync_fs(struct super_block *sb, int wait)
 	dquot_writeback_dquots(sb, -1);
 	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
 		if (wait)
-			log_wait_commit(EXT3_SB(sb)->s_journal, target);
+			return log_wait_commit(EXT3_SB(sb)->s_journal, target);
 	}
 	return 0;
 }
-- 
1.7.1

