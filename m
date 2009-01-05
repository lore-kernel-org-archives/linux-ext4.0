From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Use WRITE_SYNC in __block_write_full_page() if
	WBC_SYNC_ALL
Date: Mon, 5 Jan 2009 14:35:17 -0500
Message-ID: <20090105193517.GC11632@mit.edu>
References: <E1LJatq-00061O-0e@closure.thunk.org> <20090104142303.98762f81.akpm@linux-foundation.org> <20090104224351.GF22958@mit.edu> <20090104151927.1f1603c6.akpm@linux-foundation.org> <20090105080241.GX32491@kernel.dk> <20090105144740.GA4116@mit.edu> <20090105104713.78fdabc9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47778 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZAETfX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 14:35:23 -0500
Content-Disposition: inline
In-Reply-To: <20090105104713.78fdabc9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 05, 2009 at 10:47:13AM -0800, Andrew Morton wrote:
> On Mon, 5 Jan 2009 09:47:40 -0500 Theodore Tso <tytso@mit.edu> wrote:
> 
> > there will be times (i.e., when we are doing a checkpoint as
> > opposed to a commit, or in a fsync-heavy workload), where we will end
> > up getting blocked behind kjournald, so upping the I/O priority really
> > does make sense.
> 
> Not if it will cause kjournald writes to be prioritised ahead of any
> reads, I suspect.  Writes are rarely synchronous, but with reads,
> there's almost always someone waiting.

If there is an fsync() in progress, someone's waiting; ditto in a
checkpoint situation, although arguably those are much rarer.
However, I can easily see situations such as a mail server where
having a slightly increased priority is a good thing.

So long-term, I suspect the hueristic which makes sense is that in the
case where there is an fsync() in progress, any writes which take
place as a result of that fsync (which includes the journal records as
well as ordered writes that are being forced out as a result of
data=ordered and which block the fsync from returning), should get a
hint which propagates down to the block layer that these writes *are*
synchronous in that someone is waiting for them to complete.  They
shouldn't necessarily be prioritized ahead of other reads (unless they
are readahead operations that couldn't be combined with reads that
*are* synchronous that someone is waiting for completion), but they
should be prioritized ahead of asynchronous writes.

							- Ted
