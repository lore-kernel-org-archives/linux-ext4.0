From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 12/22] ext4 crypto: implement the ext4 encryption write path
Date: Thu,  2 Apr 2015 18:10:49 -0400
Message-ID: <1428012659-12709-13-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <ildarm@google.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47943 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbbDBWMY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:12:24 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michael Halcrow <mhalcrow@google.com>

Pulls block_write_begin() into fs/ext4/inode.c because it might need
to do a low-level read of the existing data, in which case we need to
decrypt it.

Change-Id: I2337918809c43e18454a1d5621024d2699a98666
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Ildar Muslukhov <ildarm@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents.c |   6 +++
 fs/ext4/ialloc.c  |   5 +++
 fs/ext4/inode.c   | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/page-io.c |  46 +++++++++++++++++++---
 4 files changed, 164 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bed4308..1f1c0ea 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4922,6 +4922,12 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	ext4_lblk_t lblk;
 	unsigned int blkbits = inode->i_blkbits;
 
+	/*
+	 * TODO: We don't yet support fallocate with encrypted files.
+	 */
+	if (ext4_encrypted_inode(inode))
+		return -EOPNOTSUPP;
+
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index ac644c3..e554ca3 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -997,6 +997,11 @@ got:
 	ei->i_block_group = group;
 	ei->i_last_alloc_group = ~0;
 
+	/* If the directory encrypted, then we should encrypt the inode. */
+	if ((S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) &&
+	    ext4_encrypted_inode(dir))
+		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
+
 	ext4_set_inode_flags(inode);
 	if (IS_DIRSYNC(inode))
 		ext4_handle_sync(handle);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a68cacc..dcc836c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 
 #include "ext4_jbd2.h"
+#include "ext4_crypto.h"
 #include "xattr.h"
 #include "acl.h"
 #include "truncate.h"
@@ -871,6 +872,95 @@ int do_journal_get_write_access(handle_t *handle,
 
 static int ext4_get_block_write_nolock(struct inode *inode, sector_t iblock,
 		   struct buffer_head *bh_result, int create);
+
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
+				  get_block_t *get_block)
+{
+	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned to = from + len;
+	struct inode *inode = page->mapping->host;
+	unsigned block_start, block_end;
+	sector_t block;
+	int err = 0;
+	unsigned blocksize = inode->i_sb->s_blocksize;
+	unsigned bbits;
+	struct buffer_head *bh, *head, *wait[2], **wait_bh = wait;
+	bool decrypt = false;
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(from > PAGE_CACHE_SIZE);
+	BUG_ON(to > PAGE_CACHE_SIZE);
+	BUG_ON(from > to);
+
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, blocksize, 0);
+	head = page_buffers(page);
+	bbits = ilog2(blocksize);
+	block = (sector_t)page->index << (PAGE_CACHE_SHIFT - bbits);
+
+	for (bh = head, block_start = 0; bh != head || !block_start;
+	    block++, block_start = block_end, bh = bh->b_this_page) {
+		block_end = block_start + blocksize;
+		if (block_end <= from || block_start >= to) {
+			if (PageUptodate(page)) {
+				if (!buffer_uptodate(bh))
+					set_buffer_uptodate(bh);
+			}
+			continue;
+		}
+		if (buffer_new(bh))
+			clear_buffer_new(bh);
+		if (!buffer_mapped(bh)) {
+			WARN_ON(bh->b_size != blocksize);
+			err = get_block(inode, block, bh, 1);
+			if (err)
+				break;
+			if (buffer_new(bh)) {
+				unmap_underlying_metadata(bh->b_bdev,
+							  bh->b_blocknr);
+				if (PageUptodate(page)) {
+					clear_buffer_new(bh);
+					set_buffer_uptodate(bh);
+					mark_buffer_dirty(bh);
+					continue;
+				}
+				if (block_end > to || block_start < from)
+					zero_user_segments(page, to, block_end,
+							   block_start, from);
+				continue;
+			}
+		}
+		if (PageUptodate(page)) {
+			if (!buffer_uptodate(bh))
+				set_buffer_uptodate(bh);
+			continue;
+		}
+		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
+		    !buffer_unwritten(bh) &&
+		    (block_start < from || block_end > to)) {
+			ll_rw_block(READ, 1, &bh);
+			*wait_bh++ = bh;
+			decrypt = ext4_encrypted_inode(inode) &&
+				S_ISREG(inode->i_mode);
+		}
+	}
+	/*
+	 * If we issued read requests, let them complete.
+	 */
+	while (wait_bh > wait) {
+		wait_on_buffer(*--wait_bh);
+		if (!buffer_uptodate(*wait_bh))
+			err = -EIO;
+	}
+	if (unlikely(err))
+		page_zero_new_buffers(page, from, to);
+	else if (decrypt)
+		err = ext4_decrypt_one(inode, page);
+	return err;
+}
+#endif
+
 static int ext4_write_begin(struct file *file, struct address_space *mapping,
 			    loff_t pos, unsigned len, unsigned flags,
 			    struct page **pagep, void **fsdata)
