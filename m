From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 3/4] ext4: Move some static functions around
Date: Thu,  4 Jun 2009 11:40:04 +0530
Message-ID: <1244095805-17015-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1244095805-17015-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1244095805-17015-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34460 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZFDGKr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 02:10:47 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp09.au.ibm.com (8.13.1/8.13.1) with ESMTP id n5467bdO005067
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:07:37 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n546AjuG798726
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:10:45 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n546Aipw013084
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:10:45 +1000
In-Reply-To: <1244095805-17015-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move some static functions around so that we can
avoid some forward declaration. Also fix some compile
warnings

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |  110 +++++++++++++++++++++++++++----------------------------
 fs/ext4/namei.c |    2 +-
 2 files changed, 55 insertions(+), 57 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7cfacff..2219daa 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -933,11 +933,8 @@ static int ext4_ind_get_blocks(handle_t *handle, struct inode *inode,
 	int indirect_blks;
 	int blocks_to_boundary = 0;
 	int depth;
-	struct ext4_inode_info *ei = EXT4_I(inode);
 	int count = 0;
 	ext4_fsblk_t first_block = 0;
-	loff_t disksize;
-
 
 	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
 	J_ASSERT(handle != NULL || (flags & EXT4_GET_BLOCKS_CREATE) == 0);
@@ -2438,6 +2435,60 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
+static int bget_one(handle_t *handle, struct buffer_head *bh)
+{
+	get_bh(bh);
+	return 0;
+}
+
+static int bput_one(handle_t *handle, struct buffer_head *bh)
+{
+	put_bh(bh);
+	return 0;
+}
+
+static int __ext4_journalled_writepage(struct page *page,
+					struct writeback_control *wbc,
+					unsigned int len)
+{
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	struct buffer_head *page_bufs;
+	handle_t *handle = NULL;
+	int ret = 0;
+	int err;
+
+	page_bufs = page_buffers(page);
+	BUG_ON(!page_bufs);
+	walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
+	/* As soon as we unlock the page, it can go away, but we have
+	 * references to buffers so we are safe */
+	unlock_page(page);
+
+	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+
+	ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
+				do_journal_get_write_access);
+
+	err = walk_page_buffers(handle, page_bufs, 0, len, NULL,
+				write_end_fn);
+	if (ret == 0)
+		ret = err;
+	err = ext4_journal_stop(handle);
+	if (!ret)
+		ret = err;
+
+	walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
+	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
+out:
+	return ret;
+}
+
+
 /*
  * Note that we don't need to start a transaction unless we're journaling data
  * because we should have holes filled from ext4_page_mkwrite(). We even don't
@@ -3114,59 +3165,6 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping, block, ext4_get_block);
 }
 
-static int bget_one(handle_t *handle, struct buffer_head *bh)
-{
-	get_bh(bh);
-	return 0;
-}
-
-static int bput_one(handle_t *handle, struct buffer_head *bh)
-{
-	put_bh(bh);
-	return 0;
-}
-
-static int __ext4_journalled_writepage(struct page *page,
-					struct writeback_control *wbc,
-					unsigned int len)
-{
-	struct address_space *mapping = page->mapping;
-	struct inode *inode = mapping->host;
-	struct buffer_head *page_bufs;
-	handle_t *handle = NULL;
-	int ret = 0;
-	int err;
-
-	page_bufs = page_buffers(page);
-	BUG_ON(!page_bufs);
-	walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
-	/* As soon as we unlock the page, it can go away, but we have
-	 * references to buffers so we are safe */
-	unlock_page(page);
-
-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out;
-	}
-
-	ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
-				do_journal_get_write_access);
-
-	err = walk_page_buffers(handle, page_bufs, 0, len, NULL,
-				write_end_fn);
-	if (ret == 0)
-		ret = err;
-	err = ext4_journal_stop(handle);
-	if (!ret)
-		ret = err;
-
-	walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
-	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
-out:
-	return ret;
-}
