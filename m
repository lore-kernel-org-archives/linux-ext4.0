From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 1/8] ext4 crypto: fix memory leaks in
 ext4_encrypted_zeroout
Date: Mon, 1 Jun 2015 14:56:58 -0700
Message-ID: <20150601215658.GA28650@jaegeuk-mac02.mot.com>
References: <1432856867-5710-1-git-send-email-tytso@mit.edu>
 <20150529180834.GA22657@jaegeuk-mac02>
 <20150531142601.GA11642@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43455 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbbFAV5E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jun 2015 17:57:04 -0400
Content-Disposition: inline
In-Reply-To: <20150531142601.GA11642@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 31, 2015 at 10:26:01AM -0400, Theodore Ts'o wrote:
> On Fri, May 29, 2015 at 11:08:34AM -0700, Jaegeuk Kim wrote:
> > Not sure why __GFP_WAIT is defined here.
> > Even GFP_NOFS has __GFP_WAIT.
> > 
> > #define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
> > 
> > IMO, __GFP_NOFAIL should be used here?
> > Otherwise, we seem to handle ENOMEM instead.
> 
> You're right, thanks for pointing that out.  I've since changed the
> patch so that we just return ENOMEM, and then made sure that we could
> correctly handle ENOMEM.
> 
> 
> On a different front, I've been thinking more about your proposal to
> swap alloc_pages() and mempool_alloc(), since you were apparently
> seeing OOM killers with a sufficiently aggressive fio workload on a
> memory constrained device.
> 
> I took a closer look at how mempool_alloc() works, and in fact it will
> try alloc_pages() first; but with GFP flags which causes it to not try
> very hard.  (__GFP_NOMEMALLOC, __GFP_NORETRY, __GFP_NOWARN,
> !__GFP_WAIT, !__GFP_IO).
> 
> If this fails, it tries to use the memory pool, and then assuming the
> original request includes __GFP_WAIT, it will retry the alloc_pages()
> using the original gfp mask, if this *still* fails, it will wait for a
> page to be released to the mempool.  As a result, mempool_alloc() will
> never fail when called with __GFP_WAIT, which means my original
> concerns over mempool_alloc() failing were misplaced.

Thank you for pointing out this.
Indeed, mempool_alloc never fails if __GFP_WAIT is set.

> 
> This has lead me to the following thoughts/conclusions:
> 
> 1) We can just drop the alloc_page() call from alloc_bounce_page(),
> since mempool_alloc() will call alloc_page() first.  This also allows
> us to remove all of the complexity relating to the
> EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL flag.

Agreed.

So, once I tested a couple of flags given to the origial alloc_page(), it turns
out that my OOM killer issue was occurred due to __GFP_WAIT.
When I tested the original allo_page() with GFP_NOWAIT, the issue was gone.

> 
> 2) Since mempool_alloc() will end up calling alloc_pages() --- and in
> fact will try to alloc_pages() *twice* --- once with a "don't try
> hard", and then a second time the way we would have alwyas called it
> --- in practice this won't reduce the number of calls to allocate and
> free pages assuming that there is enough memory in the system.

Right, the call count of alloc/free_pages was not the actual issue here.

> 
> 3) I don't think increasing num_prealloc_crypto_pages() to BIO_MAX is
> the best idea; (a) it sequesters a large amount of memory, and (b)
> even 256 pages is guaranteed to be enough.  On a Samsung 840 EVO (for
> example), you can have up to 32767k in a single request, and up to 31
> requests in its NCQ.  So in the worst case, you can have close to a
> gigabyte of outstanding writes, and thus with a sufficiently evil set
> of fio options, we could end up needing that many bounce pages.  And
> remember, the mempool is a shared resource; if we have multiple
> devices with encrypted file systems, the memory pressure could be even
> greater.

Agreed. I thought that mempool could be used to reuse the pages in the pool
as many as possible. But, I misunderstood the usage of it.

> 
> 4) I need to run the experiment, but what might make sense is to just
> call mempool_alloc() with GFP_NOWAIT.  This will allow us to use
> memory if it is available, but if not, we will simply retry the page
> for writeback.  The mempool is there simply to provide a bit of extra
> spare capacity so that we send out reasonably sized I/O's when under
> very high memory pressure.  We can make the size of the mempool a
> tunable which is dynamically adjustable using a sysfs file, and we can
> see what seems to be the best tradeoff between having a fixed memory
> allocation and performance under high memory pressure and heavy write
> loads.

It seems that the number of preallocated pages is not a critical issue to me
as of now. But, definitely, it should be tunable through sysfs for various
environments.

