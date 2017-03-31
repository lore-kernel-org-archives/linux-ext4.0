From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH 3/4] buffer: set wb errors using both new and old infrastructure for now
Date: Fri, 31 Mar 2017 15:26:02 -0400
Message-ID: <20170331192603.16442-4-jlayton@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz,
        willy@infradead.org, neilb@suse.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170331192603.16442-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In later patches, we'll be converting filesystems over to use the new
filemap_*_wb_error API for storing and reporting writeback errors.

Since several different filesystems use the code in buffer.c, ensure
that we report errors using both schemes for now. Eventually we
should be able to remove the mapping_set_error calls once nothing
relies on it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/buffer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9196f2a270da..5dde6de2408f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -354,6 +354,7 @@ void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 	} else {
 		buffer_io_error(bh, ", lost async page write");
 		mapping_set_error(page->mapping, -EIO);
+		filemap_set_wb_error(page->mapping, -EIO);
 		set_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);
 		SetPageError(page);
@@ -1879,6 +1880,7 @@ int __block_write_full_page(struct inode *inode, struct page *page,
 	SetPageError(page);
 	BUG_ON(PageWriteback(page));
 	mapping_set_error(page->mapping, err);
+	filemap_set_wb_error(page->mapping, err);
 	set_page_writeback(page);
 	do {
 		struct buffer_head *next = bh->b_this_page;
@@ -3291,8 +3293,10 @@ drop_buffers(struct page *page, struct buffer_head **buffers_to_free)
 
 	bh = head;
 	do {
-		if (buffer_write_io_error(bh) && page->mapping)
+		if (buffer_write_io_error(bh) && page->mapping) {
 			mapping_set_error(page->mapping, -EIO);
+			filemap_set_wb_error(page->mapping, -EIO);
+		}
 		if (buffer_busy(bh))
 			goto failed;
 		bh = bh->b_this_page;
-- 
2.9.3
