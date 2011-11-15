From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 4/5] ext4: flush journal when switching from journal data mode
Date: Tue, 15 Nov 2011 16:07:53 +0800
Message-ID: <1321344474-14707-4-git-send-email-xiaoqiangnk@gmail.com>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51970 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1KOKch (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 05:32:37 -0500
Received: by ggnb2 with SMTP id b2so7263520ggn.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 02:32:37 -0800 (PST)
In-Reply-To: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When switching from journal data mode, the data blocks
in journal will have no revoke record.  Thus, data could be
corrupted during replay.  However, there is no such problem in
switching to journal data mode.  So we flush journal only in
the case that swithes from journal data mode.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 384f8a7..755f6c7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4689,7 +4689,6 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	}
 
 	jbd2_journal_lock_updates(journal);
-	jbd2_journal_flush(journal);
 
 	/*
 	 * OK, there are no updates running now, and all cached data is
@@ -4699,10 +4698,12 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	 * the inode's in-core data-journaling state flag now.
 	 */
 
-	if (val)
+	if (val) {
 		ext4_set_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
-	else
+	} else {
+		jbd2_journal_flush(journal);
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
+	}
 	ext4_set_aops(inode);
 
 	jbd2_journal_unlock_updates(journal);
-- 
1.7.5.1

