From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Date: Tue, 7 Apr 2009 09:08:36 +0200
Message-ID: <20090407070835.GM5178@kernel.dk>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:32981 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZDGHIk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2009 03:08:40 -0400
Content-Disposition: inline
In-Reply-To: <20090406235052.1ea47513.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 06 2009, Andrew Morton wrote:
> On Mon, 6 Apr 2009 23:21:41 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I mean, let's graph it:
> > 
> > WRITE_SYNC -> WRITE_SYNC_PLUG -> BIO_RW_SYNCIO -> bio_sync() -> REQ_RW_SYNC -> rw_is_sync() -> does something mysterious in get_request()
> >                                                                             -> rq_is_sync() -> does something mysterious in IO schedulers
> >                               -> BIO_RW_NOIDLE -> bio_noidle() -> REQ_NOIDLE -> rq_noidle() -> does something mysterious in cfq-iosched only
> >            -> BIO_RW_UNPLUG   -> bio_unplug() -> REQ_UNPLUG -> OK, the cognoscenti know what this is supposed to do, but it is unused!
> 
> whoop, I found a use of bio_unplug() in __make_request().
> 
> So it appears that the intent of your patch is to cause an unplug after
> submission of each WB_SYNC_ALL block?
> 
> But what about all the other stuff which WRITE_SYNC might or might not
> do?  What does WRITE_SYNC _actually_ do, and what are the actual
> effects of this change??
> 
> And what effect will this large stream of unplugs have upon merging?

It looks like a good candidate for WRITE_SYNC_PLUG instead, since it
does more than one buffer submission before waiting. It likely wont mean
a whole lot since we'll usually only have a single buffer on that page,
but for < PAGE_CACHE_SIZE block sizes it could easily make a big
difference (4 ios instead of 1!).

So on the write side, basically we have:

WRITE                   Normal async write.
WRITE_SYNC_PLUG         Sync write, someone will wait on this so don't
                        treat it as background activity. This is a hint
                        to the io schedulers. This one does NOT unplug
                        the queue, either the caller should do it after
                        submission, or he should make sure that the
                        wait_on_* callbacks do it for him.
WRITE_SYNC              Like WRITE_SYNC_PLUG, but causes immediate
                        unplug of the queue after submission. Most
                        uses of this should likely use WRITE_SYNC_PLUG,
                        at least in the normal IO path.
WRITE_ODIRECT           Like WRITE_SYNC, but also passes a hint to the
                        IO scheduler that we should expect more IO.
                        This is similar to how a read is treated in the
                        scheduler, it'll enable anticipation/idling.

Ditto for the SWRITE* variants, which are special hacks for
ll_rw_block() only.

I have killed REQ_UNPLUG, it doesn't make sense to pass the further down
than to __make_request(), so the bio flag is enough.

-- 
Jens Axboe

