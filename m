Return-Path: <SRS0=o0xn=S6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D29DC4321A
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 04:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F984206A3
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 04:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfD1Ec1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Apr 2019 00:32:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726519AbfD1Ec1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 28 Apr 2019 00:32:27 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3S4TYih105901
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2019 00:32:25 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s54cf97j1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2019 00:32:24 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 28 Apr 2019 05:32:23 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 28 Apr 2019 05:32:18 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3S4V2w734210006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Apr 2019 04:31:03 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF51A112061;
        Sun, 28 Apr 2019 04:31:02 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FE80112063;
        Sun, 28 Apr 2019 04:30:59 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.75.21])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 28 Apr 2019 04:30:58 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com, hch@infradead.org
Subject: [PATCH V2 07/13] Add decryption support for sub-pagesized blocks
Date:   Sun, 28 Apr 2019 10:01:15 +0530
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190428043121.30925-1-chandan@linux.ibm.com>
References: <20190428043121.30925-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042804-0052-0000-0000-000003B41092
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011008; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01195431; UDB=6.00626836; IPR=6.00976274;
 MB=3.00026628; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-28 04:32:21
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042804-0053-0000-0000-000060ABB270
Message-Id: <20190428043121.30925-8-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-28_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904280030
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

To support decryption of sub-pagesized blocks this commit adds code to,
1. Track buffer head in "struct read_callbacks_ctx".
2. Pass buffer head argument to all read callbacks.
3. In the corresponding endio, loop across all the blocks mapped by the
   page, decrypting each block in turn.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 fs/buffer.c                    | 83 +++++++++++++++++++++++++---------
 fs/crypto/bio.c                | 50 +++++++++++++-------
 fs/crypto/crypto.c             | 19 +++++++-
 fs/f2fs/data.c                 |  2 +-
 fs/mpage.c                     |  2 +-
 fs/read_callbacks.c            | 53 ++++++++++++++--------
 include/linux/buffer_head.h    |  1 +
 include/linux/read_callbacks.h |  5 +-
 8 files changed, 154 insertions(+), 61 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ce357602f471..f324727e24bb 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -45,6 +45,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/pagevec.h>
 #include <linux/sched/mm.h>
+#include <linux/read_callbacks.h>
 #include <trace/events/block.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
@@ -245,11 +246,7 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 	return ret;
 }
 
