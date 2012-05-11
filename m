From: Saugata Das <saugata.das@stericsson.com>
Subject: [PATCH 1/2] block: add BH_Meta flag
Date: Fri, 11 May 2012 20:32:56 +0530
Message-ID: <1336748577-9258-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <adilger@whamcloud.com>, <hch@infradead.org>,
	<arnd.bergmann@linaro.org>, <venkat@linaro.org>,
	Saugata Das <saugata.das@linaro.org>
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:47104 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082Ab2EKPHP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 May 2012 11:07:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Saugata Das <saugata.das@linaro.org>

Today, storage devices like eMMC has special features like data tagging
(introduced in MMC-4.5 version) in order to improve performance of some
specific writes. On MMC stack, data tagging is used for all writes which
has REQ_META flag set. This patch adds the capability to add REQ_META flag
during meta data write.

Signed-off-by: Saugata Das <saugata.das@linaro.org>
---
 fs/buffer.c                 |   10 ++++++++--
 include/linux/buffer_head.h |    2 ++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 36d6665..688b38b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1685,7 +1685,10 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(write_op, bh);
+			if (buffer_meta(bh))
+				submit_bh(write_op | REQ_META, bh);
+			else
+				submit_bh(write_op, bh);
 			nr_underway++;
 		}
 		bh = next;
@@ -1739,7 +1742,10 @@ recover:
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
 			clear_buffer_dirty(bh);
-			submit_bh(write_op, bh);
+			if (buffer_meta(bh))
+				submit_bh(write_op | REQ_META, bh);
+			else
+				submit_bh(write_op, bh);
 			nr_underway++;
 		}
 		bh = next;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index ef26043..0776564 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -34,6 +34,7 @@ enum bh_state_bits {
 	BH_Write_EIO,	/* I/O error on write */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */
+	BH_Meta,	/* Is meta */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -126,6 +127,7 @@ BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
+BUFFER_FNS(Meta, meta)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
-- 
1.7.4.3

