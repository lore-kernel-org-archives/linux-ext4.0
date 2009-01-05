From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Use WRITE_SYNC in __block_write_full_page() if
	WBC_SYNC_ALL
Date: Mon, 5 Jan 2009 16:16:07 -0500
Message-ID: <20090105211607.GF8939@mit.edu>
References: <E1LJatq-00061O-0e@closure.thunk.org> <20090104142303.98762f81.akpm@linux-foundation.org> <20090104224351.GF22958@mit.edu> <20090104151927.1f1603c6.akpm@linux-foundation.org> <20090105080241.GX32491@kernel.dk> <20090105144740.GA4116@mit.edu> <20090105104713.78fdabc9.akpm@linux-foundation.org> <20090105193517.GC11632@mit.edu> <20090105193820.GW32491@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39097 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbZAEVQN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 16:16:13 -0500
Content-Disposition: inline
In-Reply-To: <20090105193820.GW32491@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 05, 2009 at 08:38:20PM +0100, Jens Axboe wrote:
> On Mon, Jan 05 2009, Theodore Tso wrote:
> > So long-term, I suspect the hueristic which makes sense is that in the
> > case where there is an fsync() in progress, any writes which take
> > place as a result of that fsync (which includes the journal records as
> > well as ordered writes that are being forced out as a result of
> > data=ordered and which block the fsync from returning), should get a
> > hint which propagates down to the block layer that these writes *are*
> > synchronous in that someone is waiting for them to complete.  They
> 
> If someone is waiting for them, they are by definition sync!

Surely.  :-)

Andrew's argument is that someone *shouldn't* be waiting for them ---
and he's right, although in the case of fsync() in particular, there's
nothing we can do; there will be a userspace application waiting by
definition.

The bigger problem right now is until we split up the meaning of
"unplug the I/O queue" with "mark the I/O as synchronous", right now
the way data ordered mode works is all of the data blocks get pushed
out in 4k chunks.  So in the worst case, if the user has just written
some 200 megabytes of vmlinuz and kernel modules, and then calls
fsync(), the block I/O layer might get flooded with some 50,000+ 4k
writes, and if they are all BIO_RW_SYNC, they might not get coalesced
properly, and the result would be badness.  One could argue that
journal layer should do doing a better job of coalescing the write
requests, but historically the block layer has done this for us, so
why add duplicate functionality at the journalling layer?

In any case, that's why I'm really not convinced we can afford to use
BIO_RW_SYNC until we separate out the queue unplug functionality.
Maybe what makes sence is to have two flags, BIO_RW_UNPLUG and
BIO_RW_SYNCIO, and then make BIO_RW_SYNC be defined to be
(BIO_RW_UNPLUG|BIO_RW_SYNCIO)?

> > shouldn't necessarily be prioritized ahead of other reads (unless they
> > are readahead operations that couldn't be combined with reads that
> > *are* synchronous that someone is waiting for completion), but they
> > should be prioritized ahead of asynchronous writes.
> 
> And that is *exactly* what flagging the write as sync will do...

Great, so once we separate out the queue unplug request, I think this
should be exactly what we need.

							- Ted
