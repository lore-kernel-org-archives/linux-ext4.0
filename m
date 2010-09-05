From: David Rientjes <rientjes@google.com>
Subject: Re: [patch v2 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Sun, 5 Sep 2010 16:01:45 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1009051555560.5003@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com> <4C7F5951.6040809@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:43108 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0IEXBx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Sep 2010 19:01:53 -0400
In-Reply-To: <4C7F5951.6040809@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2 Sep 2010, Jiri Slaby wrote:

> > @@ -334,6 +334,57 @@ static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
> >  	return kmalloc_node(size, flags | __GFP_ZERO, node);
> >  }
> >  
> > +/**
> > + * kmalloc_nofail - infinitely loop until kmalloc() succeeds.
> > + * @size: how many bytes of memory are required.
> > + * @flags: the type of memory to allocate (see kmalloc).
> > + *
> > + * NOTE: no new callers of this function should be implemented!
> > + * All memory allocations should be failable whenever possible.
> > + */
> > +static inline void *kmalloc_nofail(size_t size, gfp_t flags)
> > +{
> > +	void *ret;
> > +
> > +	for (;;) {
> > +		ret = kmalloc(size, flags);
> > +		if (ret)
> > +			return ret;
> > +		WARN_ON_ONCE(get_order(size) > PAGE_ALLOC_COSTLY_ORDER);
> 
> This doesn't work as you expect. kmalloc will warn every time it fails.

It actually does work as I expect since the WARN_ON_ONCE() never even gets 
triggered here for any of kmalloc_nofail()'s callers since they all have 
sizes small enough that the conditional is never true.  The page allocator 
implicitly loops forever if the order <= PAGE_ALLOC_COSTLY_ORDER, so this 
warning is only emitted if the #define implementation of the page 
allocator only changes.  That's intended, we want to know the consequences 
of our change.

> __GFP_NOFAIL used to disable the warning.

No, it didn't, it was unnecessary for all of the kmalloc_nofail() callers 
since they already implicitly loop.  No warning is emitted (these are all 
GFP_NOFS or GFP_NOIO users, there are no order-4 or larger GFP_ATOMIC 
allocators using this interface).

> Actually what's wrong with
> __GFP_NOFAIL? I cannot find a reason in the changelogs why the patches
> are needed.
> 

Couple reasons:

 - it's unnecessary in the page allocator, it can be implemented at a 
   higher level, which allows us to remove these branches from the 
   slowpath,

 - it's mostly unnecessary since all users have orders that will 
   implicitly loop forever anyway (although __GFP_NOFAIL does guarantee 
   that it won't fail even if we change the looping behavior internally,
   these warnings help to isolate cases where it's needed), and
