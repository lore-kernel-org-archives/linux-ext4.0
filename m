From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH RESEND] ext4: correct error value of function verifying dx
 checksum
Date: Mon, 04 Jul 2016 09:15:04 +0900
Message-ID: <1467591304-4981-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54578 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbcGDAMn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Jul 2016 20:12:43 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O9R021N0KL4JM70@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Mon, 04 Jul 2016 09:12:40 +0900 (KST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_dx_csum_verify() returns the success return value in two checksum
verification failure cases. We need to set the return values to zero
as failure like ext4_dirent_csum_verify() returning zero when failing
to find a checksum dirent at the tail.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 48e4b89..ec811bb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -446,14 +446,14 @@ static int ext4_dx_csum_verify(struct inode *inode,
 	c = get_dx_countlimit(inode, dirent, &count_offset);
 	if (!c) {
 		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
-		return 1;
+		return 0;
 	}
 	limit = le16_to_cpu(c->limit);
 	count = le16_to_cpu(c->count);
 	if (count_offset + (limit * sizeof(struct dx_entry)) >
 	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
 		warn_no_space_for_csum(inode);
-		return 1;
+		return 0;
 	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
-- 
1.7.9.5

