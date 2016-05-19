From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH] ext4: correct error value of function verifying dx checksum
Date: Fri, 20 May 2016 08:54:56 +0900
Message-ID: <1463702096-11386-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: tytso@mit.edu, darrick.wong@oracle.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:56127 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbcESXxW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 May 2016 19:53:22 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O7G01SBQ7OV9D70@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 20 May 2016 08:53:19 +0900 (KST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_dx_csum_verify() returns the success return value in two checksum
verification failure cases. We need to set the return values to zero
as failure like ext4_dirent_csum_verify() returning zero when failing
to find a checksum dirent at the tail.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
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

