From: Theodore Tso <tytso@mit.edu>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Date: Thu, 25 Jun 2009 18:05:04 -0400
Message-ID: <20090625220504.GG6472@mit.edu>
References: <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com> <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com> <20090625203743.GD6472@mit.edu> <20090625212628.GO3385@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	penberg@cs.helsinki.fi, arjan@infradead.org,
	linux-kernel@vger.kernel.org, cl@linux-foundation.org,
	npiggin@suse.de, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46274 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbZFYWF1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2009 18:05:27 -0400
Content-Disposition: inline
In-Reply-To: <20090625212628.GO3385@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 25, 2009 at 11:26:28PM +0200, Andreas Dilger wrote:
> IIRC there was also a good reason for this in the past, related to
> the buffers being submitted to the block device layer, and if they
> were allocated from the slab cache with CONFIG_DEBUG_SLAB or something
> similar enabled the buffer would be misaligned and cause grief.

So what does SLAB/SLUB/SLOB do if we create a slab cache which is a
power of two?  Can one of the allocators still return misaligned
blocks of memory in some circumstances?

						- Ted
