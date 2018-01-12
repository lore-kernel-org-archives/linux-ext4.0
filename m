From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH 7/8] ext4: decrypt blocks whose size is less than page size
Date: Fri, 12 Jan 2018 19:41:28 +0530
Message-ID: <20180112141129.27507-8-chandan@linux.vnet.ibm.com>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933997AbeALOKv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Jan 2018 09:10:51 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0CEAJB5126502
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:50 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2fewbqmqhk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:49 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 12 Jan 2018 07:10:48 -0700
In-Reply-To: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds code to decrypt all file blocks mapped by page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/crypto/bio.c                 |   6 +-
 fs/ext4/readpage.c              | 267 +++++++++++++++++++++++++++++++++++++++-
 include/linux/fscrypt.h         |   1 +
 include/linux/fscrypt_notsupp.h |   4 +-
 include/linux/fscrypt_supp.h    |   3 +-
 5 files changed, 274 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index eb6e06a..2744e55 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -70,9 +70,11 @@ static void completion_pages(struct work_struct *work)
 	bio_put(bio);
 }
 
-void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *ctx, struct bio *bio)
+void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *ctx, struct bio *bio,
+			void (*process_bio)(struct work_struct *))
 {
-	INIT_WORK(&ctx->r.work, completion_pages);
+	INIT_WORK(&ctx->r.work,
+		process_bio ? process_bio : completion_pages);
 	ctx->r.bio = bio;
 	queue_work(fscrypt_read_workqueue, &ctx->r.work);
 }
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 0be590b..e494e2d 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -62,6 +62,143 @@ static inline bool ext4_bio_encrypted(struct bio *bio)
 #endif
 }
 
