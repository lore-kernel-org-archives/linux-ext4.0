From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Use WRITE_SYNC in __block_write_full_page() if
	WBC_SYNC_ALL
Date: Mon, 5 Jan 2009 09:47:40 -0500
Message-ID: <20090105144740.GA4116@mit.edu>
References: <E1LJatq-00061O-0e@closure.thunk.org> <20090104142303.98762f81.akpm@linux-foundation.org> <20090104224351.GF22958@mit.edu> <20090104151927.1f1603c6.akpm@linux-foundation.org> <20090105080241.GX32491@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43515 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321AbZAEOrs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 09:47:48 -0500
Content-Disposition: inline
In-Reply-To: <20090105080241.GX32491@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[ I've removed linux-mm from the cc list since we seem to have
  wandered away from any details of page writeback.  -- Ted]

On Mon, Jan 05, 2009 at 09:02:43AM +0100, Jens Axboe wrote:
> > Is it?  WRITE_SYNC means "unplug the queue after this bh/BIO".  By setting
> > it against every bh, don't we risk the generation of more BIOs and
> > the loss of merging opportunities?
> 
> But it also implies that the io scheduler will treat the IO as sync even
> if it is a write, which seems to be the very effect that Ted is looking
> for as well.

Yeah, but I suspect the downsides caused by the lack of merging will
far outweigh wins from giving the hints to the I/O scheduler.
Separting things into two behavioural flags sounds like the the right
thing to me.  Until that happens, I've dropped my proposed patch and
substituted a patch which allows the user to diddle the I/O priorities
of kjournald2 via a mount option so we can experiment a bit.

I agree that Andrew's long-term solution is probably the right one,
but there will be times (i.e., when we are doing a checkpoint as
opposed to a commit, or in a fsync-heavy workload), where we will end
up getting blocked behind kjournald, so upping the I/O priority really
does make sense.  So a tunable mount option seems to make sense even
in the long run, since for some workloads we'll want to adjust
kjournald's I/O priority even after we stop normal (non-fsync) I/O
from blocking against the commit operation done by kjournald.

Jens, one question....  I came across the folllowing in blkdev.h:

      __REQ_RW_SYNC,		/* request is sync (O_DIRECT) */

Is the comment about O_DIRECT still relevant?  I'm not sure it is.

Also, there's another confusing comment in bio.h:

#define BIO_RW		0	/* Must match RW in req flags (blkdev.h) */
#define BIO_RW_AHEAD	1	/* Must match FAILFAST in req flags */
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
...
#define BIO_RW_FAILFAST_DEV		6
#define BIO_RW_FAILFAST_TRANSPORT	7
#define BIO_RW_FAILFAST_DRIVER		8


In fact, submit_bh() depends on BIO_RW_AHEAD matching with the
definition of READA in fs.h.  I'm a bit confused about the fact that
we have both BIO_RW_AHEAD and BIO_RW_FAILFAST_DEV, and then in the req
flags in blkdev.h:

/*
 * request type modified bits. first two bits match BIO_RW* bits, important
 */
enum rq_flag_bits {
     __REQ_RW,		/* not set, read. set, write */
     __REQ_FAILFAST_DEV,   /* no driver retries of device errors */
     __REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
     __REQ_FAILFAST_DRIVER,    /* no driver retries of driver errors */

I assume when doing readhaead, we don't want to retry in the face of
device errors, which is why it's desirable for __REQ_FAILFAST_DEV
overlays with BIO_RW_AHEAD.  But if that's the case, why are
BIO_RW_READA and BIO_RW_FAILFAST_DEV not mapped to the same BIO_RW_*
flag?

Am I missing something here?  As far as I can tell nothing seems to be
using BIO_RW_FAILFAST_DEV.  Is there a reason why it's not just
#define'd to be the same value as BIO_RW_READA?

Thanks, regards,

						- Ted
