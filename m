From: Saugata Das <saugata.das@stericsson.com>
Subject: [PATCH v2 1/2] block: add BH_Meta flag
Date: Thu, 17 May 2012 17:51:29 +0530
Message-ID: <1337257290-28547-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <arnd.bergmann@linaro.org>, <venkat@linaro.org>,
	<lporzio@micron.com>, <tytso@mit.edu>, <adilger@dilger.ca>,
	<hch@infradead.org>, <bharrosh@panasas.com>,
	<deepak.saxena@linaro.org>, Saugata Das <saugata.das@linaro.org>
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<patches@linaro.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Saugata Das <saugata.das@linaro.org>

Today, storage devices like eMMC has special features like data tagging
(introduced in MMC-4.5 version) in order to improve performance of some
specific writes. On MMC stack, data tagging is used for all writes which
has REQ_META flag set. This patch adds the capability to add REQ_META flag
during meta data write.

Signed-off-by: Saugata Das <saugata.das@linaro.org>

changes in v2:
	Replaced the conditionals around submit_bh as suggested in the review
	comments from Boaz
---
 fs/buffer.c                 |    6 ++++--
 include/linux/buffer_head.h |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 36d6665..942c75b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1685,7 +1685,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(write_op, bh);
+			submit_bh(write_op |
+				(buffer_meta(bh) << __REQ_META), bh);
 			nr_underway++;
 		}
 		bh = next;
@@ -1739,7 +1740,8 @@ recover:
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
 			clear_buffer_dirty(bh);
-			submit_bh(write_op, bh);
+			submit_bh(write_op |
+				(buffer_meta(bh) << __REQ_META), bh);
 			nr_underway++;
 		}
 		bh = next;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 458f497..13bba17 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -34,6 +34,7 @@ enum bh_state_bits {
 	BH_Write_EIO,	/* I/O error on write */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */
+	BH_Meta,	/* Is meta */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -124,6 +125,7 @@ BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
+BUFFER_FNS(Meta, meta)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
-- 
1.7.4.3