+static void ext4_complete_block(struct work_struct *work)
+{
+	struct fscrypt_ctx *ctx =
+		container_of(work, struct fscrypt_ctx, r.work);
+	struct buffer_head *first, *bh, *tmp;
+	struct bio *bio;
+	struct bio_vec *bv;
+	struct page *page;
+	struct inode *inode;
+	u64 blk_nr;
+	unsigned long flags;
+	int page_uptodate = 1;
+	int ret;
+
+	bio = ctx->r.bio;
+	BUG_ON(bio->bi_vcnt != 1);
+
+	bv = bio->bi_io_vec;
+	page = bv->bv_page;
+	inode = page->mapping->host;
+
+	BUG_ON(bv->bv_len != i_blocksize(inode));
+
+	blk_nr = page->index << (PAGE_SHIFT - inode->i_blkbits);
+	blk_nr += bv->bv_offset >> inode->i_blkbits;
+
+	bh = ctx->r.bh;
+
+	ret = fscrypt_decrypt_page(inode, page, bv->bv_len,
+				bv->bv_offset, blk_nr);
+	if (ret) {
+		WARN_ON_ONCE(1);
+		SetPageError(page);
+	} else {
+		set_buffer_uptodate(bh);
+	}
+
+	fscrypt_release_ctx(ctx);
+	bio_put(bio);
+
+	first = page_buffers(page);
+	local_irq_save(flags);
+	bit_spin_lock(BH_Uptodate_Lock, &first->b_state);
+
+	clear_buffer_async_read(bh);
+	unlock_buffer(bh);
+	tmp = bh;
+	do {
+		if (!buffer_uptodate(tmp))
+			page_uptodate = 0;
+		if (buffer_async_read(tmp)) {
+			BUG_ON(!buffer_locked(tmp));
+			goto still_busy;
+		}
+		tmp = tmp->b_this_page;
+	} while (tmp != bh);
+
+	bit_spin_unlock(BH_Uptodate_Lock, &first->b_state);
+	local_irq_restore(flags);
+
+	if (page_uptodate && !PageError(page))
+		SetPageUptodate(page);
+	unlock_page(page);
+	return;
+
+still_busy:
+	bit_spin_unlock(BH_Uptodate_Lock, &first->b_state);
+	local_irq_restore(flags);
+	return;
+}
+
+static void block_end_io(struct bio *bio)
+{
+	struct buffer_head *bh;
+	struct buffer_head *first;
+	struct buffer_head *tmp;
+	unsigned long flags;
+	struct page *page;
+	int page_uptodate = 1;
+
+	if (ext4_bio_encrypted(bio)) {
+		struct fscrypt_ctx *ctx = bio->bi_private;
+		bh = ctx->r.bh;
+		if (bio->bi_status) {
+			fscrypt_release_ctx(ctx);
+		} else {
+			fscrypt_decrypt_bio_pages(ctx, bio,
+						ext4_complete_block);
+			return;
+		}
+	} else {
+		bh = bio->bi_private;
+	}
+
+	page = bh->b_page;
+
+	if (!bio->bi_status) {
+		set_buffer_uptodate(bh);
+	} else {
+		clear_buffer_uptodate(bh);
+		/* chandan: buffer_io_error(bh); */
+		SetPageError(page);
+	}
+
+	first = page_buffers(page);
+	local_irq_save(flags);
+	bit_spin_lock(BH_Uptodate_Lock, &first->b_state);
+	clear_buffer_async_read(bh);
+	unlock_buffer(bh);
+	tmp = bh;
+	do {
+		if (!buffer_uptodate(tmp))
+			page_uptodate = 0;
+		if (buffer_async_read(tmp)) {
+			BUG_ON(!buffer_locked(tmp));
+			goto still_busy;
+		}
+		tmp = tmp->b_this_page;
+	} while (tmp != bh);
+	bit_spin_unlock(BH_Uptodate_Lock, &first->b_state);
+	local_irq_restore(flags);
+
+	/*
+	 * If none of the buffers had errors and they are all
+	 * uptodate then we can set the page uptodate.
+	 */
+	if (page_uptodate && !PageError(page))
+		SetPageUptodate(page);
+	unlock_page(page);
+	return;
+
+still_busy:
+	bit_spin_unlock(BH_Uptodate_Lock, &first->b_state);
+	local_irq_restore(flags);
+	return;
+}
+
 /*
  * I/O completion handler for multipage BIOs.
  *
@@ -83,7 +220,7 @@ static void mpage_end_io(struct bio *bio)
 		if (bio->bi_status) {
 			fscrypt_release_ctx(bio->bi_private);
 		} else {
-			fscrypt_decrypt_bio_pages(bio->bi_private, bio);
+			fscrypt_decrypt_bio_pages(bio->bi_private, bio, NULL);
 			return;
 		}
 	}
@@ -102,6 +239,132 @@ static void mpage_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
+int ext4_block_read_full_page(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct fscrypt_ctx *ctx;
+	struct bio *bio;
+	sector_t iblock, lblock;
+	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
+	unsigned int blocksize, bbits;
+	int nr, i;
+	int fully_mapped = 1;
+	int ret;
+
+	head = create_page_buffers(page, inode, 0);
+	blocksize = head->b_size;
+	bbits = block_size_bits(blocksize);
+
+	iblock = (sector_t)page->index << (PAGE_SHIFT - bbits);
+	lblock = (i_size_read(inode)+blocksize-1) >> bbits;
+	bh = head;
+	nr = 0;
+	i = 0;
+
+	do {
+		if (buffer_uptodate(bh))
+			continue;
+
+		if (!buffer_mapped(bh)) {
+			int err = 0;
+
+			fully_mapped = 0;
+			if (iblock < lblock) {
+				WARN_ON(bh->b_size != blocksize);
+				err = ext4_get_block(inode, iblock, bh, 0);
+				if (err)
+					SetPageError(page);
+			}
+			if (!buffer_mapped(bh)) {
+				zero_user(page, i << bbits, blocksize);
+				if (!err)
+					set_buffer_uptodate(bh);
+				continue;
+			}
+			/*
+			 * get_block() might have updated the buffer
+			 * synchronously
+			 */
+			if (buffer_uptodate(bh))
+				continue;
+		}
+		arr[nr++] = bh;
+	} while (i++, iblock++, (bh = bh->b_this_page) != head);
+
+	if (fully_mapped)
+		SetPageMappedToDisk(page);
+
+	if (!nr) {
+		/*
+		 * All buffers are uptodate - we can set the page uptodate
+		 * as well. But not if ext4_get_block() returned an error.
+		 */
+		if (!PageError(page))
+			SetPageUptodate(page);
+		unlock_page(page);
+		return 0;
+	}
+
+	/* Stage two: lock the buffers */
+	for (i = 0; i < nr; i++) {
+		bh = arr[i];
+		lock_buffer(bh);
+		set_buffer_async_read(bh);
+	}
+
+	/*
+	 * Stage 3: start the IO.  Check for uptodateness
+	 * inside the buffer lock in case another process reading
+	 * the underlying blockdev brought it uptodate (the sct fix).
+	 */
+	for (i = 0; i < nr; i++) {
+		ctx = NULL;
+		bh = arr[i];
+
+		if (buffer_uptodate(bh)) {
+			end_buffer_async_read(bh, 1);
+			continue;
+		}
+
+		if (ext4_encrypted_inode(inode)
+			&& S_ISREG(inode->i_mode)) {
+			ctx = fscrypt_get_ctx(inode, GFP_NOFS);
+			if (IS_ERR(ctx)) {
+			set_page_error:
+				SetPageError(page);
+				zero_user_segment(page, bh_offset(bh), blocksize);
+				continue;
+			}
+			ctx->r.bh = bh;
+		}
+
+		bio = bio_alloc(GFP_KERNEL, 1);
+		if (!bio) {
+			if (ctx)
+				fscrypt_release_ctx(ctx);
+			goto set_page_error;
+		}
+
+		bio->bi_iter.bi_sector = bh->b_blocknr * (blocksize >> 9);
+		bio_set_dev(bio, bh->b_bdev);
+		bio->bi_write_hint = 0;
+
+		ret = bio_add_page(bio, bh->b_page, blocksize, bh_offset(bh));
+		BUG_ON(bio->bi_iter.bi_size != blocksize);
+
+		bio->bi_end_io = block_end_io;
+		if (ctx)
+			bio->bi_private = ctx;
+		else
+			bio->bi_private = bh;
+		bio_set_op_attrs(bio, REQ_OP_READ, 0);
+
+		submit_bio(bio);
+	}
+
+	return 0;
+}
+
 int ext4_mpage_readpages(struct address_space *mapping,
 			 struct list_head *pages, struct page *page,
 			 unsigned nr_pages)
