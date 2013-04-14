From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/5] ext3: fix data integrity for ext4_sync_fs
Date: Sun, 14 Apr 2013 23:01:37 +0400
Message-ID: <1365966097-8968-5-git-send-email-dmonakhov@openvz.org>
References: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:47006 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab3DNTCn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Apr 2013 15:02:43 -0400
In-Reply-To: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode's data or non journaled quota may be written w/o jounral so we must
send a barrier at the end of ext3_sync_fs. But it can be skipped if journal
commit will do it for us.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/super.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fb5120a..ee140a8 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2521,6 +2521,7 @@ int ext3_force_commit(struct super_block *sb)
 static int ext3_sync_fs(struct super_block *sb, int wait)
 {
 	tid_t target;
+	int ret = 0;
 
 	trace_ext3_sync_fs(sb, wait);
 	/*
@@ -2530,9 +2531,12 @@ static int ext3_sync_fs(struct super_block *sb, int wait)
 	dquot_writeback_dquots(sb, -1);
 	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
 		if (wait)
-			log_wait_commit(EXT3_SB(sb)->s_journal, target);
+			ret = log_wait_commit(EXT3_SB(sb)->s_journal, target);
+	} else {
+		ret = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
 	}
-	return 0;
+
+	return ret;
 }
 
 /*
-- 
1.7.1

