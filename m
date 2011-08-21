From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 5/6 v5] ext4: fix fsx truncate failure
Date: Sat, 20 Aug 2011 19:29:46 -0700
Message-ID: <1313893787-25460-6-git-send-email-achender@linux.vnet.ibm.com>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34770 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab1HUC0n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Aug 2011 22:26:43 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7L2D5wP013109
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:13:05 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7L2Qggu198998
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:42 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7L2QgUF008830
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:42 -0400
In-Reply-To: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch corrects a bug found during extended fsx
testing for the first two patches.

This bug is caused because the truncate routine only zeros
the unblock aligned portion of the last page.  This means
that the block aligned portions of the page appearing after
i_size are left unzeroed, and the buffer heads still mapped.

This bug is corrected by using ext4_discard_partial_page_buffers
in the truncate routine to zero the partial page and unmap
the buffer headers

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 b417e47... fe421bf... M	fs/ext4/extents.c
 fs/ext4/extents.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b417e47..fe421bf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3644,6 +3644,7 @@ void ext4_ext_truncate(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t last_block;
 	handle_t *handle;
+	loff_t page_len;
 	int err = 0;
 
 	/*
@@ -3660,8 +3661,16 @@ void ext4_ext_truncate(struct inode *inode)
 	if (IS_ERR(handle))
 		return;
 
-	if (inode->i_size & (sb->s_blocksize - 1))
-		ext4_block_truncate_page(handle, mapping, inode->i_size);
+	 if (inode->i_size % PAGE_CACHE_SIZE != 0) {
+
+		page_len = PAGE_CACHE_SIZE -
+			(inode->i_size & (PAGE_CACHE_SIZE - 1));
+
+		if (page_len >= sb->s_blocksize) {
+			ext4_discard_partial_page_buffers(handle,
+			mapping, inode->i_size, page_len, 0);
+		}
+	}
 
 	if (ext4_orphan_add(handle, inode))
 		goto out_stop;
-- 
1.7.1

