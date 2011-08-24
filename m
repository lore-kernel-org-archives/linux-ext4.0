From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 4/5 v6] ext4: fix fsx truncate failure
Date: Wed, 24 Aug 2011 12:07:21 -0700
Message-ID: <1314212842-16741-5-git-send-email-achender@linux.vnet.ibm.com>
References: <1314212842-16741-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53618 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab1HXTF0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Aug 2011 15:05:26 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7OIfGF3015912
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 14:41:16 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7OJ5DwV2433058
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 15:05:13 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7OD3rgE024636
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 07:03:58 -0600
In-Reply-To: <1314212842-16741-1-git-send-email-achender@linux.vnet.ibm.com>
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
:100644 100644 3e87a43... 98a23b2... M	fs/ext4/extents.c
:100644 100644 b8602cd... c11bfcd... M	fs/ext4/indirect.c
 fs/ext4/extents.c  |   14 ++++++++++++--
 fs/ext4/indirect.c |   16 ++++++++++++++--
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3e87a43..98a23b2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3644,6 +3644,7 @@ void ext4_ext_truncate(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t last_block;
 	handle_t *handle;
+	loff_t page_len;
 	int err = 0;
 
 	/*
@@ -3660,8 +3661,17 @@ void ext4_ext_truncate(struct inode *inode)
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
index b8602cd..c11bfcd 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1338,7 +1338,9 @@ void ext4_ind_truncate(struct inode *inode)
 	__le32 nr = 0;
 	int n = 0;
 	ext4_lblk_t last_block, max_block;
+	loff_t page_len;
 	unsigned blocksize = inode->i_sb->s_blocksize;
+	int err;
 
 	handle = start_transaction(inode);
 	if (IS_ERR(handle))
@@ -1349,9 +1351,19 @@ void ext4_ind_truncate(struct inode *inode)
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

