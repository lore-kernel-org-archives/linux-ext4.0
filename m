From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH 2/3] ext4: remove incorrect check for inode journal mode in
 ext4_writepages()
Date: Wed, 18 Nov 2015 10:34:33 +0900
Message-ID: <1447810474-14840-2-git-send-email-daeho.jeong@samsung.com>
References: <1447810474-14840-1-git-send-email-daeho.jeong@samsung.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org, daeho.jeong@samsung.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42827 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbbKRBdm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2015 20:33:42 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NXZ00ATHLO39U60@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 18 Nov 2015 10:33:39 +0900 (KST)
In-reply-to: <1447810474-14840-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now, in ext4, there is only one writepages() function and it is shared
by all the inode modes. Therefore, BUG_ON() for checking journaled
inode mode in ext4_writepages() is not correct anymore because, if
per-file data journaling of a file is enabled while ext4_writepages()
is being executed, this BUG_ON() function can cause a kernel panic
unintentionally even on "nodelalloc" mode.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
---
 fs/ext4/inode.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1f9458e..db24348 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2480,13 +2480,11 @@ retry:
 		}
 
 		/*
-		 * We have two constraints: We find one extent to map and we
+		 * We have a constraint: We find one extent to map and we
 		 * must always write out whole page (makes a difference when
 		 * blocksize < pagesize) so that we don't block on IO when we
-		 * try to write out the rest of the page. Journalled mode is
-		 * not supported by delalloc.
+		 * try to write out the rest of the page.
 		 */
-		BUG_ON(ext4_should_journal_data(inode));
 		needed_blocks = ext4_da_writepages_trans_blocks(inode);
 
 		/* start a new transaction */
-- 
1.7.9.5

