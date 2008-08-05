From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO
	whentry_to_release_page fails
Date: Tue, 05 Aug 2008 12:17:35 -0400
Message-ID: <1217953055.7899.11.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
	 <20080804145047.04794bf3.akpm@linux-foundation.org>
	 <1217907353.7611.39.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:56536 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761351AbYHERpl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2008 13:45:41 -0400
In-Reply-To: <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-08-05 at 13:51 +0900, Hisashi Hifumi wrote:
> >> > 
> >> > diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c 
> >linux-2.6.27-rc1/fs/jbd/transaction.c
> >> > --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 
> >19:28:47.000000000 +0900
> >> > +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 20:40:12.000000000 +0900
> >> > @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
> >> >  	*/
> >> >  	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
> >> >  		journal_wait_for_transaction_sync_data(journal);
> >> > +
> >> > +		bh = head;
> >> > +		do {
> >> > +			while (atomic_read(&bh->b_count))
> >> > +				schedule();
> >> > +		} while ((bh = bh->b_this_page) != head);
> >> >  		ret = try_to_free_buffers(page);
> >> >  	}
> >> 
> >> The loop is problematic.  If the scheduler decides to keep running this
> >> task then we have a busy loop.  If this task has realtime policy then
> >> it might even lock up the kernel.
> >> 
> >
> >ocfs2 calls journal_try_to_free_buffers too, looping on b_count might
> >not be the best idea there either.
> >
> >This code gets called from releasepage, which is used other places than
> >the O_DIRECT invalidation paths, I'd be worried about performance
> >problems here.
> >
> 
> try_to_release_page has gfp_mask parameter. So when try_to_releasepage
> is called from performance sensitive part, gfp_mask should not be set.
> b_count check loop is inside of (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS) check.

Looks like try_to_free_pages will go into releasepage with wait & fs
both set.  This kind of change would make me very nervous.

-chris


