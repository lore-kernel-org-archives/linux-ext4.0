From: Curt Wohlgemuth <curtw@google.com>
Subject: ext4: Fix data corruption with multi-block writepages support
Date: Tue, 1 Feb 2011 09:51:26 -0800
Message-ID: <AANLkTinadVSGuoZwtNfahxVYneRDUe_4_qpyuoidHoVd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:37096 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1BARva (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Feb 2011 12:51:30 -0500
Received: from wpaz5.hot.corp.google.com (wpaz5.hot.corp.google.com [172.24.198.69])
	by smtp-out.google.com with ESMTP id p11HpSok017081
	for <linux-ext4@vger.kernel.org>; Tue, 1 Feb 2011 09:51:28 -0800
Received: from vws9 (vws9.prod.google.com [10.241.21.137])
	by wpaz5.hot.corp.google.com with ESMTP id p11HovHs002353
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 1 Feb 2011 09:51:27 -0800
Received: by vws9 with SMTP id 9so2449206vws.27
        for <linux-ext4@vger.kernel.org>; Tue, 01 Feb 2011 09:51:27 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes a corruption problem with the multi-block
writepages submittal change for ext4, from commit
bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc ("ext4: use bio
layer instead of buffer layer in mpage_da_submit_io").

(Note that this corruption is not present in 2.6.37 on ext4,
because the multi-block writepages function is only enabled
by a non-default mount option.  With the patch below, we can
eventually remove this mount option.)

The ext4 code path to bundle multiple pages for writeback in
ext4_bio_write_page() had a bug:  we should be clearing
buffer head dirty flags *before* we submit the bio, not in
the completion routine.

The patch below was tested on 2.6.37 under KVM with the
postgresql script specified by Ted Tso in
1449032be17abb69116dbc393f67ceb8bd034f92 -- without this
commit, and hence by default using the multiblock writepages
submittal code.

Without the patch, I'd hit the corruption problem about
50-70% of the time.  With the patch, I executed the script
> 100 times with no corruption seen.

Also don't dereference the bio in ext4_end_bio() after the
bio_put() call.

(I also added a blank line in ext4_bio_write_page(), 'cause
my eyes constantly confused the complex 'for' conditions
from the first statement in the block.)

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
