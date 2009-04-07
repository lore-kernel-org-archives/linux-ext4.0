From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Date: Tue, 7 Apr 2009 10:16:05 +0200
Message-ID: <20090407081605.GP5178@kernel.dk>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407071729.GN5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:43676 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbZDGIQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2009 04:16:08 -0400
Content-Disposition: inline
In-Reply-To: <20090407071729.GN5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 07 2009, Jens Axboe wrote:
> BTW, with the increased number of sync IO and unplugging, it makes sense
> to soon look into some finer granularity of plugging. If we didn't have
> so many single page submission paths it would not be as big a problem,
> but we do. And since they still persist so many years after we added
> functionality to pass bigger IOs, it likely wont be much better in the
> future either.
> 
> So we can either look into doing per io context plugging, or doing
> something similar to:
> 
> plugctx = blk_get_plug_context();
>         ...
>         submit_bio_plug(rw, bio, plugctx);
>         ...
>         submit_bio_plug(rw, bio, plugctx);
>         ...
> blk_submit_plug_context(plugctx);
> 
> and pass that down through wbc, perhaps. Dunno, just a thought.
> Basically a work-around for not having a dedicated writepages() that
> does the right thing (ext3 anyone?).

Here's a quick mockup. It compiles, but that's about all the usage it
has seen so far :-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 43fdedc..5cf416c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1567,6 +1567,17 @@ void submit_bio(int rw, struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio);
 
+void submit_bio_plug(int rw, struct bio *bio, struct blk_plug_ctx *ctx)
+{
+	if (ctx) {
+		bio->bi_rw |= rw;
+		bio->bi_next = ctx->bio_list;
+		ctx->bio_list = bio;
+	} else
+		submit_bio(rw, bio);
+}
+EXPORT_SYMBOL(submit_bio_plug);
+
 /**
  * blk_rq_check_limits - Helper function to check a request for the queue limit
  * @q:  the queue
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 012f065..e4313e3 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -101,6 +101,8 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
 		INIT_HLIST_HEAD(&ret->cic_list);
 		ret->ioc_data = NULL;
+		ret->plug_ctx.bio_list = NULL;
+		ret->plug_ctx.state = 0;
 	}
 
 	return ret;
@@ -171,6 +173,55 @@ void copy_io_context(struct io_context **pdst, struct io_context **psrc)
 }
 EXPORT_SYMBOL(copy_io_context);
 
+struct blk_plug_ctx *blk_get_plug_context(void)
+{
+	struct io_context *ioc;
+
+	ioc = current_io_context(GFP_ATOMIC, -1);
+	if (!ioc)
+		return NULL;
+
+	if (!test_and_set_bit_lock(0, &ioc->plug_ctx.state))
+		return &ioc->plug_ctx;
+
+	return NULL;
+}
+
+static void __blk_submit_plug_context(struct blk_plug_ctx *ctx)
+{
+	struct block_device *bdev = NULL;
+	struct bio *bio;
+
+	while ((bio = ctx->bio_list) != NULL) {
+		ctx->bio_list = bio->bi_next;
+		bio->bi_next = NULL;
+
+		if (bdev && bdev != bio->bi_bdev)
+			blk_unplug(bdev_get_queue(bdev));
+
+		if (bio_unplug(bio))
+			bdev = bio->bi_bdev;
+
+		bio->bi_flags &= ~(1 << BIO_RW_UNPLUG);
+
+		submit_bio(bio->bi_rw, bio);
+	}
+}
+
+void blk_submit_plug_context(struct blk_plug_ctx *ctx)
+{
+	if (ctx) {
+		__blk_submit_plug_context(ctx);
+		clear_bit_unlock(0, &ctx->state);
+	}
+}
+
+void blk_flush_plug_context(struct blk_plug_ctx *ctx)
+{
+	if (ctx)
+		__blk_submit_plug_context(ctx);
+}
+
 static int __init blk_ioc_init(void)
 {
 	iocontext_cachep = kmem_cache_create("blkdev_ioc",
diff --git a/fs/buffer.c b/fs/buffer.c
index 6e35762..2ed21b8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1698,7 +1698,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(write_op, bh);
+			submit_bh_plug(write_op, bh, wbc->plug);
 			nr_underway++;
 		}
 		bh = next;
@@ -2884,8 +2884,10 @@ static void end_bio_bh_io_sync(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-int submit_bh(int rw, struct buffer_head * bh)
+static int __submit_bh(int rw, struct buffer_head * bh,
+			struct blk_plug_ctx *ctx)
 {
+	gfp_t gfp = ctx ? GFP_ATOMIC : GFP_NOIO;
 	struct bio *bio;
 	int ret = 0;
 
@@ -2910,7 +2912,12 @@ int submit_bh(int rw, struct buffer_head * bh)
 	 * from here on down, it's all bio -- do the initial mapping,
 	 * submit_bio -> generic_make_request may further map this bio around
 	 */
