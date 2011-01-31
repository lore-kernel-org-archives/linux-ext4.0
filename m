From: Curt Wohlgemuth <curtw@google.com>
Subject: ext4: Fix clear_buffer_dirty() call for mblk_io_submit writepages path
Date: Mon, 31 Jan 2011 12:44:57 -0800
Message-ID: <AANLkTi=Mzjqoo_QWNLSjhS5CKt9JdTQB6iHEWp_NPuw_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:40833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1AaUpR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Jan 2011 15:45:17 -0500
Received: from hpaq2.eem.corp.google.com (hpaq2.eem.corp.google.com [172.25.149.2])
	by smtp-out.google.com with ESMTP id p0VKjGax015502
	for <linux-ext4@vger.kernel.org>; Mon, 31 Jan 2011 12:45:16 -0800
Received: from vxd2 (vxd2.prod.google.com [10.241.33.194])
	by hpaq2.eem.corp.google.com with ESMTP id p0VKjEV2021710
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 31 Jan 2011 12:45:15 -0800
Received: by vxd2 with SMTP id 2so343315vxd.8
        for <linux-ext4@vger.kernel.org>; Mon, 31 Jan 2011 12:45:14 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4 code path to bundle multiple pages for writeback in
ext4_bio_write_page() had a bug:  we should be clearing buffer head dirty
flags before we submit the bio, not in the completion routine.

Also don't deference the bio in ext4_end_bio() after the bio_put() call.

(I also added a blank line in ext4_bio_write_page(), 'cause my eyes
constantly confused the complex 'for' conditions from the first statement
in the block.)

Signed-off-by: Curt Wohlgemuth <curtw@google.com>

---

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 6e0e99b..c3d490f 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -193,6 +193,7 @@ static void ext4_end_bio(struct bio *bio, int error)
 	struct inode *inode;
 	unsigned long flags;
 	int i;
+	sector_t bi_sector = bio->bi_sector;

 	BUG_ON(!io_end);
 	bio->bi_private = NULL;
@@ -210,9 +211,7 @@ static void ext4_end_bio(struct bio *bio, int error)
 		if (error)
 			SetPageError(page);
 		BUG_ON(!head);
-		if (head->b_size == PAGE_CACHE_SIZE)
-			clear_buffer_dirty(head);
-		else {
+		if (head->b_size != PAGE_CACHE_SIZE) {
 			loff_t offset;
 			loff_t io_end_offset = io_end->offset + io_end->size;

@@ -224,7 +223,6 @@ static void ext4_end_bio(struct bio *bio, int error)
 					if (error)
 						buffer_io_error(bh);

-					clear_buffer_dirty(bh);
 				}
 				if (buffer_delay(bh))
 					partial_write = 1;
@@ -260,7 +258,7 @@ static void ext4_end_bio(struct bio *bio, int error)
 			     (unsigned long long) io_end->offset,
 			     (long) io_end->size,
 			     (unsigned long long)
-			     bio->bi_sector >> (inode->i_blkbits - 9));
+			     bi_sector >> (inode->i_blkbits - 9));
 	}

 	/* Add the io_end to per-inode completed io list*/
@@ -383,6 +381,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,

 	blocksize = 1 << inode->i_blkbits;

+	BUG_ON(!PageLocked(page));
 	BUG_ON(PageWriteback(page));
 	set_page_writeback(page);
 	ClearPageError(page);
@@ -400,12 +399,14 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	for (bh = head = page_buffers(page), block_start = 0;
 	     bh != head || !block_start;
 	     block_start = block_end, bh = bh->b_this_page) {
+
 		block_end = block_start + blocksize;
 		if (block_start >= len) {
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
 			continue;
 		}
+		clear_buffer_dirty(bh);
 		ret = io_submit_add_bh(io, io_page, inode, wbc, bh);
 		if (ret) {
 			/*
