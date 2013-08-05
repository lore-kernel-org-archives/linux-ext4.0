From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] ext4: Fix ext4_writepages() in presence of truncate
Date: Mon,  5 Aug 2013 15:52:22 +0200
Message-ID: <1375710744-29329-3-git-send-email-jack@suse.cz>
References: <1375710744-29329-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab3HENw3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Aug 2013 09:52:29 -0400
In-Reply-To: <1375710744-29329-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode size can arbitrarily change while writeback is in progress. When
ext4_writepages() has prepared a long extent for mapping and truncate
then reduces i_size, mpage_map_and_submit_buffers() will always map just
one buffer in a page instead of all of them due to lblk < blocks check.
So we end up not using all blocks we've allocated (thus leaking them)
and also delalloc accounting goes wrong manifesting as a warning like:

ext4_da_release_space:1333: ext4_da_release_space: ino 12, to_free 1
with only 0 reserved data blocks

Note that the problem can happen only when blocksize < pagesize because
otherwise we have only a single buffer in the page.

Fix the problem by removing the size check from the mapping loop. We
have an extent allocated so we have to use it all before checking for
i_size. We also rename add_page_bufs_to_extent() to
mpage_process_page_bufs() and make that function submit the page for IO
if all buffers (upto EOF) in it are mapped.

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 107 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 66 insertions(+), 41 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index afaf26b..4263878 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1893,6 +1893,26 @@ static int ext4_writepage(struct page *page,
 	return ret;
 }
 
+static int mpage_submit_page(struct mpage_da_data *mpd, struct page *page)
+{
+	int len;
+	loff_t size = i_size_read(mpd->inode);
+	int err;
+
+	BUG_ON(page->index != mpd->first_page);
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+	clear_page_dirty_for_io(page);
+	err = ext4_bio_write_page(&mpd->io_submit, page, len, mpd->wbc);
+	if (!err)
+		mpd->wbc->nr_to_write--;
+	mpd->first_page++;
+
+	return err;
+}
+
 #define BH_FLAGS ((1 << BH_Unwritten) | (1 << BH_Delay))
 
 /*
@@ -1951,12 +1971,29 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
 	return false;
 }
 
-static bool add_page_bufs_to_extent(struct mpage_da_data *mpd,
-				    struct buffer_head *head,
-				    struct buffer_head *bh,
-				    ext4_lblk_t lblk)
+/*
+ * mpage_process_page_bufs - submit page buffers for IO or add them to extent
+ *
+ * @mpd - extent of blocks for mapping
+ * @head - the first buffer in the page
+ * @bh - buffer we should start processing from
+ * @lblk - logical number of the block in the file corresponding to @bh
+ *
+ * Walk through page buffers from @bh upto @head (exclusive) and either submit
+ * the page for IO if all buffers in this page were mapped and there's no
+ * accumulated extent of buffers to map or add buffers in the page to the
+ * extent of buffers to map. The function returns 1 if the caller can continue
+ * by processing the next page, 0 if it should stop adding buffers to the
+ * extent to map because we cannot extend it anymore. It can also return value
+ * < 0 in case of error during IO submission.
+ */
+static int mpage_process_page_bufs(struct mpage_da_data *mpd,
+				   struct buffer_head *head,
+				   struct buffer_head *bh,
+				   ext4_lblk_t lblk)
 {
 	struct inode *inode = mpd->inode;
+	int err;
 	ext4_lblk_t blocks = (i_size_read(inode) + (1 << inode->i_blkbits) - 1)
 							>> inode->i_blkbits;
 
@@ -1966,32 +2003,18 @@ static bool add_page_bufs_to_extent(struct mpage_da_data *mpd,
 		if (lblk >= blocks || !mpage_add_bh_to_extent(mpd, lblk, bh)) {
 			/* Found extent to map? */
 			if (mpd->map.m_len)
-				return false;
+				return 0;
 			/* Everything mapped so far and we hit EOF */
-			return true;
+			break;
 		}
 	} while (lblk++, (bh = bh->b_this_page) != head);
-	return true;
-}
-
-static int mpage_submit_page(struct mpage_da_data *mpd, struct page *page)
-{
-	int len;
-	loff_t size = i_size_read(mpd->inode);
-	int err;
-
-	BUG_ON(page->index != mpd->first_page);
-	if (page->index == size >> PAGE_CACHE_SHIFT)
-		len = size & ~PAGE_CACHE_MASK;
-	else
-		len = PAGE_CACHE_SIZE;
-	clear_page_dirty_for_io(page);
-	err = ext4_bio_write_page(&mpd->io_submit, page, len, mpd->wbc);
-	if (!err)
-		mpd->wbc->nr_to_write--;
-	mpd->first_page++;
-
-	return err;
+	/* So far everything mapped? Submit the page for IO. */
+	if (mpd->map.m_len == 0) {
+		err = mpage_submit_page(mpd, head->b_page);
+		if (err < 0)
+			return err;
+	}
+	return lblk < blocks;
 }
 
 /*
@@ -2015,8 +2038,6 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 	struct inode *inode = mpd->inode;
 	struct buffer_head *head, *bh;
 	int bpp_bits = PAGE_CACHE_SHIFT - inode->i_blkbits;
-	ext4_lblk_t blocks = (i_size_read(inode) + (1 << inode->i_blkbits) - 1)
-							>> inode->i_blkbits;
 	pgoff_t start, end;
 	ext4_lblk_t lblk;
 	sector_t pblock;
@@ -2051,18 +2072,26 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 					 */
 					mpd->map.m_len = 0;
 					mpd->map.m_flags = 0;
-					add_page_bufs_to_extent(mpd, head, bh,
-								lblk);
+					/*
+					 * FIXME: If dioread_nolock supports
+					 * blocksize < pagesize, we need to make
+					 * sure we add size mapped so far to
+					 * io_end->size as the following call
+					 * can submit the page for IO.
+					 */
+					err = mpage_process_page_bufs(mpd, head,
+								      bh, lblk);
 					pagevec_release(&pvec);
-					return 0;
+					if (err > 0)
+						err = 0;
+					return err;
 				}
 				if (buffer_delay(bh)) {
 					clear_buffer_delay(bh);
 					bh->b_blocknr = pblock++;
 				}
 				clear_buffer_unwritten(bh);
-			} while (++lblk < blocks &&
-				 (bh = bh->b_this_page) != head);
+			} while (lblk++, (bh = bh->b_this_page) != head);
 
 			/*
 			 * FIXME: This is going to break if dioread_nolock
@@ -2331,14 +2360,10 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			lblk = ((ext4_lblk_t)page->index) <<
 				(PAGE_CACHE_SHIFT - blkbits);
 			head = page_buffers(page);
-			if (!add_page_bufs_to_extent(mpd, head, head, lblk))
+			err = mpage_process_page_bufs(mpd, head, head, lblk);
+			if (err <= 0)
 				goto out;
-			/* So far everything mapped? Submit the page for IO. */
-			if (mpd->map.m_len == 0) {
-				err = mpage_submit_page(mpd, page);
-				if (err < 0)
-					goto out;
-			}
+			err = 0;
 
 			/*
 			 * Accumulated enough dirty pages? This doesn't apply
-- 
1.8.1.4

