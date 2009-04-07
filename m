From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
 WBC_SYNC_ALL writebacks
Date: Mon, 6 Apr 2009 23:21:41 -0700
Message-ID: <20090406232141.ebdb426a.akpm@linux-foundation.org>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu>
	<1238185471-31152-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz, Jens Axboe <jens.axboe@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbZDGGZF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 02:25:05 -0400
In-Reply-To: <1238185471-31152-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 27 Mar 2009 16:24:29 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:

> When doing synchronous writes because wbc->sync_mode is set to
> WBC_SYNC_ALL, send the write request using WRITE_SYNC, so that we
> don't unduly block system calls such as fsync().
> 

Who what where why when?  How does this patch work?

> ---
>  fs/buffer.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 891e1c7..e7ebd95 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1714,6 +1714,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  	struct buffer_head *bh, *head;
>  	const unsigned blocksize = 1 << inode->i_blkbits;
>  	int nr_underway = 0;
> +	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
>  
>  	BUG_ON(!PageLocked(page));
>  
> @@ -1805,7 +1806,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  	do {
>  		struct buffer_head *next = bh->b_this_page;
>  		if (buffer_async_write(bh)) {
> -			submit_bh(WRITE, bh);
> +			submit_bh(write_op, bh);
>  			nr_underway++;
>  		}
>  		bh = next;
> @@ -1859,7 +1860,7 @@ recover:
>  		struct buffer_head *next = bh->b_this_page;
>  		if (buffer_async_write(bh)) {
>  			clear_buffer_dirty(bh);
> -			submit_bh(WRITE, bh);
> +			submit_bh(write_op, bh);
>  			nr_underway++;
>  		}
>  		bh = next;

<spends faaaaaaaaaaaaaaaaaaaaaar too long trying to work out what WRITE_SYNC does>

ytf can't we document these things?

I'm having trouble distinguishing all that code from a pile of crap.

I mean, let's graph it:

WRITE_SYNC -> WRITE_SYNC_PLUG -> BIO_RW_SYNCIO -> bio_sync() -> REQ_RW_SYNC -> rw_is_sync() -> does something mysterious in get_request()
                                                                            -> rq_is_sync() -> does something mysterious in IO schedulers
                              -> BIO_RW_NOIDLE -> bio_noidle() -> REQ_NOIDLE -> rq_noidle() -> does something mysterious in cfq-iosched only
           -> BIO_RW_UNPLUG   -> bio_unplug() -> REQ_UNPLUG -> OK, the cognoscenti know what this is supposed to do, but it is unused!

It this really really so obvious and simple that we can afford to leave
WRITE_SYNC semantics undocumented?

All this makes it impossible to review your patch.