-/*
- * I/O completion handler for block_read_full_page() - pages
- * which come unlocked at the end of I/O.
- */
-static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
+void end_buffer_page_read(struct buffer_head *bh)
 {
 	unsigned long flags;
 	struct buffer_head *first;
@@ -257,17 +254,7 @@ static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
 	struct page *page;
 	int page_uptodate = 1;
 
-	BUG_ON(!buffer_async_read(bh));
-
 	page = bh->b_page;
-	if (uptodate) {
-		set_buffer_uptodate(bh);
-	} else {
-		clear_buffer_uptodate(bh);
-		buffer_io_error(bh, ", async page read");
-		SetPageError(page);
-	}
-
 	/*
 	 * Be _very_ careful from here on. Bad things can happen if
 	 * two buffer heads end IO at almost the same time and both
@@ -305,6 +292,44 @@ static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
 	local_irq_restore(flags);
 	return;
 }
+EXPORT_SYMBOL(end_buffer_page_read);
+
+/*
+ * I/O completion handler for block_read_full_page() - pages
+ * which come unlocked at the end of I/O.
+ */
+static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
+{
+	struct page *page;
+
+	BUG_ON(!buffer_async_read(bh));
+
+#if defined(CONFIG_FS_ENCRYPTION) || defined(CONFIG_FS_VERITY)
+	if (uptodate && bh->b_private) {
+		struct read_callbacks_ctx *ctx = bh->b_private;
+
+		read_callbacks(ctx);
+		return;
+	}
+
+	if (bh->b_private) {
+		struct read_callbacks_ctx *ctx = bh->b_private;
+
+		WARN_ON(uptodate);
+		put_read_callbacks_ctx(ctx);
+	}
+#endif
+	page = bh->b_page;
+	if (uptodate) {
+		set_buffer_uptodate(bh);
+	} else {
+		clear_buffer_uptodate(bh);
+		buffer_io_error(bh, ", async page read");
+		SetPageError(page);
+	}
+
+	end_buffer_page_read(bh);
+}
 
 /*
  * Completion handler for block_write_full_page() - pages which are unlocked
@@ -2220,7 +2245,11 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 {
 	struct inode *inode = page->mapping->host;
 	sector_t iblock, lblock;
-	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
+	struct buffer_head *bh, *head;
+	struct {
+		sector_t blk_nr;
+		struct buffer_head *bh;
+	} arr[MAX_BUF_PER_PAGE];
 	unsigned int blocksize, bbits;
 	int nr, i;
 	int fully_mapped = 1;
@@ -2262,7 +2291,9 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 			if (buffer_uptodate(bh))
 				continue;
 		}
-		arr[nr++] = bh;
+		arr[nr].blk_nr = iblock;
+		arr[nr].bh = bh;
+		++nr;
 	} while (i++, iblock++, (bh = bh->b_this_page) != head);
 
 	if (fully_mapped)
@@ -2281,7 +2312,7 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 
 	/* Stage two: lock the buffers */
 	for (i = 0; i < nr; i++) {
-		bh = arr[i];
+		bh = arr[i].bh;
 		lock_buffer(bh);
 		mark_buffer_async_read(bh);
 	}
@@ -2292,11 +2323,21 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 	 * the underlying blockdev brought it uptodate (the sct fix).
 	 */
 	for (i = 0; i < nr; i++) {
-		bh = arr[i];
-		if (buffer_uptodate(bh))
+		bh = arr[i].bh;
+		if (buffer_uptodate(bh)) {
 			end_buffer_async_read(bh, 1);
-		else
+		} else {
+#if defined(CONFIG_FS_ENCRYPTION) || defined(CONFIG_FS_VERITY)
+			struct read_callbacks_ctx *ctx;
+
+			ctx = get_read_callbacks_ctx(inode, NULL, bh, arr[i].blk_nr);
+			if (WARN_ON(IS_ERR(ctx))) {
+				end_buffer_async_read(bh, 0);
+				continue;
+			}
+#endif
 			submit_bh(REQ_OP_READ, 0, bh);
+		}
 	}
 	return 0;
 }
diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 27f5618174f2..856f4694902d 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -24,44 +24,62 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/namei.h>
+#include <linux/buffer_head.h>
 #include <linux/read_callbacks.h>
 
 #include "fscrypt_private.h"
 
-static void __fscrypt_decrypt_bio(struct bio *bio, bool done)
+static void fscrypt_decrypt(struct bio *bio, struct buffer_head *bh)
 {
+	struct inode *inode;
+	struct page *page;
 	struct bio_vec *bv;
+	sector_t blk_nr;
+	int ret;
 	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bv, bio, i, iter_all) {
-		struct page *page = bv->bv_page;
-		int ret = fscrypt_decrypt_page(page->mapping->host, page,
-				PAGE_SIZE, 0, page->index);
+	WARN_ON(!bh && !bio);
 
+	if (bh) {
+		page = bh->b_page;
+		inode = page->mapping->host;
+
+		blk_nr = page->index << (PAGE_SHIFT - inode->i_blkbits);
+		blk_nr += (bh_offset(bh) >> inode->i_blkbits);
+
+		ret = fscrypt_decrypt_page(inode, page, i_blocksize(inode),
+					bh_offset(bh), blk_nr);
 		if (ret) {
 			WARN_ON_ONCE(1);
 			SetPageError(page);
-		} else if (done) {
-			SetPageUptodate(page);
 		}
-		if (done)
-			unlock_page(page);
+	} else if (bio) {
+		bio_for_each_segment_all(bv, bio, i, iter_all) {
+			unsigned int blkbits;
+
+			page = bv->bv_page;
+			inode = page->mapping->host;
+			blkbits = inode->i_blkbits;
+			blk_nr = page->index << (PAGE_SHIFT - blkbits);
+			blk_nr += (bv->bv_offset >> blkbits);
+			ret = fscrypt_decrypt_page(page->mapping->host,
+						page, bv->bv_len,
+						bv->bv_offset, blk_nr);
+			if (ret) {
+				WARN_ON_ONCE(1);
+				SetPageError(page);
+			}
+		}
 	}
 }
 
