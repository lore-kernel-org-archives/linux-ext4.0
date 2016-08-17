From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [RFC 3/3] ext4: tag asynchronous writeback io
Date: Wed, 17 Aug 2016 14:20:45 +0900
Message-ID: <1471411245-5186-4-git-send-email-daeho.jeong@samsung.com>
References: <1471411245-5186-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: axboe@kernel.dk, tytso@mit.edu, adilger.kernel@dilger.ca,
	jack@suse.com, linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:48330 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbcHQFRi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2016 01:17:38 -0400
In-reply-to: <1471411245-5186-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Set the page with PG_asyncwb and PG_plugged, and set the bio with
BIO_ASYNC_WB when submitting asynchronous writeback I/O in order to
mark which pages are flushed as asynchronous writeback I/O and which
one stays in the plug list.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
---
 fs/ext4/page-io.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 2a01df9..5912e59 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -370,6 +370,10 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
 	bio->bi_private = ext4_get_io_end(io->io_end);
 	io->io_bio = bio;
 	io->io_next_block = bh->b_blocknr;
+#ifdef CONFIG_BOOST_URGENT_ASYNC_WB
+	if (io->io_wbc->sync_mode == WB_SYNC_NONE)
+		bio->bi_flags |= (1 << BIO_ASYNC_WB);
+#endif
 	return 0;
 }
 
@@ -416,6 +420,13 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageWriteback(page));
 
+#ifdef CONFIG_BOOST_URGENT_ASYNC_WB
+	if (wbc->sync_mode == WB_SYNC_NONE) {
+		SetPagePlugged(page);
+		SetPageAsyncWB(page);
+	}
+#endif
+
 	if (keep_towrite)
 		set_page_writeback_keepwrite(page);
 	else
-- 
1.7.9.5