@@ -933,11 +1023,19 @@ retry_journal:
 	/* In case writeback began while the page was unlocked */
 	wait_for_stable_page(page);
 
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	if (ext4_should_dioread_nolock(inode))
+		ret = ext4_block_write_begin(page, pos, len,
+					     ext4_get_block_write);
+	else
+		ret = ext4_block_write_begin(page, pos, len,
+					     ext4_get_block);
+#else
 	if (ext4_should_dioread_nolock(inode))
 		ret = __block_write_begin(page, pos, len, ext4_get_block_write);
 	else
 		ret = __block_write_begin(page, pos, len, ext4_get_block);
-
+#endif
 	if (!ret && ext4_should_journal_data(inode)) {
 		ret = ext4_walk_page_buffers(handle, page_buffers(page),
 					     from, to, NULL,
@@ -2552,7 +2650,12 @@ retry_journal:
 	/* In case writeback began while the page was unlocked */
 	wait_for_stable_page(page);
 
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	ret = ext4_block_write_begin(page, pos, len,
+				     ext4_da_get_block_prep);
+#else
 	ret = __block_write_begin(page, pos, len, ext4_da_get_block_prep);
+#endif
 	if (ret < 0) {
 		unlock_page(page);
 		ext4_journal_stop(handle);
@@ -3010,6 +3113,9 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		get_block_func = ext4_get_block_write;
 		dio_flags = DIO_LOCKING;
 	}
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
+#endif
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 				   inode->i_sb->s_bdev, iter,
 				   offset,
@@ -3073,6 +3179,11 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode))
+		return 0;
+#endif
+
 	/*
 	 * If we are doing data journalling we don't support O_DIRECT
 	 */
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index b24a254..71fb0e6 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -28,6 +28,7 @@
 #include <linux/ratelimit.h>
 
 #include "ext4_jbd2.h"
+#include "ext4_crypto.h"
 #include "xattr.h"
 #include "acl.h"
 
@@ -69,6 +70,10 @@ static void ext4_finish_bio(struct bio *bio)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+		struct page *data_page = NULL;
+		struct ext4_crypto_ctx *ctx = NULL;
+#endif
 		struct buffer_head *bh, *head;
 		unsigned bio_start = bvec->bv_offset;
 		unsigned bio_end = bio_start + bvec->bv_len;
@@ -78,6 +83,15 @@ static void ext4_finish_bio(struct bio *bio)
 		if (!page)
 			continue;
 
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+		if (!page->mapping) {
+			/* The bounce data pages are unmapped. */
+			data_page = page;
+			ctx = (struct ext4_crypto_ctx *)page_private(data_page);
+			page = ctx->control_page;
+		}
+#endif
+
 		if (error) {
 			SetPageError(page);
 			set_bit(AS_EIO, &page->mapping->flags);
@@ -102,8 +116,13 @@ static void ext4_finish_bio(struct bio *bio)
 		} while ((bh = bh->b_this_page) != head);
 		bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
 		local_irq_restore(flags);
-		if (!under_io)
+		if (!under_io) {
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+			if (ctx)
+				ext4_restore_control_page(data_page);
+#endif
 			end_page_writeback(page);
+		}
 	}
 }
 
@@ -378,6 +397,7 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
 
 static int io_submit_add_bh(struct ext4_io_submit *io,
 			    struct inode *inode,
+			    struct page *page,
 			    struct buffer_head *bh)
 {
 	int ret;
@@ -391,7 +411,7 @@ submit_and_retry:
 		if (ret)
 			return ret;
 	}
-	ret = bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));
+	ret = bio_add_page(io->io_bio, page, bh->b_size, bh_offset(bh));
 	if (ret != bh->b_size)
 		goto submit_and_retry;
 	io->io_next_block++;
@@ -404,6 +424,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 			struct writeback_control *wbc,
 			bool keep_towrite)
 {
+	struct page *data_page = NULL;
 	struct inode *inode = page->mapping->host;
 	unsigned block_start, blocksize;
 	struct buffer_head *bh, *head;
@@ -463,19 +484,29 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 		set_buffer_async_write(bh);
 	} while ((bh = bh->b_this_page) != head);
 
-	/* Now submit buffers to write */
 	bh = head = page_buffers(page);
+
+	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode)) {
+		data_page = ext4_encrypt(inode, page);
+		if (IS_ERR(data_page)) {
+			ret = PTR_ERR(data_page);
+			data_page = NULL;
+			goto out;
+		}
+	}
+
+	/* Now submit buffers to write */
 	do {
 		if (!buffer_async_write(bh))
 			continue;
-		ret = io_submit_add_bh(io, inode, bh);
+		ret = io_submit_add_bh(io, inode,
+				       data_page ? data_page : page, bh);
 		if (ret) {
 			/*
 			 * We only get here on ENOMEM.  Not much else
 			 * we can do but mark the page as dirty, and
 			 * better luck next time.
 			 */
-			redirty_page_for_writepage(wbc, page);
 			break;
 		}
 		nr_submitted++;
@@ -484,6 +515,11 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 
 	/* Error stopped previous loop? Clean up buffers... */
 	if (ret) {
+	out:
+		if (data_page)
+			ext4_restore_control_page(data_page);
+		printk_ratelimited(KERN_ERR "%s: ret = %d\n", __func__, ret);
+		redirty_page_for_writepage(wbc, page);
 		do {
 			clear_buffer_async_write(bh);
 			bh = bh->b_this_page;
-- 
2.3.0

