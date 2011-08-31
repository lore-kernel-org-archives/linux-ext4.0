From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 5/6 v7] ext4: fix fsx truncate failure
Date: Tue, 30 Aug 2011 17:28:32 -0700
Message-ID: <1314750513-10045-6-git-send-email-achender@linux.vnet.ibm.com>
References: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40296 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab1HaAZ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Aug 2011 20:25:26 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7UN5Obp008429
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 19:05:24 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7V0PPa1213132
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 20:25:25 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7V0PPBH001616
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 21:25:25 -0300
In-Reply-To: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While running extended fsx tests to verify the first
two patches, a similar bug was also found in the
truncate operation

This bug happens because the truncate routine only zeros
the unblock aligned portion of the last page.  This means
that the block aligned portions of the page appearing after
i_size are left unzeroed, and the buffer heads still mapped.

This bug is corrected by using ext4_discard_partial_page_buffers
in the truncate routine to zero the partial page and unmap
the buffer headers

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 007fb08... b6cb686... M	fs/ext4/extents.c
:100644 100644 0962642... 9ae1d44... M	fs/ext4/indirect.c
 fs/ext4/extents.c  |   14 ++++++++++++--
 fs/ext4/indirect.c |   16 ++++++++++++++--
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 007fb08..b6cb686 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3649,6 +3649,7 @@ void ext4_ext_truncate(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t last_block;
 	handle_t *handle;
+	loff_t page_len;
 	int err = 0;
 
 	/*
@@ -3665,8 +3666,17 @@ void ext4_ext_truncate(struct inode *inode)
 	if (IS_ERR(handle))
 		return;
 
-	if (inode->i_size & (sb->s_blocksize - 1))
-		ext4_block_truncate_page(handle, mapping, inode->i_size);
+	if (inode->i_size % PAGE_CACHE_SIZE != 0) {
+
+		page_len = PAGE_CACHE_SIZE -
+			(inode->i_size & (PAGE_CACHE_SIZE - 1));
+
+		err = ext4_discard_partial_page_buffers(handle,
+			mapping, inode->i_size, page_len, 0);
+
+		if (err)
+			goto out_stop;
+	}
 
 	if (ext4_orphan_add(handle, inode))
 		goto out_stop;
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 0962642..9ae1d44 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1343,7 +1343,9 @@ void ext4_ind_truncate(struct inode *inode)
 	__le32 nr = 0;
 	int n = 0;
 	ext4_lblk_t last_block, max_block;
+	loff_t page_len;
 	unsigned blocksize = inode->i_sb->s_blocksize;
+	int err;
 
 	handle = start_transaction(inode);
 	if (IS_ERR(handle))
@@ -1354,9 +1356,19 @@ void ext4_ind_truncate(struct inode *inode)
 	max_block = (EXT4_SB(inode->i_sb)->s_bitmap_maxbytes + blocksize-1)
 					>> EXT4_BLOCK_SIZE_BITS(inode->i_sb);
 
-	if (inode->i_size & (blocksize - 1))
-		if (ext4_block_truncate_page(handle, mapping, inode->i_size))
+
+	if (inode->i_size % PAGE_CACHE_SIZE != 0) {
+
+		page_len = PAGE_CACHE_SIZE -
+			(inode->i_size & (PAGE_CACHE_SIZE - 1));
+
+		err = ext4_discard_partial_page_buffers(handle,
+			mapping, inode->i_size, page_len, 0);
+
+		if (err)
 			goto out_stop;
+	}
+
 
 	if (last_block != max_block) {
 		n = ext4_block_to_path(inode, last_block, offsets, NULL);
-- 
1.7.1

