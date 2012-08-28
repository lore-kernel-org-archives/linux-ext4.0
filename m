From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/3] ext4: basic bug shield for move_extent_per_page
Date: Tue, 28 Aug 2012 20:21:42 +0400
Message-ID: <1346170903-7563-2-git-send-email-dmonakhov@openvz.org>
References: <1346170903-7563-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, a-fujita@rs.jp.nec.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65408 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab2H1QWD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Aug 2012 12:22:03 -0400
Received: by mail-lpp01m010-f46.google.com with SMTP id y9so3410021lag.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Aug 2012 09:22:02 -0700 (PDT)
In-Reply-To: <1346170903-7563-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The move_extent_per_page function is just one big peace of crap.

Non-full list of bugs:
1) uninitialized extent optimization does not hold page's lock,
   and simply replace brunches, so writeback code goes
   crazy because block mapping changed under it's feets
   kernel BUG at fs/ext4/inode.c:1434!

2) uninitialized extent may became initialized right after we
   drop i_data_sem, so extent state must be rechecked

3) Locked pages goes up to date via following sequence:
   ->readpage(page); lock_page(page); use_that_page(page)
   But after readpage() one may invalidate it because it is
   uptodate and unlocked (reclaimer does that)
   As result kernel bug at include/linux/buffer_head.c:133!
4) We call write_begin() with already opened stansaction which
   result in following deadlock:
->move_extent_per_page()
  ->ext4_journal_start()-> hold journal transaction
  ->write_begin()
    ->ext4_da_write_begin()
      ->ext4_nonda_switch()
        ->writeback_inodes_sb_if_idle()  --> will wait for journal_stop()

5) try_to_release_page() may fail and it does fail if one of page's bh was
   pinned by journal

6) If we about to change page's mapping we MUST hold it's lock during entire
   remapping procedure, this is true for both pages(original and donor one)

Fixes:

- Avoid (1) and (2) simply by temproraly drop uninitialized extent handling
  optimization, this will be reimplemented later.

- Fix (3) by manually forcing page to uptodate state w/o dropping it's lock

- Fix (4) by rearranging existing locking:
  from: journal_start(); ->write_begin
  to: write_begin(); journal_extend()
- Fix (5) simply by checking retvalue
- (6) requires full function's code rearrangement, will be done later.
---
 fs/ext4/move_extent.c |   74 ++++++++++++++++++++++++-------------------------
 1 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c5826c6..c5ca317 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -812,11 +812,6 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	 * inode and donor_inode may change each different metadata blocks.
 	 */
 	jblocks = ext4_writepage_trans_blocks(orig_inode) * 2;
-	handle = ext4_journal_start(orig_inode, jblocks);
-	if (IS_ERR(handle)) {
-		*err = PTR_ERR(handle);
-		return 0;
-	}
 
 	if (segment_eq(get_fs(), KERNEL_DS))
 		w_flags |= AOP_FLAG_UNINTERRUPTIBLE;
@@ -824,19 +819,6 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	orig_blk_offset = orig_page_offset * blocks_per_page +
 		data_offset_in_page;
 
-	/*
-	 * If orig extent is uninitialized one,
-	 * it's not necessary force the page into memory
-	 * and then force it to be written out again.
-	 * Just swap data blocks between orig and donor.
-	 */
-	if (uninit) {
-		replaced_count = mext_replace_branches(handle, orig_inode,
-						donor_inode, orig_blk_offset,
-						block_len_in_page, err);
-		goto out2;
-	}
-
 	offs = (long long)orig_blk_offset << orig_inode->i_blkbits;
 
 	/* Calculate data_size */
@@ -862,12 +844,28 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 				 &page, &fsdata);
 	if (unlikely(*err < 0))
 		goto out;
+	handle = journal_current_handle();
 
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, 1 << orig_inode->i_blkbits, 0);
+
+	/* Force page uptodate similar block_write_commit */
+	page_zero_new_buffers(page, 0, PAGE_SIZE);
 	if (!PageUptodate(page)) {
-		mapping->a_ops->readpage(o_filp, page);
-		lock_page(page);
+		struct buffer_head *head, *bh;
+		bh = head =  page_buffers(page);
+		do {
+			if (!bh_uptodate_or_lock(bh)) {
+				if (bh_submit_read(bh) < 0) {
+					put_bh(bh);
+					err2  = -EIO;
+					goto drop_page;
+				}
+			}
+			bh = bh->b_this_page;
+		} while (bh != head);
 	}
-
+	SetPageUptodate(page);
 	/*
 	 * try_to_release_page() doesn't call releasepage in writeback mode.
 	 * We should care about the order of writing to the same file
@@ -876,9 +874,15 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	 * writeback of the page.
 	 */
 	wait_on_page_writeback(page);
-
-	/* Release old bh and drop refs */
-	try_to_release_page(page, 0);
+	/* Finally page is fully uptodate and locked, it is time to drop
+	 * old mapping info, function may fail other task hold reference
+	 * on page's bh */
+	if (!try_to_release_page(page, 0)) {
+		replaced_size = 0;
+		goto write_end;
+	}
+	if (ext4_journal_extend(handle, jblocks) < 0)
+		goto write_end;
 
 	replaced_count = mext_replace_branches(handle, orig_inode, donor_inode,
 					orig_blk_offset, block_len_in_page,
@@ -889,7 +893,7 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 			replaced_size =
 				block_len_in_page << orig_inode->i_blkbits;
 		} else
-			goto out;
+			goto drop_page;
 	}
 
 	if (!page_has_buffers(page))
@@ -903,30 +907,24 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 		*err = ext4_get_block(orig_inode,
 				(sector_t)(orig_blk_offset + i), bh, 0);
 		if (*err < 0)
-			goto out;
+			goto drop_page;
 
 		if (bh->b_this_page != NULL)
 			bh = bh->b_this_page;
 	}
-
+write_end:
 	*err = a_ops->write_end(o_filp, mapping, offs, data_size, replaced_size,
 			       page, fsdata);
-	page = NULL;
-
 out:
-	if (unlikely(page)) {
-		if (PageLocked(page))
-			unlock_page(page);
-		page_cache_release(page);
-		ext4_journal_stop(handle);
-	}
-out2:
-	ext4_journal_stop(handle);
