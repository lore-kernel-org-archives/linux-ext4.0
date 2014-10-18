From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: move_extent improve bh vanishing success factor
Date: Sat, 18 Oct 2014 12:29:44 +0400
Message-ID: <1413620984-7736-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:17176 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaJRI3z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Oct 2014 04:29:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Xiaoguang Wang has reported sporadic EBUSY failures of ext4/302
Unfortunetly there is nothing we can do if some other task holds
BH's refenrence. So we must return EBUSY in this case. From other
point we can decrease false positive report raito. One of such
cases is filesystem under ENOSPC conditions. We should try to kick
the journal regardless to number of free blocks.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/move_extent.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 9f2311b..c2b2b02 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -407,8 +407,10 @@ stop_journal:
 	ext4_journal_stop(handle);
 	/* Buffer was busy because probably is pinned to journal transaction,
 	 * force transaction commit may help to free it. */
-	if (*err == -EBUSY && ext4_should_retry_alloc(orig_inode->i_sb,
-						      &retries))
+	if (*err == -EBUSY &&
+	    (retries++ < 4 && EXT4_SB(orig_inode->i_sb)->s_journal &&
+	     jbd2_journal_force_commit_nested(
+		     EXT4_SB(orig_inode->i_sb)->s_journal)))
 		goto again;
 	return replaced_count;
 
-- 
1.7.1