-void fscrypt_decrypt_bio(struct bio *bio)
-{
-	__fscrypt_decrypt_bio(bio, false);
-}
-EXPORT_SYMBOL(fscrypt_decrypt_bio);
-
 void fscrypt_decrypt_work(struct work_struct *work)
 {
 	struct read_callbacks_ctx *ctx =
 		container_of(work, struct read_callbacks_ctx, work);
 
-	fscrypt_decrypt_bio(ctx->bio);
+	fscrypt_decrypt(ctx->bio, ctx->bh);
 
 	read_callbacks(ctx);
 }
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index ffa9302a7351..4f0d832cae71 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -305,11 +305,26 @@ EXPORT_SYMBOL(fscrypt_encrypt_page);
 int fscrypt_decrypt_page(const struct inode *inode, struct page *page,
 			unsigned int len, unsigned int offs, u64 lblk_num)
 {
+	int i, page_nr_blks;
+	int err = 0;
+
 	if (!(inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES))
 		BUG_ON(!PageLocked(page));
 
-	return fscrypt_do_page_crypto(inode, FS_DECRYPT, lblk_num, page, page,
-				      len, offs, GFP_NOFS);
+	page_nr_blks = len >> inode->i_blkbits;
+
+	for (i = 0; i < page_nr_blks; i++) {
+		err = fscrypt_do_page_crypto(inode, FS_DECRYPT, lblk_num,
+					page, page, i_blocksize(inode), offs,
+					GFP_NOFS);
+		if (err)
+			break;
+
+		++lblk_num;
+		offs += i_blocksize(inode);
+	}
+
+	return err;
 }
 EXPORT_SYMBOL(fscrypt_decrypt_page);
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 05430d3650ab..ba437a2085e7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -527,7 +527,7 @@ static struct bio *f2fs_grab_read_bio(struct inode *inode, block_t blkaddr,
 	bio_set_op_attrs(bio, REQ_OP_READ, op_flag);
 
 #if defined(CONFIG_FS_ENCRYPTION) || defined(CONFIG_FS_VERITY)
-	ctx = get_read_callbacks_ctx(inode, bio, first_idx);
+	ctx = get_read_callbacks_ctx(inode, bio, NULL, first_idx);
 	if (IS_ERR(ctx)) {
 		bio_put(bio);
 		return (struct bio *)ctx;
diff --git a/fs/mpage.c b/fs/mpage.c
index e342b859ee44..0557479fdca4 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -348,7 +348,7 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 			goto confused;
 
 #if defined(CONFIG_FS_ENCRYPTION) || defined(CONFIG_FS_VERITY)
-		ctx = get_read_callbacks_ctx(inode, args->bio, page->index);
+		ctx = get_read_callbacks_ctx(inode, args->bio, NULL, page->index);
 		if (IS_ERR(ctx)) {
 			bio_put(args->bio);
 			args->bio = NULL;
diff --git a/fs/read_callbacks.c b/fs/read_callbacks.c
index 6dea54b0baa9..b3881c525720 100644
--- a/fs/read_callbacks.c
+++ b/fs/read_callbacks.c
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/bio.h>
+#include <linux/buffer_head.h>
 #include <linux/fscrypt.h>
 #include <linux/fsverity.h>
 #include <linux/read_callbacks.h>
@@ -24,26 +25,41 @@ enum read_callbacks_step {
 	STEP_VERITY,
 };
 
-void end_read_callbacks(struct bio *bio)
+void end_read_callbacks(struct bio *bio, struct buffer_head *bh)
 {
+	struct read_callbacks_ctx *ctx;
 	struct page *page;
 	struct bio_vec *bv;
 	int i;
 	struct bvec_iter_all iter_all;
 
-	bio_for_each_segment_all(bv, bio, i, iter_all) {
-		page = bv->bv_page;
+	if (bh) {
+		if (!PageError(bh->b_page))
+			set_buffer_uptodate(bh);
 
-		BUG_ON(bio->bi_status);
+		ctx = bh->b_private;
 
-		if (!PageError(page))
-			SetPageUptodate(page);
+		end_buffer_page_read(bh);
 
-		unlock_page(page);
+		put_read_callbacks_ctx(ctx);
+	} else if (bio) {
+		bio_for_each_segment_all(bv, bio, i, iter_all) {
+			page = bv->bv_page;
+
+			WARN_ON(bio->bi_status);
+
+			if (!PageError(page))
+				SetPageUptodate(page);
+
+			unlock_page(page);
+		}
+		WARN_ON(!bio->bi_private);
+
+		ctx = bio->bi_private;
+		put_read_callbacks_ctx(ctx);
+
+		bio_put(bio);
 	}
-	if (bio->bi_private)
-		put_read_callbacks_ctx(bio->bi_private);
-	bio_put(bio);
 }
 EXPORT_SYMBOL(end_read_callbacks);
 
@@ -70,18 +86,21 @@ void read_callbacks(struct read_callbacks_ctx *ctx)
 		ctx->cur_step++;
 		/* fall-through */
 	default:
-		end_read_callbacks(ctx->bio);
+		end_read_callbacks(ctx->bio, ctx->bh);
 	}
 }
 EXPORT_SYMBOL(read_callbacks);
 
 struct read_callbacks_ctx *get_read_callbacks_ctx(struct inode *inode,
 						struct bio *bio,
+						struct buffer_head *bh,
 						pgoff_t index)
 {
 	unsigned int read_callbacks_steps = 0;
 	struct read_callbacks_ctx *ctx = NULL;
 
+	WARN_ON(!bh && !bio);
+
 	if (IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode))
 		read_callbacks_steps |= 1 << STEP_DECRYPT;
 #ifdef CONFIG_FS_VERITY
@@ -95,11 +114,15 @@ struct read_callbacks_ctx *get_read_callbacks_ctx(struct inode *inode,
 		ctx = mempool_alloc(read_callbacks_ctx_pool, GFP_NOFS);
 		if (!ctx)
 			return ERR_PTR(-ENOMEM);
+		ctx->bh = bh;
 		ctx->bio = bio;
 		ctx->inode = inode;
 		ctx->enabled_steps = read_callbacks_steps;
 		ctx->cur_step = STEP_INITIAL;
-		bio->bi_private = ctx;
+		if (bio)
+			bio->bi_private = ctx;
+		else if (bh)
+			bh->b_private = ctx;
 	}
 	return ctx;
 }
@@ -111,12 +134,6 @@ void put_read_callbacks_ctx(struct read_callbacks_ctx *ctx)
 }
 EXPORT_SYMBOL(put_read_callbacks_ctx);
 
