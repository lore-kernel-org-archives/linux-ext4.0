From: Nick Piggin <npiggin@suse.de>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Date: Fri, 26 Jun 2009 11:07:41 +0200
Message-ID: <20090626090741.GB11450@wotan.suse.de>
References: <20090625194423.GB6472@mit.edu> <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com> <20090625203743.GD6472@mit.edu> <20090625212628.GO3385@webber.adilger.int> <20090625220504.GG6472@mit.edu> <4A43F60D.2040801@redhat.com> <20090626011155.GI6472@mit.edu> <Pine.LNX.4.64.0906260815260.18724@melkki.cs.Helsinki.FI> <20090626085629.GC12201@wotan.suse.de> <1246006681.27533.22.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	arjan@infradead.org, linux-kernel@vger.kernel.org,
	cl@linux-foundation.org, linux-ext4@vger.kernel.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065AbZFZJHj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Jun 2009 05:07:39 -0400
Content-Disposition: inline
In-Reply-To: <1246006681.27533.22.camel@penberg-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 26, 2009 at 11:58:01AM +0300, Pekka Enberg wrote:
> On Fri, 2009-06-26 at 10:56 +0200, Nick Piggin wrote:
> > On Fri, Jun 26, 2009 at 08:16:18AM +0300, Pekka Enberg wrote:
> > > Hi Ted,
> > > 
> > > On Thu, Jun 25, 2009 at 05:11:25PM -0500, Eric Sandeen wrote:
> > > > > ecryptfs used to do kmalloc(PAGE_CACHE_SIZE) & virt_to_page on that, and
> > > > > with SLUB + slub debug, that gave back non-aligned memory, causing
> > > > > eventual corruption ...
> > > 
> > > On Thu, 25 Jun 2009, Theodore Tso wrote:
> > > > Grumble.  Any chance we could add an kmem_cache option which requires
> > > > the memory to be aligned?  Otherwise we could rewrite our own sub-page
> > > > allocator in ext4 that only handled aligned filesystem block sizes
> > > > (i.e., 1k, 2k, 4k, etc.) but that would be really silly and be extra
> > > > code that really should be done once at core functionality.
> > > 
> > > We alredy have SLAB_HW_ALIGN but I wonder if this is a plain old bug in 
> > > SLUB. Christoph, Nick, don't we need something like this in the allocator? 
> > > Eric, does this fix your case?
> > 
> > Well I don't understand Ted's complaint. kmem_cache_create takes an
> > alignment argument.
> 
> Yes, but AFAICT, SLUB_DEBUG doesn't respect the given alignment without
> my patch.

Well your patch doesn't hurt (doesn't seem to make much sense to
use objsize rather than size when calculating alignment). But I
think alignment should still be calculated OK: calculate_alignemnt
will always return >= align, and so the next statement will
round up size to the correct alignment AFAICT.
