From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 20:09:21 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008251951230.7034@chino.kir.corp.google.com>
References: <1282740778.2605.3652.camel@laptop> <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu> <1282743090.2605.3696.camel@laptop> <alpine.DEB.2.00.1008251340420.16484@chino.kir.corp.google.com> <1282769729.1975.96.camel@laptop>
 <alpine.DEB.2.00.1008251406260.20253@chino.kir.corp.google.com> <1282771677.1975.138.camel@laptop> <alpine.DEB.2.00.1008251606450.31521@chino.kir.corp.google.com> <20100826001901.GL4453@thunk.org> <alpine.DEB.2.00.1008251724360.25783@chino.kir.corp.google.com>
 <20100826014847.GQ4453@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: "Ted Ts'o" <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
	Jens Axboe <jaxboe@fusionio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:24600 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab0HZDJ3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 23:09:29 -0400
In-Reply-To: <20100826014847.GQ4453@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 25 Aug 2010, Ted Ts'o wrote:

> > We certainly hope that nobody will reimplement the same function without 
> > the __deprecated warning, especially for order < PAGE_ALLOC_COSTLY_ORDER 
> > where there's no looping at a higher level.  So perhaps the best 
> > alternative is to implement the same _nofail() functions but do a 
> > WARN_ON(get_order(size) > PAGE_ALLOC_COSTLY_ORDER) instead?
> 
> Yeah, that sounds better.
> 

Ok, and we'll make it a WARN_ON_ONCE() to be nice to the kernel log.  
Although the current patchset does this with WARN_ON_ONCE(1, ...) instead, 
this serves to ensure that we aren't dependent on the page allocator's 
implementation to always loop for order < PAGE_ALLOC_COSTLY_ORDER in which 
case the loop in the _nofail() functions would actually do something.

> > I think it's really sad that the caller can't know what the upper bounds 
> > of its memory requirement are ahead of time or at least be able to 
> > implement a memory freeing function when kmalloc() returns NULL.
> 
> Oh, we can determine an upper bound.  You might just not like it.
> Actually ext3/ext4 shouldn't be as bad as XFS, which Dave estimated to
> be around 400k for a transaction.  My guess is that the worst case for
> ext3/ext4 is probably around 256k or so; like XFS, most of the time,
> it would be a lot less.  (At least, if data != journalled; if we are
> doing data journalling and every single data block begins with
> 0xc03b3998U, we'll need to allocate a 4k page for every single data
> block written.)  We could dynamically calculate an upper bound if we
> had to.  Of course, if ext3/ext4 is attached to a network block
> device, then it could get a lot worse than 256k, of course.
> 

On my 8GB machine, /proc/zoneinfo says the min watermark for ZONE_NORMAL 
is 5086 pages, or ~20MB.  GFP_ATOMIC would allow access to ~12MB of that, 
so perhaps we should consider this is an acceptable abuse of GFP_ATOMIC as 
a fallback behavior when GFP_NOFS or GFP_NOIO fails?
