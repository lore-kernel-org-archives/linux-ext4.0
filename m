From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH, RFC] Use WRITE_SYNC in __block_write_full_page() if WBC_SYNC_ALL
Date: Mon, 5 Jan 2009 20:38:20 +0100
Message-ID: <20090105193820.GW32491@kernel.dk>
References: <E1LJatq-00061O-0e@closure.thunk.org> <20090104142303.98762f81.akpm@linux-foundation.org> <20090104224351.GF22958@mit.edu> <20090104151927.1f1603c6.akpm@linux-foundation.org> <20090105080241.GX32491@kernel.dk> <20090105144740.GA4116@mit.edu> <20090105104713.78fdabc9.akpm@linux-foundation.org> <20090105193517.GC11632@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:2428 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZAETjY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 14:39:24 -0500
Content-Disposition: inline
In-Reply-To: <20090105193517.GC11632@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 05 2009, Theodore Tso wrote:
> So long-term, I suspect the hueristic which makes sense is that in the
> case where there is an fsync() in progress, any writes which take
> place as a result of that fsync (which includes the journal records as
> well as ordered writes that are being forced out as a result of
> data=ordered and which block the fsync from returning), should get a
> hint which propagates down to the block layer that these writes *are*
> synchronous in that someone is waiting for them to complete.  They

If someone is waiting for them, they are by definition sync!

> shouldn't necessarily be prioritized ahead of other reads (unless they
> are readahead operations that couldn't be combined with reads that
> *are* synchronous that someone is waiting for completion), but they
> should be prioritized ahead of asynchronous writes.

And that is *exactly* what flagging the write as sync will do...

-- 
Jens Axboe