-	bio = bio_alloc(GFP_NOIO, 1);
+	bio = bio_alloc(gfp, 1);
+	if (!bio) {
+		blk_flush_plug_context(ctx);
+		bio_alloc(GFP_NOIO, 1);
+		ctx = NULL;
+	}
 
 	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
@@ -2926,7 +2933,8 @@ int submit_bh(int rw, struct buffer_head * bh)
 	bio->bi_private = bh;
 
 	bio_get(bio);
-	submit_bio(rw, bio);
+
+	submit_bio_plug(rw, bio, ctx);
 
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
@@ -2935,6 +2943,16 @@ int submit_bh(int rw, struct buffer_head * bh)
 	return ret;
 }
 
+int submit_bh(int rw, struct buffer_head *bh)
+{
+	return __submit_bh(rw, bh, NULL);
+}
+
+int submit_bh_plug(int rw, struct buffer_head *bh, struct blk_plug_ctx *ctx)
+{
+	return __submit_bh(rw, bh, ctx);
+}
+
 /**
  * ll_rw_block: low-level access to block devices (DEPRECATED)
  * @rw: whether to %READ or %WRITE or %SWRITE or maybe %READA (readahead)
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 7b73bb8..a8eec18 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -183,6 +183,7 @@ void __lock_buffer(struct buffer_head *bh);
 void ll_rw_block(int, int, struct buffer_head * bh[]);
 int sync_dirty_buffer(struct buffer_head *bh);
 int submit_bh(int, struct buffer_head *);
+int submit_bh_plug(int, struct buffer_head *, struct blk_plug_ctx *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bce40a2..8a0c4b5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2117,7 +2117,9 @@ extern void file_move(struct file *f, struct list_head *list);
 extern void file_kill(struct file *f);
 #ifdef CONFIG_BLOCK
 struct bio;
+struct blk_plug_ctx;
 extern void submit_bio(int, struct bio *);
+extern void submit_bio_plug(int, struct bio *, struct blk_plug_ctx *);
 extern int bdev_read_only(struct block_device *);
 #endif
 extern int set_blocksize(struct block_device *, int);
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 08b987b..38c8a2c 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -3,6 +3,7 @@
 
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/list.h>
 
 /*
  * This is the per-process anticipatory I/O scheduler state.
@@ -59,6 +60,11 @@ struct cfq_io_context {
 	struct rcu_head rcu_head;
 };
 
+struct blk_plug_ctx {
+	struct bio *bio_list;
+	unsigned long state;
+};
+
 /*
  * I/O subsystem state of the associated processes.  It is refcounted
  * and kmalloc'ed. These could be shared between processes.
@@ -83,6 +89,8 @@ struct io_context {
 	struct radix_tree_root radix_root;
 	struct hlist_head cic_list;
 	void *ioc_data;
+
+	struct blk_plug_ctx plug_ctx;
 };
 
 static inline struct io_context *ioc_task_link(struct io_context *ioc)
@@ -105,7 +113,17 @@ void exit_io_context(void);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
 void copy_io_context(struct io_context **pdst, struct io_context **psrc);
+struct blk_plug_ctx *blk_get_plug_context(void);
+void blk_submit_plug_context(struct blk_plug_ctx *);
+void blk_flush_plug_context(struct blk_plug_ctx *);
 #else
+static inline void blk_submit_plug_context(struct blk_plug_ctx *ctx)
+{
+}
+static inline struct blk_plug_ctx *blk_get_plug_context(void)
+{
+	return NULL;
+}
 static inline void exit_io_context(void)
 {
 }
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 9344547..8b5c14a 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -6,6 +6,7 @@
 
 #include <linux/sched.h>
 #include <linux/fs.h>
+#include <linux/iocontext.h>
 
 struct backing_dev_info;
 
@@ -40,6 +41,7 @@ enum writeback_sync_modes {
 struct writeback_control {
 	struct backing_dev_info *bdi;	/* If !NULL, only write back this
 					   queue */
+	struct blk_plug_ctx *plug;
 	enum writeback_sync_modes sync_mode;
 	unsigned long *older_than_this;	/* If !NULL, only write back inodes
 					   older than this */
diff --git a/mm/filemap.c b/mm/filemap.c
index 2e2d38e..d521830 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -218,7 +218,9 @@ int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 	if (!mapping_cap_writeback_dirty(mapping))
 		return 0;
 
+	wbc.plug = blk_get_plug_context();
 	ret = do_writepages(mapping, &wbc);
+	blk_submit_plug_context(wbc.plug);
 	return ret;
 }
 

-- 
Jens Axboe

