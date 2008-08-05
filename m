From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO when
	try_to_release_page fails
Date: Mon, 04 Aug 2008 23:35:53 -0400
Message-ID: <1217907353.7611.39.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
	 <20080804145047.04794bf3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, cmm@us.ibm.com,
	jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:57395 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbYHEDkI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 23:40:08 -0400
In-Reply-To: <20080804145047.04794bf3.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-08-04 at 14:50 -0700, Andrew Morton wrote:
> On Mon, 04 Aug 2008 20:10:33 +0900
> Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:
> 
> > Hi
> > 
> > Dio write returns EIO when try_to_release_page fails because bh is
> > still referenced.

> > 
> > diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c linux-2.6.27-rc1/fs/jbd/transaction.c
> > --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 19:28:47.000000000 +0900
> > +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 20:40:12.000000000 +0900
> > @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
> >  	*/
> >  	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
> >  		journal_wait_for_transaction_sync_data(journal);
> > +
> > +		bh = head;
> > +		do {
> > +			while (atomic_read(&bh->b_count))
> > +				schedule();
> > +		} while ((bh = bh->b_this_page) != head);
> >  		ret = try_to_free_buffers(page);
> >  	}
> 
> The loop is problematic.  If the scheduler decides to keep running this
> task then we have a busy loop.  If this task has realtime policy then
> it might even lock up the kernel.
> 

ocfs2 calls journal_try_to_free_buffers too, looping on b_count might
not be the best idea there either.

This code gets called from releasepage, which is used other places than
the O_DIRECT invalidation paths, I'd be worried about performance
problems here.

-chris


