From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Use WRITE_SYNC in __block_write_full_page() if
	WBC_SYNC_ALL
Date: Sun, 4 Jan 2009 19:21:09 -0500
Message-ID: <20090105002109.GI22958@mit.edu>
References: <E1LJatq-00061O-0e@closure.thunk.org> <20090104142303.98762f81.akpm@linux-foundation.org> <20090104224351.GF22958@mit.edu> <20090104151927.1f1603c6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20090104151927.1f1603c6.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jan 04, 2009 at 03:19:27PM -0800, Andrew Morton wrote:
> >  Still, if we are
> > submitting I/O which we are going to end up waiting on, we really
> > should submit it with WRITE_SYNC, and this patch should optimize
> > writes in other situations; for example, if we fsync() a file, we will
> > also end up calling block_write_full_page(), and so supplying the
> > WRITE_SYNC hint to the block layer would be a Good Thing.
> 
> Is it?  WRITE_SYNC means "unplug the queue after this bh/BIO".  By setting
> it against every bh, don't we risk the generation of more BIOs and
> the loss of merging opportunities?

Good point, yeah, that's a problem.  Some of IO schedulers also use
REQ_RW_SYNC to prioritize the I/O's above non-sync I/O's.  That's an
orthognal issue to unplugging the queue; it would be useful to be able
to mark an I/O as "this is bio is one that we will eventually end up
waiting to complete", separately from "please unplug the the queue
after this bio submitted".

BTW, I notice that the CFQ io scheduler prioritizes REQ_RW_META bio's
behind REQ_RW_SYNC bio's, but ahead of normal bio requeuss.  But as
far as I can tell nothing is actually marking requests REQ_RW_META.
What is the intended use for this, and are there plans to make other
I/O schedulers honor REQ_RW_META?

							- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
