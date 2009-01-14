From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Date: Wed, 14 Jan 2009 17:04:18 -0500
Message-ID: <20090114220418.GN6222@mit.edu>
References: <1231945948-23676-1-git-send-email-jack@suse.cz> <1231945948-23676-2-git-send-email-jack@suse.cz> <20090114101834.fbb9ea12.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, pavel@suse.cz
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60376 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754598AbZANWFL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 17:05:11 -0500
Content-Disposition: inline
In-Reply-To: <20090114101834.fbb9ea12.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 14, 2009 at 10:18:34AM -0800, Andrew Morton wrote:
> /**
>  * blkdev_issue_flush - queue a flush
>  * @bdev:	blockdev to issue flush for
>  * @error_sector:	error sector
>  *
>  * Description:
>  *    Issue a flush for the block device in question. Caller can supply
>  *    room for storing the error offset in case of a flush error, if they
>  *    wish to.  Caller must run wait_for_completion() on its own.
>  */
> 
> So afaict the change you've made is incomplete.  We'll queue a
> writeback command to the disk but we won't wait for it to be sent down
> the wire.  

No, that last part of the comment is stale, and it's already been
confirmed by Jens.   He's queued in the block tree:

>From 801d773a6ff5dbb37c9eaa4b89ae3fc6574ba294 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 13 Jan 2009 09:25:08 -0500
Subject: [PATCH] block: Fix documentation for blkdev_issue_flush()

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 block/blk-barrier.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 8eba4e4..f7dae57 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -302,7 +302,7 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
  * Description:
  *    Issue a flush for the block device in question. Caller can supply
  *    room for storing the error offset in case of a flush error, if they
- *    wish to.  Caller must run wait_for_completion() on its own.
+ *    wish to.
  */
 int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 {
-- 
1.6.0.4.8.g36f27.dirty

						- Ted
