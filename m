From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Date: Wed, 14 Jan 2009 14:17:27 -0800
Message-ID: <20090114141727.0a5dd3fb.akpm@linux-foundation.org>
References: <1231945948-23676-1-git-send-email-jack@suse.cz>
	<1231945948-23676-2-git-send-email-jack@suse.cz>
	<20090114101834.fbb9ea12.akpm@linux-foundation.org>
	<20090114220418.GN6222@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, pavel@suse.cz
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbZANWS0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 17:18:26 -0500
In-Reply-To: <20090114220418.GN6222@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 14 Jan 2009 17:04:18 -0500
Theodore Tso <tytso@MIT.EDU> wrote:

> On Wed, Jan 14, 2009 at 10:18:34AM -0800, Andrew Morton wrote:
> > /**
> >  * blkdev_issue_flush - queue a flush
> >  * @bdev:	blockdev to issue flush for
> >  * @error_sector:	error sector
> >  *
> >  * Description:
> >  *    Issue a flush for the block device in question. Caller can supply
> >  *    room for storing the error offset in case of a flush error, if they
> >  *    wish to.  Caller must run wait_for_completion() on its own.
> >  */
> > 
> > So afaict the change you've made is incomplete.  We'll queue a
> > writeback command to the disk but we won't wait for it to be sent down
> > the wire.  
> 
> No, that last part of the comment is stale, and it's already been
> confirmed by Jens.   He's queued in the block tree:
> 
> >From 801d773a6ff5dbb37c9eaa4b89ae3fc6574ba294 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Tue, 13 Jan 2009 09:25:08 -0500
> Subject: [PATCH] block: Fix documentation for blkdev_issue_flush()
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  block/blk-barrier.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-barrier.c b/block/blk-barrier.c
> index 8eba4e4..f7dae57 100644
> --- a/block/blk-barrier.c
> +++ b/block/blk-barrier.c
> @@ -302,7 +302,7 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
>   * Description:
>   *    Issue a flush for the block device in question. Caller can supply
>   *    room for storing the error offset in case of a flush error, if they
> - *    wish to.  Caller must run wait_for_completion() on its own.
> + *    wish to.
>   */
>  int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
>  {

<glances at the code>

<doh>

The function's name is now inappropriate.
