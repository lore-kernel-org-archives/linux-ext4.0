From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext3: Fix buffer dirtying in data=journal mode
Date: Mon, 21 Jun 2010 12:42:52 +0200
Message-ID: <1277116973-4183-2-git-send-email-jack@suse.cz>
References: <1277116973-4183-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab0FUKnY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jun 2010 06:43:24 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 2FED8867E2
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jun 2010 12:43:23 +0200 (CEST)
In-Reply-To: <1277116973-4183-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

block_prepare_write() can dirty freshly created buffer. This is a problem
for data=journal mode because data buffers shouldn't be dirty unless they
are undergoing checkpoint. So we have to tweak get_block function for
data=journal mode to catch the case when block_prepare_write would dirty
the buffer, do the work instead of block_prepare_write, and properly handle
dirty buffer as data=journal mode requires it.

It might be cleaner to avoid using block_prepare_write() for data=journal
mode writes but that would require us to duplicate most of the function
which isn't nice either...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index ea33bdf..2b61cc4 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -993,6 +993,43 @@ out:
 	return ret;
 }
 
+static int ext3_journalled_get_block(struct inode *inode, sector_t iblock,
+				     struct buffer_head *bh, int create)
+{
+	handle_t *handle = ext3_journal_current_handle();
+	int ret;
+
+	/* This function should ever be used only for real buffers */
+	BUG_ON(!bh->b_page);
+
+	ret = ext3_get_blocks_handle(handle, inode, iblock, 1, bh, create);
+	if (ret > 0) {
+		if (buffer_new(bh)) {
+			struct page *page = bh->b_page;
+
+			/*
+			 * This is a terrible hack to avoid block_prepare_write
+			 * marking our buffer as dirty
+			 */
+			if (PageUptodate(page)) {
+				ret = ext3_journal_get_write_access(handle, bh);
+				if (ret < 0)
+					goto out;
+				unmap_underlying_metadata(bh->b_bdev,
+							  bh->b_blocknr);
+				clear_buffer_new(bh);
+				set_buffer_uptodate(bh);
+				ret = ext3_journal_dirty_metadata(handle, bh);
+				if (ret < 0)
+					goto out;
+			}
+		}
+		ret = 0;
+	}
+out:
+	return ret;
+}
+
 int ext3_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		u64 start, u64 len)
 {
@@ -1196,15 +1233,18 @@ retry:
 		ret = PTR_ERR(handle);
 		goto out;
 	}
-	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-							ext3_get_block);
-	if (ret)
-		goto write_begin_failed;
-
 	if (ext3_should_journal_data(inode)) {
-		ret = walk_page_buffers(handle, page_buffers(page),
-				from, to, NULL, do_journal_get_write_access);
+		ret = block_write_begin(file, mapping, pos, len, flags, pagep,
+					fsdata, ext3_journalled_get_block);
+		if (ret)
+			goto write_begin_failed;
+		ret = walk_page_buffers(handle, page_buffers(page), from, to,
+					NULL, do_journal_get_write_access);
+	} else {
+		ret = block_write_begin(file, mapping, pos, len, flags, pagep,
+					fsdata, ext3_get_block);
 	}
+
 write_begin_failed:
 	if (ret) {
 		/*
@@ -1668,7 +1708,7 @@ static int ext3_journalled_writepage(struct page *page,
 		 */
 		ClearPageChecked(page);
 		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
-					ext3_get_block);
+					ext3_journalled_get_block);
 		if (ret != 0) {
 			ext3_journal_stop(handle);
 			goto out_unlock;
-- 
1.6.4.2

