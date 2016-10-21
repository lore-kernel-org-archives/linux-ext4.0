From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] fs: Provide function to unmap metadata for a range of blocks
Date: Fri, 21 Oct 2016 13:55:38 +0200
Message-ID: <1477050941-29682-2-git-send-email-jack@suse.cz>
References: <1477050941-29682-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52800 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754253AbcJULzu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Oct 2016 07:55:50 -0400
In-Reply-To: <1477050941-29682-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide function equivalent to unmap_underlying_metadata() for a range
of blocks. We somewhat optimize the function to use pagevec lookups
instead of looking up buffer heads one by one and use page lock to pin
buffer heads instead of mapping's private_lock to improve scalability.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 62 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |  2 ++
 2 files changed, 64 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index b205a629001d..26e2953555e9 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -43,6 +43,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
+#include <linux/pagevec.h>
 #include <trace/events/block.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
@@ -1637,6 +1638,67 @@ void unmap_underlying_metadata(struct block_device *bdev, sector_t block)
 EXPORT_SYMBOL(unmap_underlying_metadata);
 
 /*
+ * Functionally, this is like unmap_underlying_metadata() for a range of
+ * blocks. It is implemented to be more efficient for larger ranges of blocks
+ * though.
+ */
+void unmap_underlying_metadata_ext(struct block_device *bdev, sector_t block,
+				   sector_t len)
+{
+	struct inode *bd_inode = bdev->bd_inode;
+	struct address_space *bd_mapping = bd_inode->i_mapping;
+	struct pagevec pvec;
+	pgoff_t index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
+	pgoff_t end;
+	int i;
+	struct buffer_head *bh;
+	struct buffer_head *head;
+
+	end = (block + len - 1) >> (PAGE_SHIFT - bd_inode->i_blkbits);
+	pagevec_init(&pvec, 0);
+	while (index <= end && pagevec_lookup(&pvec, bd_mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+
+			index = page->index;
+			if (index > end)
+				break;
+			if (!page_has_buffers(page))
+				continue;
+			/*
+			 * We use page lock instead of bd_mapping->private_lock
+			 * to pin buffers here since we can afford to sleep and
+			 * it scales better than a global spinlock lock.
+			 */
+			lock_page(page);
+			/* Recheck when the page is locked which pins bhs */
+			if (!page_has_buffers(page))
+				goto unlock_page;
+			head = page_buffers(page);
+			bh = head;
+			do {
+				if (!buffer_mapped(bh))
+					goto next;
+				if (bh->b_blocknr >= block + len)
+					break;
+				clear_buffer_dirty(bh);
+				wait_on_buffer(bh);
+				clear_buffer_req(bh);
+next:
+				bh = bh->b_this_page;
+			} while (bh != head);
+unlock_page:
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+		index++;
+	}
+}
+EXPORT_SYMBOL(unmap_underlying_metadata_ext);
+
+/*
  * Size is a power-of-two in the range 512..PAGE_SIZE,
  * and the case we care about most is PAGE_SIZE.
  *
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index ebbacd14d450..9f2dd6c2f81a 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -169,6 +169,8 @@ void invalidate_inode_buffers(struct inode *);
 int remove_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
 void unmap_underlying_metadata(struct block_device *bdev, sector_t block);
+void unmap_underlying_metadata_ext(struct block_device *bdev, sector_t block,
+				   sector_t len);
 
 void mark_buffer_async_write(struct buffer_head *bh);
 void __wait_on_buffer(struct buffer_head *);
-- 
2.6.6