@@ -286,7 +549,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			bio = NULL;
 		}
 		if (!PageUptodate(page))
-			block_read_full_page(page, ext4_get_block);
+			ext4_block_read_full_page(page);
 		else
 			unlock_page(page);
 	next_page:
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 08b4b40..98c51eb 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -34,6 +34,7 @@ struct fscrypt_ctx {
 		} w;
 		struct {
 			struct bio *bio;
+			struct buffer_head *bh;
 			struct work_struct work;
 		} r;
 		struct list_head free_list;	/* Free list */
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index 019ddce..7da0692 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -164,8 +164,8 @@ static inline bool fscrypt_match_name(const struct fscrypt_name *fname,
 }
 
 /* bio.c */
-static inline void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *ctx,
-					     struct bio *bio)
+static inline void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *ctx, struct bio *bio,
+			void (* process_bio)(struct work_struct *))
 {
 	return;
 }
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index 983d06f..1d4e8ae 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -144,7 +144,8 @@ static inline bool fscrypt_match_name(const struct fscrypt_name *fname,
 }
 
 /* bio.c */
-extern void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *, struct bio *);
+extern void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *ctx, struct bio *bio,
+				void (* process_bio)(struct work_struct *));
 extern void fscrypt_pullback_bio_page(struct page **, bool);
 extern int fscrypt_zeroout_range(const struct inode *, pgoff_t, sector_t,
 				 unsigned int);
-- 
2.9.5