> 
> What do you think?  Does that make sense?  If so, you might want to
> try a similar experiment; try removing the alloc_page() fallback
> altogether, try calling mempool_alloc() with GFP_NOWAIT, and then try
> different settings for num_prealloc_crypto_pages.

Obviously, as your suggestion, it'd be better to call mempool_alloc(GFP_NOWAIT)
as the final approach [1]. I've also seen that this can resolve all my concerns.

Regarding to the num_prealloc_crypto_pages, let me take a time to investigate
further in terms of the performance under different workloads.

Thank you so much,

[1]
---
>From 16655dbe229610d679fd449a22b6f4565edfb89d Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Mon, 1 Jun 2015 12:39:30 -0700
Subject: [PATCH] f2fs crypto: remove alloc_page for bounce_page

We don't need to call alloc_page() prior to mempool_alloc(), since the
mempool_alloc() calls alloc_page() internally.
And, if __GFP_WAIT is set, it never fails on page allocation, so let's
give GFP_NOWAIT and handle ENOMEM by writepage().

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/crypto.c      | 33 ++++++++++++---------------------
 fs/f2fs/f2fs_crypto.h |  3 +--
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/crypto.c b/fs/f2fs/crypto.c
index 2c7819a..be6af18 100644
--- a/fs/f2fs/crypto.c
+++ b/fs/f2fs/crypto.c
@@ -83,10 +83,7 @@ void f2fs_release_crypto_ctx(struct f2fs_crypto_ctx *ctx)
 	unsigned long flags;
 
 	if (ctx->flags & F2FS_WRITE_PATH_FL && ctx->w.bounce_page) {
-		if (ctx->flags & F2FS_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL)
-			__free_page(ctx->w.bounce_page);
-		else
-			mempool_free(ctx->w.bounce_page, f2fs_bounce_page_pool);
+		mempool_free(ctx->w.bounce_page, f2fs_bounce_page_pool);
 		ctx->w.bounce_page = NULL;
 	}
 	ctx->w.control_page = NULL;
@@ -408,34 +405,28 @@ struct page *f2fs_encrypt(struct inode *inode,
 		return (struct page *)ctx;
 
 	/* The encryption operation will require a bounce page. */
-	ciphertext_page = alloc_page(GFP_NOFS);
+	ciphertext_page = mempool_alloc(f2fs_bounce_page_pool, GFP_NOWAIT);
 	if (!ciphertext_page) {
-		/*
-		 * This is a potential bottleneck, but at least we'll have
-		 * forward progress.
-		 */
-		ciphertext_page = mempool_alloc(f2fs_bounce_page_pool,
-							GFP_NOFS);
-		if (WARN_ON_ONCE(!ciphertext_page))
-			ciphertext_page = mempool_alloc(f2fs_bounce_page_pool,
-						GFP_NOFS | __GFP_WAIT);
-		ctx->flags &= ~F2FS_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL;
-	} else {
-		ctx->flags |= F2FS_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL;
+		err = -ENOMEM;
+		goto err_out;
 	}
+
 	ctx->flags |= F2FS_WRITE_PATH_FL;
 	ctx->w.bounce_page = ciphertext_page;
 	ctx->w.control_page = plaintext_page;
 	err = f2fs_page_crypto(ctx, inode, F2FS_ENCRYPT, plaintext_page->index,
 					plaintext_page, ciphertext_page);
-	if (err) {
-		f2fs_release_crypto_ctx(ctx);
-		return ERR_PTR(err);
-	}
+	if (err)
+		goto err_out;
+
 	SetPagePrivate(ciphertext_page);
 	set_page_private(ciphertext_page, (unsigned long)ctx);
 	lock_page(ciphertext_page);
 	return ciphertext_page;
+
+err_out:
+	f2fs_release_crypto_ctx(ctx);
+	return ERR_PTR(err);
 }
 
 /**
diff --git a/fs/f2fs/f2fs_crypto.h b/fs/f2fs/f2fs_crypto.h
index be59d91..c2c1c2b 100644
--- a/fs/f2fs/f2fs_crypto.h
+++ b/fs/f2fs/f2fs_crypto.h
@@ -84,8 +84,7 @@ struct f2fs_crypt_info {
 };
 
 #define F2FS_CTX_REQUIRES_FREE_ENCRYPT_FL             0x00000001
-#define F2FS_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL     0x00000002
-#define F2FS_WRITE_PATH_FL			      0x00000004
+#define F2FS_WRITE_PATH_FL			      0x00000002
 
 struct f2fs_crypto_ctx {
 	union {
-- 
2.1.1

