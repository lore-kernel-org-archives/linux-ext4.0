From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/6] fs: Provide function to unmap metadata for a range of blocks
Date: Fri,  4 Nov 2016 18:08:11 +0100
Message-ID: <1478279296-6575-2-git-send-email-jack@suse.cz>
References: <1478279296-6575-1-git-send-email-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>,
        linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1478279296-6575-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Provide function equivalent to unmap_underlying_metadata() for a range
of blocks. We somewhat optimize the function to use pagevec lookups
instead of looking up buffer heads one by one and use page lock to pin
buffer heads instead of mapping's private_lock to improve scalability.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 76 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |  2 ++
 2 files changed, 78 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index b205a629001d..05f30838cec3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -43,6 +43,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
+#include <linux/pagevec.h>
 #include <trace/events/block.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
@@ -1636,6 +1637,81 @@ void unmap_underlying_metadata(struct block_device *bdev, sector_t block)
 }
 EXPORT_SYMBOL(unmap_underlying_metadata);
 
+/**
+ * clean_bdev_aliases: clean a range of buffers in block device
+ * @bdev: Block device to clean buffers in
+ * @block: Start of a range of blocks to clean
+ * @len: Number of blocks to clean
+ *
+ * We are taking a range of blocks for data and we don't want writeback of any
+ * buffer-cache aliases starting from return from this function and until the
+ * moment when something will explicitly mark the buffer dirty (hopefully that
+ * will not happen until we will free that block ;-) We don't even need to mark
+ * it not-uptodate - nobody can expect anything from a newly allocated buffer
+ * anyway. We used to used unmap_buffer() for such invalidation, but that was
+ * wrong. We definitely don't want to mark the alias unmapped, for example - it
+ * would confuse anyone who might pick it with bread() afterwards...
+ *
+ * Also..  Note that bforget() doesn't lock the buffer.  So there can be
+ * writeout I/O going on against recently-freed buffers.  We don't wait on that
+ * I/O in bforget() - it's more efficient to wait on the I/O only if we really
+ * need to.  That happens here.
+ */
+void clean_bdev_aliases(struct block_device *bdev, sector_t block, sector_t len)
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
+EXPORT_SYMBOL(clean_bdev_aliases);
+
 /*
  * Size is a power-of-two in the range 512..PAGE_SIZE,
  * and the case we care about most is PAGE_SIZE.
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index ebbacd14d450..9c9c73ce7d4f 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -169,6 +169,8 @@ void invalidate_inode_buffers(struct inode *);
 int remove_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
 void unmap_underlying_metadata(struct block_device *bdev, sector_t block);
+void clean_bdev_aliases(struct block_device *bdev, sector_t block,
+			sector_t len);
 
 void mark_buffer_async_write(struct buffer_head *bh);
 void __wait_on_buffer(struct buffer_head *);
-- 
2.6.6

