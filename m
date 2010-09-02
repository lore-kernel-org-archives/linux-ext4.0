From: Jan Kara <jack@suse.cz>
Subject: Re: [patch v2 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Thu, 2 Sep 2010 16:51:41 +0200
Message-ID: <20100902145141.GA3273@quack.suse.cz>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com>
 <4C7F5951.6040809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Received: from cantor.suse.de ([195.135.220.2]:50738 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab0IBOwc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Sep 2010 10:52:32 -0400
Content-Disposition: inline
In-Reply-To: <4C7F5951.6040809@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 02-09-10 09:59:13, Jiri Slaby wrote:
> On 09/02/2010 03:02 AM, David Rientjes wrote:
> > --- a/include/linux/slab.h +++ b/include/linux/slab.h @@ -334,6 +334,57
> > @@ static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
> > return kmalloc_node(size, flags | __GFP_ZERO, node); }
> >  
> > +/** + * kmalloc_nofail - infinitely loop until kmalloc() succeeds.  +
> > * @size: how many bytes of memory are required.  + * @flags: the type
> > of memory to allocate (see kmalloc).  + * + * NOTE: no new callers of
> > this function should be implemented!  + * All memory allocations should
> > be failable whenever possible.  + */ +static inline void
> > *kmalloc_nofail(size_t size, gfp_t flags) +{ +	void *ret; + +	for
> > (;;) { +		ret = kmalloc(size, flags); +		if (ret) +
> > return ret; +		WARN_ON_ONCE(get_order(size) >
> > PAGE_ALLOC_COSTLY_ORDER);
> 
> This doesn't work as you expect. kmalloc will warn every time it fails.
> __GFP_NOFAIL used to disable the warning. Actually what's wrong with
> __GFP_NOFAIL? I cannot find a reason in the changelogs why the patches
> are needed.
  David should probably add the reasoning to the changelogs so that he
doesn't have to explain again and again ;). But if I understood it
correctly, the concern is that the looping checks slightly impact fast path
of the callers which do not need it. Generally, also looping for a long
time inside allocator isn't a nice thing but some callers aren't able to do
better for now to the patch is imperfect in this sence...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
