From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Date: Thu, 25 Jun 2009 17:11:25 -0500
Message-ID: <4A43F60D.2040801@redhat.com>
References: <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com> <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com> <20090625203743.GD6472@mit.edu> <20090625212628.GO3385@webber.adilger.int> <20090625220504.GG6472@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundat
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60369 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZFYWMT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2009 18:12:19 -0400
In-Reply-To: <20090625220504.GG6472@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Jun 25, 2009 at 11:26:28PM +0200, Andreas Dilger wrote:
>> IIRC there was also a good reason for this in the past, related to
>> the buffers being submitted to the block device layer, and if they
>> were allocated from the slab cache with CONFIG_DEBUG_SLAB or something
>> similar enabled the buffer would be misaligned and cause grief.
> 
> So what does SLAB/SLUB/SLOB do if we create a slab cache which is a
> power of two?  Can one of the allocators still return misaligned
> blocks of memory in some circumstances?
> 
> 						- Ted

ecryptfs used to do kmalloc(PAGE_CACHE_SIZE) & virt_to_page on that, and
with SLUB + slub debug, that gave back non-aligned memory, causing
eventual corruption ...

-Eric

