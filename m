From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 6 Apr 2009 08:23:59 +0200
Message-ID: <20090406062358.GN5178@kernel.dk>
References: <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu> <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:52714 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbZDFGYB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 02:24:01 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 05 2009, Linus Torvalds wrote:
> 
> 
> On Sat, 4 Apr 2009, Theodore Tso wrote:
> > 
> > It may be that it's easier from an less-lines-of-the-kernels-to-change
> > point of view to add a WRITE_SYNC_PLUGGED which doesn't do the unplug,
> > and keep WRITE_SNYC as having the implicit unplug.  Or maybe it would
> > be better to completely separate the "send a write which is marked as
> > SYNC" from the "implicit unplug" in the API.
> 
> Well, the block layer internally already separates the two, it's just 
> WRITE_SYNC that ties them together. So a trivial patch like the appended 
> would make WRITE_SYNC just mean "this is synchronous IO" without the 
> unplugging, and then WRITE_UNPLUG would mark it both as synchronous _and_ 
> unplug it.
> 
> (Or you could do the WRITE_SYNC_PLUGGED model too, but I think WRITE_SYNC 
> and WRITE_UNPLUG actually would be better names, since they talk about the 
> effects more directly).
> 
> The question is more of a "who really wants the unplugging". Presumably 
> the direct-io code-path really does (on the assumption that if you are 
> doing direct-io, the caller had better done all the coalescing it wants).
> 
> Non-rotational media would tend to want the unplugging, but the block 
> layer already does that (ie in __make_request() we already do:
> 
>         if (unplug || blk_queue_nonrot(q))
>                 __generic_unplug_device(q);
> 
> so non-rotational devices get unplugged whether the request was a 
> unplugging request or not).
> 
> Of course, different IO schedulers react differently to that whole "sync 
> vs unplug" thing. I think CFQ is the only one that actually cares about 
> the "sync" bit (using different queues for sync vs async). The other 
> schedulers only care about the plugging. So the patch below really doesn't 
> make much sense as-is, because as things are right now, the scheduler 
> behaviors are so different for the unplug-vs-sync thing that no sane user 
> can ever know whether they should use WRITE_SYNC (== higher priority 
> queueing for CFQ, no-op for others) or WRITE_UNPLUG (unplug on all, and 
> additionally higher priority for CFQ).

AS also very much cares about sync vs async. CFQ and AS both use that to
determine whether to wait for a new request from that io context, even
if we have other work to do. This is the logic that enables dependent
reads to proceed at a fast pace, instead of incurring a seek on every
read from a process reading lots of smaller files.

This could very well be what is causing a performance problem with the
writes. For most of these writes, you really don't want to idle at the
end even if they are SYNC. For O_DIRECT it's a win though, so we can't
just say 'never idle for sync writes'. Perhaps what we really need is a
specific WRITE_ODIRECT that signals sync and enables idling, while
keeping the WRITE_SYNC / WRITE_SYNC_UNPLUG like normal writes but just
at sync priority.

> So I'm not serious about this patch, because as things are right now, I 
> don't think it's sensible, but I do think that this just generally shows 
> the confusion of what we should do. When is plugging right, when isn't it?
> 
> Also, one of the issues seems to literally be that the higher-level 
> request handling doesn't care AT ALL about the priority. Allocating the 
> request itself does keep reads and writes separated, but if the request is 
> a SYNCIO request, and non-sync writes have filled up th write requests, 
> we'll have to wait for the background writes to free up requests.
> 
> That is quite possibly the longest wait we have in the system.
> 
> See get_request():
> 
> 	const int rw = rw_flags & 0x01;
> 
> (That should _really_ be RW_MASK instead of 0x01, I suspect) and how the 
> request allocation itself is done.
> 
> I think this is broken.

If we just make it (rw & REQ_RW_SYNC) then we get all sync requests from
the same pool, instead of doing the read vs write thing there. And I
agree, that makes sense.

> @@ -95,7 +95,8 @@ struct inodes_stat_t {
>  #define SWRITE 3	/* for ll_rw_block() - wait for buffer lock */
>  #define READ_SYNC	(READ | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
>  #define READ_META	(READ | (1 << BIO_RW_META))
> -#define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
> +#define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNCIO))
> +#define WRITE_UNPLUG	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
>  #define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
>  #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
>  #define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)

On the naming, after thinking a bit about it, I think it should be
WRITE_SYNC_PLUGGED and WRITE_SYNC. The reason being that if you use
WRITE_SYNC_PLUGGED, then you MUST unplug at some point in time. By
making that explicit in the name, we don't risk callers forgetting to
unplug and causing the unplug timer to do that work (and slowing things
down).

-- 
Jens Axboe

