From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Use WRITE_SYNC in __block_write_full_page() if
	WBC_SYNC_ALL
Date: Sun, 4 Jan 2009 17:43:51 -0500
Message-ID: <20090104224351.GF22958@mit.edu>
References: <E1LJatq-00061O-0e@closure.thunk.org> <20090104142303.98762f81.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60698 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZADWn4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Jan 2009 17:43:56 -0500
Content-Disposition: inline
In-Reply-To: <20090104142303.98762f81.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 04, 2009 at 02:23:03PM -0800, Andrew Morton wrote:
> > Following up with an e-mail thread started by Arjan two months ago,
> > (subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority), I have
> > a patch, just sent to linux-ext4@vger.kernel.org, which fixes the jbd2
> > layer to submit journal writes via submit_bh() with WRITE_SYNC.
> > Hopefully this might be enough of a priority boost so we don't have to
> > force a higher I/O priority level via a buffer_head flag.  However,
> > while looking through the code paths, in ordered data mode, we end up
> > flushing data pages via the page writeback paths on a per-inode basis,
> > and I noticed that even though we are passing in
> > wbc.sync_mode=WBC_SYNC_ALL, __block_write_full_page() is using
> > submit_bh(WRITE, bh) instead of submit_bh(WRITE_SYNC).
> 
> But this is all the wrong way to fix the problem, isn't it?
> 
> The problem is that at one particular point, the current transaction
> blocks callers behind the committing transaction's IO completion.
> 
> Did anyone look at fixing that?  ISTR concluding that a data copy and
> shadow-bh arrangement might be needed.

I haven't had time to really drill down into the jbd code yet, and
yes, eventually we probably want to do this.  Still, if we are
submitting I/O which we are going to end up waiting on, we really
should submit it with WRITE_SYNC, and this patch should optimize
writes in other situations; for example, if we fsync() a file, we will
also end up calling block_write_full_page(), and so supplying the
WRITE_SYNC hint to the block layer would be a Good Thing.

	   	       	     	   	      - Ted
