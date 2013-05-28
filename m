From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/6] ext3: fix data integrity for ext4_sync_fs
Date: Tue, 28 May 2013 13:18:59 +0400
Message-ID: <1369732741-26070-5-git-send-email-dmonakhov@openvz.org>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:20568 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933735Ab3E1JTO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 05:19:14 -0400
In-Reply-To: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode's data or non journaled quota may be written w/o jounral so we must
send a barrier at the end of ext3_sync_fs. But it can be skipped if journal
commit will do it for us.

changes from v1:
 skip barrier for async mode

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/super.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fb5120a..c8a4e17 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2521,6 +2521,7 @@ int ext3_force_commit(struct super_block *sb)
 static int ext3_sync_fs(struct super_block *sb, int wait)
 {
 	tid_t target;
+	int ret = 0;
 
 	trace_ext3_sync_fs(sb, wait);
 	/*
@@ -2528,11 +2529,14 @@ static int ext3_sync_fs(struct super_block *sb, int wait)
 	 * no dirty dquots
 	 */
 	dquot_writeback_dquots(sb, -1);
-	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
-		if (wait)
-			log_wait_commit(EXT3_SB(sb)->s_journal, target);
+	if (wait) {
+		if (journal_start_commit(EXT3_SB(sb)->s_journal, &target))
+			ret = log_wait_commit(EXT3_SB(sb)->s_journal, target);
+		else
+			ret = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
 	}
-	return 0;
+
+	return ret;
 }
 
 /*
-- 
1.7.1

