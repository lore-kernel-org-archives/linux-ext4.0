From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block_write_full_page: switch synchronous writes to use
 WRITE_SYNC_PLUG
Date: Tue, 7 Apr 2009 16:09:44 -0700
Message-ID: <20090407160944.de3c5139.akpm@linux-foundation.org>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu>
	<1238185471-31152-2-git-send-email-tytso@mit.edu>
	<20090406232141.ebdb426a.akpm@linux-foundation.org>
	<20090406235052.1ea47513.akpm@linux-foundation.org>
	<20090407070835.GM5178@kernel.dk>
	<20090407002313.fcdd1da0.akpm@linux-foundation.org>
	<20090407075732.GO5178@kernel.dk>
	<20090407190913.GA31723@mit.edu>
	<20090407193239.GE5178@kernel.dk>
	<20090407214421.GA7031@mit.edu>
	<20090407221933.GB7031@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jack@suse.cz
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757492AbZDGXN1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 19:13:27 -0400
In-Reply-To: <20090407221933.GB7031@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 7 Apr 2009 18:19:33 -0400
Theodore Tso <tytso@mit.edu> wrote:

> Now that we have a distinction between WRITE_SYNC and WRITE_SYNC_PLUG,
> use WRITE_SYNC_PLUG in __block_write_full_page() to avoid unplugging
> the block device I/O queue between each page that gets flushed out.
> 
> The upstream callers of block_write_full_page() which wait for the
> writes to finish call wait_on_buffer(), wait_on_writeback_range()
> (which ultimately calls sync_page(), which calls
> blk_run_backing_dev(), which will unplug the device queue), and so on.
> 

<sob>

> 
> We should get this applied to avoid any performance regressions
> resulting from commit a64c8610.
> 
>  fs/buffer.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 977e12a..95b5390 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1646,7 +1646,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  	struct buffer_head *bh, *head;
>  	const unsigned blocksize = 1 << inode->i_blkbits;
>  	int nr_underway = 0;
> -	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
> +	int write_op = (wbc->sync_mode == WB_SYNC_ALL ?
> +			WRITE_SYNC_PLUG : WRITE);
>  
>  	BUG_ON(!PageLocked(page));

So how does WRITE_SYNC_PLUG differ from WRITE, and what effect does
this change have upon kernel behaviour?


