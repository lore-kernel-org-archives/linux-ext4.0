From: Michael Halcrow <mhalcrow@google.com>
Subject: [PATCH 3/5] ext4: Implements the EXT4 encryption write path
Date: Wed, 23 Jul 2014 14:23:26 -0700
Message-ID: <1406150608-19351-4-git-send-email-mhalcrow@google.com>
References: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
Cc: zohar@linux.vnet.ibm.com, mhalcrow@google.com,
	herbert@gondor.apana.org.au, pavel@ucw.cz, hch@infradead.org,
	lczerner@redhat.com, tytso@mit.edu, tyhicks@canonical.com,
	serge.hallyn@canonical.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Implements the EXT4 encryption write path.

Removes real encryption and just memcpy's the page so that this patch
can be independently tested.

Signed-off-by: Michael Halcrow <mhalcrow@google.com>
---
 fs/ext4/crypto.c  |  24 +++----
 fs/ext4/inode.c   |   5 +-
 fs/ext4/namei.c   |   3 +
 fs/ext4/page-io.c | 182 +++++++++++++++++++++++++++++++++++++++++++-----------
 4 files changed, 164 insertions(+), 50 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 6fbb4fa..3c9e9f4 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -360,20 +360,20 @@ struct page *ext4_encrypt(ext4_crypto_ctx_t *ctx, struct page *plaintext_page)
 	sg_set_page(&src, plaintext_page, PAGE_CACHE_SIZE, 0);
 	ablkcipher_request_set_crypt(req, &src, &dst, PAGE_CACHE_SIZE,
 				     xts_tweak);
-	res = crypto_ablkcipher_encrypt(req);
-	if (res == -EINPROGRESS || res == -EBUSY) {
-		BUG_ON(req->base.data != &ecr);
-		wait_for_completion(&ecr.completion);
-		res = ecr.res;
-		reinit_completion(&ecr.completion);
-	}
 	ablkcipher_request_free(req);
