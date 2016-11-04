From: Jan Kara <jack@suse.cz>
Subject: [PATCH 6/6] fs: Remove unmap_underlying_metadata
Date: Fri,  4 Nov 2016 18:08:16 +0100
Message-ID: <1478279296-6575-7-git-send-email-jack@suse.cz>
References: <1478279296-6575-1-git-send-email-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>,
        linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932899AbcKDRI2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 4 Nov 2016 13:08:28 -0400
In-Reply-To: <1478279296-6575-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nobody is using this function anymore. Remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 32 --------------------------------
 include/linux/buffer_head.h |  1 -
 2 files changed, 33 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index f96c079e181d..6d6680c8d306 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1605,38 +1605,6 @@ void create_empty_buffers(struct page *page,
 }
 EXPORT_SYMBOL(create_empty_buffers);
 
-/*
- * We are taking a block for data and we don't want any output from any
- * buffer-cache aliases starting from return from that function and
- * until the moment when something will explicitly mark the buffer
- * dirty (hopefully that will not happen until we will free that block ;-)
- * We don't even need to mark it not-uptodate - nobody can expect
- * anything from a newly allocated buffer anyway. We used to used
- * unmap_buffer() for such invalidation, but that was wrong. We definitely
- * don't want to mark the alias unmapped, for example - it would confuse
- * anyone who might pick it with bread() afterwards...
- *
- * Also..  Note that bforget() doesn't lock the buffer.  So there can
- * be writeout I/O going on against recently-freed buffers.  We don't
- * wait on that I/O in bforget() - it's more efficient to wait on the I/O
- * only if we really need to.  That happens here.
- */
-void unmap_underlying_metadata(struct block_device *bdev, sector_t block)
-{
-	struct buffer_head *old_bh;
-
-	might_sleep();
-
-	old_bh = __find_get_block_slow(bdev, block);
-	if (old_bh) {
-		clear_buffer_dirty(old_bh);
-		wait_on_buffer(old_bh);
-		clear_buffer_req(old_bh);
-		__brelse(old_bh);
-	}
-}
-EXPORT_SYMBOL(unmap_underlying_metadata);
