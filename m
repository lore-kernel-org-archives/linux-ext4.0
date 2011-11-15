From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [RESEND PATCH 2/2] ext3: flush journal only when journal mode is changed from journaled
Date: Tue, 15 Nov 2011 16:04:49 +0800
Message-ID: <1321344289-13125-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45973 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1KOK3c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 05:29:32 -0500
Received: by ywt32 with SMTP id 32so3279937ywt.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 02:29:32 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To prevent data from corruption during repaly, we need to flush journal
before changing journal mode from journaled.  However flushing journal is
not needed when changing journal to journaled.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext3/inode.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 04da6ac..5577358 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3546,7 +3546,6 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
 		return -EROFS;
 
 	journal_lock_updates(journal);
-	journal_flush(journal);
 
 	/*
 	 * OK, there are no updates running now, and all cached data is
@@ -3556,10 +3555,12 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
 	 * the inode's in-core data-journaling state flag now.
 	 */
 
-	if (val)
+	if (val) {
 		EXT3_I(inode)->i_flags |= EXT3_JOURNAL_DATA_FL;
-	else
+	} else {
+		journal_flush(journal);
 		EXT3_I(inode)->i_flags &= ~EXT3_JOURNAL_DATA_FL;
+	}
 	ext3_set_aops(inode);
 
 	journal_unlock_updates(journal);
-- 
1.7.5.1

