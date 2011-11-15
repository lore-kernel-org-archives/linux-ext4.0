From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/5] ext4: allocate delalloc blocks before changing journal mode
Date: Tue, 15 Nov 2011 16:07:50 +0800
Message-ID: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64694 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1KOKcb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 05:32:31 -0500
Received: by ywt32 with SMTP id 32so3282317ywt.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 02:32:30 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

delalloc blocks should be allocated before changing journal mode,
otherwise they can not be allocated and even more truncate on
delalloc blocks could triggre BUG by flushing delalloc buffers.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index de05e86..384f8a7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4676,6 +4676,17 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		return 0;
 	if (is_journal_aborted(journal))
 		return -EROFS;
+	/* We have to allocate physical blocks for delalloc blocks
+	 * before flushing journal. otherwise delalloc blocks can not
+	 * be allocated any more. even more truncate on delalloc blocks
+	 * could trigger BUG by flushing delalloc blocks in journal.
+	 * There is no delalloc block in non-journal data mode.
+	 */
+	if (val && test_opt(inode->i_sb, DELALLOC)) {
+		err = ext4_alloc_da_blocks(inode);
+		if (err < 0)
+			return err;
+	}
 
 	jbd2_journal_lock_updates(journal);
 	jbd2_journal_flush(journal);
-- 
1.7.5.1

