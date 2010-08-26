From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Thu, 26 Aug 2010 16:38:00 +1000
Message-ID: <20100826063759.GB705@dastard>
References: <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu>
 <1282743090.2605.3696.camel@laptop>
 <alpine.DEB.2.00.1008251340420.16484@chino.kir.corp.google.com>
 <1282769729.1975.96.camel@laptop>
 <alpine.DEB.2.00.1008251406260.20253@chino.kir.corp.google.com>
 <1282771677.1975.138.camel@laptop>
 <alpine.DEB.2.00.1008251606450.31521@chino.kir.corp.google.com>
 <20100826001901.GL4453@thunk.org>
 <alpine.DEB.2.00.1008251724360.25783@chino.kir.corp.google.com>
 <20100826014847.GQ4453@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Jens Axboe <jaxboe@fusionio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ne
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:47648 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751642Ab0HZGiG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 02:38:06 -0400
Content-Disposition: inline
In-Reply-To: <20100826014847.GQ4453@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 25, 2010 at 09:48:47PM -0400, Ted Ts'o wrote:
> On Wed, Aug 25, 2010 at 05:30:42PM -0700, David Rientjes wrote:
> > 
> > We certainly hope that nobody will reimplement the same function without 
> > the __deprecated warning, especially for order < PAGE_ALLOC_COSTLY_ORDER 
> > where there's no looping at a higher level.  So perhaps the best 
> > alternative is to implement the same _nofail() functions but do a 
> > WARN_ON(get_order(size) > PAGE_ALLOC_COSTLY_ORDER) instead?
> 
> Yeah, that sounds better.
> 
> > I think it's really sad that the caller can't know what the upper bounds 
> > of its memory requirement are ahead of time or at least be able to 
> > implement a memory freeing function when kmalloc() returns NULL.
> 
> Oh, we can determine an upper bound.  You might just not like it.
> Actually ext3/ext4 shouldn't be as bad as XFS, which Dave estimated to
> be around 400k for a transaction.

For a 4k block size filesystem.

If I use 64k block size directories (which XFS can even on 4k page
size machines), the maximum transaction reservation goes up to at
around 3MB, and that's just for blocks being _modified_. It's not
the limit on the amount of memory that may need to be allocated
during a transaction....

> My guess is that the worst case for
> ext3/ext4 is probably around 256k or so; like XFS, most of the time,
> it would be a lot less. 

Right, it usually is a lot less, but one of the big problems is that
during low memory situations memory reclaim of the metadata page
cache actually causes _more_ memory allocation during tranactions
than otherwise would occur.......

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
