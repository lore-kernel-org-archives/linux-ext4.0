From: Nick Piggin <npiggin@suse.de>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Date: Tue, 30 Jun 2009 09:59:12 +0200
Message-ID: <20090630075912.GB11980@wotan.suse.de>
References: <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com> <20090625203743.GD6472@mit.edu> <20090625212628.GO3385@webber.adilger.int> <20090625220504.GG6472@mit.edu> <4A43F60D.2040801@redhat.com> <20090626011155.GI6472@mit.edu> <Pine.LNX.4.64.0906260815260.18724@melkki.cs.Helsinki.FI> <20090626085629.GC12201@wotan.suse.de> <1246006681.27533.22.camel@penberg-laptop> <alpine.DEB.1.10.0906291703020.21956@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
	Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	arjan@infradead.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Lameter <cl@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZF3H7K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jun 2009 03:59:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906291703020.21956@gentwo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 29, 2009 at 05:06:37PM -0400, Christoph Lameter wrote:
> On Fri, 26 Jun 2009, Pekka Enberg wrote:
> 
> > Yes, but AFAICT, SLUB_DEBUG doesn't respect the given alignment without
> > my patch.
> 
> The size parameter to calculate_alignment has no relevance unless the size
> is smaller than half of the alignment. Then for some reason we do not
> properly align the stuff. I never liked that....

It is properly aligned, if it was not, then it would be a bug. It
should always align to *at least* the requested alignment.

SLAB_HWCACHE_ALIGN is defined to align the object such that it occupies
the minimal number of cache lines. This is not subjective thing to
like or dislike, but just fact because that is how it was implemented
from the start and that is what callers expect.

If you want to minimise false sharing, then normal way would be to
request internode cacheline alignment, right? This is very widely
used.

