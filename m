From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH 3/3] ext4: enable again per-file data journaling on delalloc
 mode
Date: Wed, 18 Nov 2015 10:34:34 +0900
Message-ID: <1447810474-14840-3-git-send-email-daeho.jeong@samsung.com>
References: <1447810474-14840-1-git-send-email-daeho.jeong@samsung.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org, daeho.jeong@samsung.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42827 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbbKRBdn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2015 20:33:43 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NXZ00395LO39780@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 18 Nov 2015 10:33:39 +0900 (KST)
In-reply-to: <1447810474-14840-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Several problems occurred when per-file data journaling is enabled on
"delalloc" mode, so the per-file data journaling was permanently
deactivated by commit 3d2b15826282 ("ext4: ignore
EXT4_INODE_JOURNAL_DATA flag with delalloc"). But, those are not
problems for only "delalloc" mode and when you execute xfstest on
"nodelalloc" mode, same problems happen on "nodelalloc" mode. We always
execute xfstest on "delalloc" mode, which is default mode, so we
haven't realized problems of per-file data journaling feature. Finally,
problems of per-file data journaling feature were fixed by commit
9c02ac97989d ("ext4: fix xfstest generic/269 double revoked buffer bug
with bigalloc") and previous patchset. Now, we can re-enable the
feature on "delalloc" mode.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
---
 fs/ext4/ext4_jbd2.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 9c5b49f..742b3ec 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -395,12 +395,10 @@ static inline int ext4_inode_journal_mode(struct inode *inode)
 {
 	if (EXT4_JOURNAL(inode) == NULL)
 		return EXT4_INODE_WRITEBACK_DATA_MODE;	/* writeback */
-	/* We do not support data journalling with delayed allocation */
 	if (!S_ISREG(inode->i_mode) ||
 	    test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 		return EXT4_INODE_JOURNAL_DATA_MODE;	/* journal data */
-	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
-	    !test_opt(inode->i_sb, DELALLOC))
+	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
 		return EXT4_INODE_JOURNAL_DATA_MODE;	/* journal data */
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
 		return EXT4_INODE_ORDERED_DATA_MODE;	/* ordered */
-- 
1.7.9.5