-bool read_callbacks_required(struct bio *bio)
-{
-	return bio->bi_private && !bio->bi_status;
-}
-EXPORT_SYMBOL(read_callbacks_required);
-
 static int __init init_read_callbacks(void)
 {
 	read_callbacks_ctx_cache = KMEM_CACHE(read_callbacks_ctx, 0);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 7b73ef7f902d..782ed6350dfc 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -165,6 +165,7 @@ void create_empty_buffers(struct page *, unsigned long,
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_async_write(struct buffer_head *bh, int uptodate);
+void end_buffer_page_read(struct buffer_head *bh);
 
 /* Things to do with buffers at mapping->private_list */
 void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode);
diff --git a/include/linux/read_callbacks.h b/include/linux/read_callbacks.h
index c501cdf83a5b..ae32dc4efa6d 100644
--- a/include/linux/read_callbacks.h
+++ b/include/linux/read_callbacks.h
@@ -3,6 +3,7 @@
 #define _READ_CALLBACKS_H
 
 struct read_callbacks_ctx {
+	struct buffer_head *bh;
 	struct bio *bio;
 	struct inode *inode;
 	struct work_struct work;
@@ -10,12 +11,12 @@ struct read_callbacks_ctx {
 	unsigned int enabled_steps;
 };
 
-void end_read_callbacks(struct bio *bio);
+void end_read_callbacks(struct bio *bio, struct buffer_head *bh);
 void read_callbacks(struct read_callbacks_ctx *ctx);
 struct read_callbacks_ctx *get_read_callbacks_ctx(struct inode *inode,
 						struct bio *bio,
+						struct buffer_head *bh,
 						pgoff_t index);
 void put_read_callbacks_ctx(struct read_callbacks_ctx *ctx);
-bool read_callbacks_required(struct bio *bio);
 
 #endif	/* _READ_CALLBACKS_H */
-- 
2.19.1

