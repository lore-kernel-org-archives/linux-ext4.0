From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH] ext4: guarantee already started handles to successfully finish
 while ro remounting
Date: Mon, 02 May 2016 09:50:37 +0900
Message-ID: <1462150237-20701-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>,
	Kitae Lee <kitae87.lee@samsung.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32791 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbcEBAtW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 May 2016 20:49:22 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O6I01YXEYA82A30@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Mon, 02 May 2016 09:49:20 +0900 (KST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We check whether a new handle can be started through
ext4_journal_check_start() and the function refuses to start the handle
when the filesystem is mounted with read-only. But now, when we remount
the filesystem with read-only option, already started handles are
allowed to be written on disk, but the subsequent metadata modification
using the handles are refused by ext4_journal_check_start().

As an example, in ext4_evict_inode(), i_size can be set to 0 using
a successfully started handle, but, when we remount the filesystem
with read-only option at that time, the subsequent ext4_truncate()
will be failed and the filesystem integrity will be damaged.

Therefore, we need to permit the metadata modification using already
started handles to be proceeded, even if s_flags of the filesystem is
set to MS_RDONLY.

Kitae found the problem and suggested the solution.

Signed-off-by: Kitae Lee <kitae87.lee@samsung.com>
Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
---
 fs/ext4/ext4_jbd2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index e770c1ee..3b59e11 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -43,7 +43,7 @@ static int ext4_journal_check_start(struct super_block *sb)
 	journal_t *journal;
 
 	might_sleep();
-	if (sb->s_flags & MS_RDONLY)
+	if (sb->s_flags & MS_RDONLY && ext4_journal_current_handle() == NULL)
 		return -EROFS;
 	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
 	journal = EXT4_SB(sb)->s_journal;
-- 
1.7.9.5