-	if (res) {
-		printk_ratelimited(KERN_ERR "%s: crypto_ablkcipher_encrypt() "
-				   "returned %d\n", __func__, res);
-		ciphertext_page = ERR_PTR(res);
-		goto out;
+/* =======
+ * TODO(mhalcrow): Removed real crypto so intermediate patch
+ * for write path is still fully functional. */
+	{
+		/* TODO(mhalcrow): Temporary for testing */
+		char *ciphertext_virt, *plaintext_virt;
+		ciphertext_virt = kmap(ciphertext_page);
+		plaintext_virt = kmap(plaintext_page);
+		memcpy(ciphertext_virt, plaintext_virt, PAGE_CACHE_SIZE);
+		kunmap(plaintext_page);
+		kunmap(ciphertext_page);
 	}
+/* ======= */
 	SetPageDirty(ciphertext_page);
 	SetPagePrivate(ciphertext_page);
 	ctx->control_page = plaintext_page;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 367a60c..4d37a12 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2314,6 +2314,7 @@ static int ext4_writepages(struct address_space *mapping,
 	handle_t *handle = NULL;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
+	struct ext4_inode_info *ei = EXT4_I(inode);
 	int needed_blocks, rsv_blocks = 0, ret = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 	bool done;
@@ -2330,7 +2331,7 @@ static int ext4_writepages(struct address_space *mapping,
 	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		goto out_writepages;
 
-	if (ext4_should_journal_data(inode)) {
+	if (ext4_should_journal_data(inode) || ei->i_encrypt) {
 		struct blk_plug plug;
 
 		blk_start_plug(&plug);
@@ -2979,6 +2980,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	struct ext4_inode_info *ei = EXT4_I(inode);
 	ssize_t ret;
 	size_t count = iov_iter_count(iter);
 	int overwrite = 0;
@@ -3055,6 +3057,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		get_block_func = ext4_get_block_write;
 		dio_flags = DIO_LOCKING;
 	}
+	BUG_ON(ei->i_encrypt);
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 				   inode->i_sb->s_bdev, iter,
 				   offset,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3520ab8..de5623a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2238,6 +2238,7 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 {
 	handle_t *handle;
 	struct inode *inode;
+	struct ext4_sb_info *sbi = EXT4_SB(dir->i_sb);
 	int err, credits, retries = 0;
 
 	dquot_initialize(dir);
@@ -2253,6 +2254,8 @@ retry:
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
 		ext4_set_aops(inode);
+		if (sbi->s_encrypt)
+			ext4_set_crypto_key(inode);
 		err = ext4_add_nondir(handle, dentry, inode);
 		if (!err && IS_DIRSYNC(dir))
 			ext4_handle_sync(handle);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index b24a254..47e8e90 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -61,6 +61,24 @@ static void buffer_io_error(struct buffer_head *bh)
 			(unsigned long long)bh->b_blocknr);
 }
 
+static void ext4_restore_control_page(struct page *data_page)
+{
+	struct page *control_page = NULL;
+	ext4_crypto_ctx_t *ctx = NULL;
+	BUG_ON(!PagePrivate(data_page));
+	ctx = (ext4_crypto_ctx_t *)page_private(data_page);
+	BUG_ON(!ctx);
+	control_page = ctx->control_page;
+	BUG_ON(!control_page);
+	BUG_ON(!page_buffers(control_page));
+	set_bh_to_page(page_buffers(control_page), control_page);
+	set_page_private(data_page, (unsigned long)NULL);
+	ClearPagePrivate(data_page);
+	BUG_ON(!PageLocked(data_page));
+	unlock_page(data_page);
+	ext4_release_crypto_ctx(ctx);
+}
+
 static void ext4_finish_bio(struct bio *bio)
 {
 	int i;
@@ -69,6 +87,8 @@ static void ext4_finish_bio(struct bio *bio)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
+		struct page *data_page = NULL;
+		ext4_crypto_ctx_t *ctx = NULL;
 		struct buffer_head *bh, *head;
 		unsigned bio_start = bvec->bv_offset;
 		unsigned bio_end = bio_start + bvec->bv_len;
@@ -78,6 +98,21 @@ static void ext4_finish_bio(struct bio *bio)
 		if (!page)
 			continue;
 
+		if (!page->mapping) {
+			/* The bounce data pages are unmapped. */
+			data_page = page;
+			BUG_ON(!PagePrivate(data_page));
+			ctx = (ext4_crypto_ctx_t *)page_private(data_page);
+			BUG_ON(!ctx);
+			page = ctx->control_page;
+			BUG_ON(!page);
+		} else {
+			/* TODO(mhalcrow): Remove this else{} for release */
+			struct inode *inode = page->mapping->host;
+			struct ext4_inode_info *ei = EXT4_I(inode);
+			BUG_ON(ei->i_encrypt);
+		}
+
 		if (error) {
 			SetPageError(page);
 			set_bit(AS_EIO, &page->mapping->flags);
@@ -102,8 +137,11 @@ static void ext4_finish_bio(struct bio *bio)
 		} while ((bh = bh->b_this_page) != head);
 		bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
 		local_irq_restore(flags);
-		if (!under_io)
+		if (!under_io) {
+			if (ctx)
+				ext4_restore_control_page(data_page);
 			end_page_writeback(page);
+		}
 	}
 }
 
@@ -398,40 +436,29 @@ submit_and_retry:
 	return 0;
 }
 
-int ext4_bio_write_page(struct ext4_io_submit *io,
-			struct page *page,
-			int len,
-			struct writeback_control *wbc,
-			bool keep_towrite)
-{
+static void ext4_abort_bio_write(struct page *page,
+				 struct writeback_control *wbc) {
+	struct buffer_head *bh, *head;
+	printk(KERN_ERR "%s: called\n", __func__);
+	redirty_page_for_writepage(wbc, page);
+	bh = head = page_buffers(page);
+	do {
+		clear_buffer_async_write(bh);
+		bh = bh->b_this_page;
+	} while (bh != head);
+}
+
+static int ext4_bio_write_buffers(struct ext4_io_submit *io,
+				  struct page *page,
+				  struct page *data_page,
+				  int len,
+				  struct writeback_control *wbc) {
 	struct inode *inode = page->mapping->host;
-	unsigned block_start, blocksize;
+	unsigned block_start;
 	struct buffer_head *bh, *head;
 	int ret = 0;
 	int nr_submitted = 0;
 
-	blocksize = 1 << inode->i_blkbits;
-
-	BUG_ON(!PageLocked(page));
-	BUG_ON(PageWriteback(page));
-
-	if (keep_towrite)
-		set_page_writeback_keepwrite(page);
-	else
-		set_page_writeback(page);
-	ClearPageError(page);
-
-	/*
-	 * Comments copied from block_write_full_page:
-	 *
-	 * The page straddles i_size.  It must be zeroed out on each and every
-	 * writepage invocation because it may be mmapped.  "A file is mapped
-	 * in multiples of the page size.  For a file that is not a multiple of
-	 * the page size, the remaining memory is zeroed when mapped, and
-	 * writes to that region are not written out to the file."
-	 */
-	if (len < PAGE_CACHE_SIZE)
-		zero_user_segment(page, len, PAGE_CACHE_SIZE);
 	/*
 	 * In the first loop we prepare and mark buffers to submit. We have to
 	 * mark all buffers in the page before submitting so that
@@ -449,7 +476,12 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 		}
 		if (!buffer_dirty(bh) || buffer_delay(bh) ||
 		    !buffer_mapped(bh) || buffer_unwritten(bh)) {
-			/* A hole? We can safely clear the dirty bit */
+			/* A hole? We can safely clear the dirty bit,
+			 * so long as we're not encrypting */
+			if (data_page) {
+				BUG_ON(!buffer_dirty(bh));
+				BUG_ON(!buffer_mapped(bh));
+			}
 			if (!buffer_mapped(bh))
 				clear_buffer_dirty(bh);
 			if (io->io_bio)
@@ -475,7 +507,6 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 			 * we can do but mark the page as dirty, and
 			 * better luck next time.
 			 */
-			redirty_page_for_writepage(wbc, page);
 			break;
 		}
 		nr_submitted++;
@@ -484,14 +515,91 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 
 	/* Error stopped previous loop? Clean up buffers... */
 	if (ret) {
-		do {
-			clear_buffer_async_write(bh);
-			bh = bh->b_this_page;
-		} while (bh != head);
+		printk_ratelimited(KERN_ERR "%s: ret = [%d]\n", __func__, ret);
+		ext4_abort_bio_write(page, wbc);
 	}
 	unlock_page(page);
 	/* Nothing submitted - we have to end page writeback */
-	if (!nr_submitted)
+	if (!nr_submitted) {
+		if (data_page)
+			ext4_restore_control_page(data_page);
 		end_page_writeback(page);
+	}
+	return ret;
+}
+
+static int ext4_bio_encrypt_and_write(struct ext4_io_submit *io,
+				      struct page *control_page,
+				      struct writeback_control *wbc) {
+	struct page *data_page = NULL;
+	ext4_crypto_ctx_t *ctx = NULL;
+	struct inode *inode = control_page->mapping->host;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int res = 0;
+	if (!ei->i_encrypt) {
+		res = ext4_set_crypto_key(inode);
+		if (res)
+			goto fail;
+	}
+	BUG_ON(!ei->i_encrypt);
+	ctx = ext4_get_crypto_ctx(true, ei->i_crypto_key);
+	if (IS_ERR(ctx)) {
+		res = PTR_ERR(ctx);
+		goto fail;
+	}
+	data_page = ext4_encrypt(ctx, control_page);
+	if (IS_ERR(data_page)) {
+		res = PTR_ERR(data_page);
+		printk_ratelimited(KERN_ERR "%s: ext4_encrypt() returned "
+				   "%d\n", __func__, res);
+		goto free_ctx_and_fail;
+	}
+	BUG_ON(PageLocked(data_page));
+	lock_page(data_page);
+	return ext4_bio_write_buffers(io, control_page, data_page,
+				      PAGE_CACHE_SIZE, wbc);
+free_ctx_and_fail:
+	ext4_release_crypto_ctx(ctx);
+fail:
+	ext4_abort_bio_write(control_page, wbc);
+	end_page_writeback(control_page);
+	return res;
+}
+
+int ext4_bio_write_page(struct ext4_io_submit *io,
+			struct page *page,
+			int len,
+			struct writeback_control *wbc,
+			bool keep_towrite)
+{
+	struct ext4_inode_info *ei = EXT4_I(page->mapping->host);
+	int ret = 0;
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(PageWriteback(page));
+	if (keep_towrite)
+		set_page_writeback_keepwrite(page);
+	else
+		set_page_writeback(page);
+	ClearPageError(page);
+
+	/*
+	 * Comments copied from block_write_full_page_endio:
+	 *
+	 * The page straddles i_size.  It must be zeroed out on each and every
+	 * writepage invocation because it may be mmapped.  "A file is mapped
+	 * in multiples of the page size.  For a file that is not a multiple of
+	 * the page size, the remaining memory is zeroed when mapped, and
+	 * writes to that region are not written out to the file."
+	 */
+	if (len < PAGE_CACHE_SIZE)
+		zero_user_segment(page, len, PAGE_CACHE_SIZE);
+
+	if (ei->i_encrypt) {
+		ret = ext4_bio_encrypt_and_write(io, page, wbc);
+	} else {
+		ret = ext4_bio_write_buffers(io, page, NULL, len, wbc);
+	}
+	unlock_page(page);
 	return ret;
 }
-- 
2.0.0.526.g5318336

