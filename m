From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] JBD slab cleanups
Date: Tue, 18 Sep 2007 19:19:20 -0700
Message-ID: <20070918191920.a2130a3c.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
	<20070902152801.GA19962@infradead.org>
	<Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
	<20070903134043.GB28962@infradead.org>
	<Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com>
	<20070903193308.GA7771@infradead.org>
	<1189796027.3841.6.camel@localhost.localdomain>
	<1190057391.3845.22.camel@localhost.localdomain>
	<1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
	<1190069851.6725.6.camel@localhost.localdomain>
	<20070918090407.GA671@infradead.org>
	<1190133347.3819.6.camel@localhost.localdomain>
	<1190138690.6528.23.camel@norville.austin.ibm.com>
	<1190163601.3819.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1190163601.3819.15.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 18 Sep 2007 18:00:01 -0700 Mingming Cao <cmm@us.ibm.com> wrote:

> JBD: Replace slab allocations with page cache allocations
> 
> JBD allocate memory for committed_data and frozen_data from slab. However
> JBD should not pass slab pages down to the block layer. Use page allocator pages instead. This will also prepare JBD for the large blocksize patchset.
> 
> 
> Also this patch cleans up jbd_kmalloc and replace it with kmalloc directly

__GFP_NOFAIL should only be used when we have no way of recovering
from failure.  The allocation in journal_init_common() (at least)
_can_ recover and hence really shouldn't be using __GFP_NOFAIL.

(Actually, nothing in the kernel should be using __GFP_NOFAIL.  It is 
there as a marker which says "we really shouldn't be doing this but
we don't know how to fix it").

So sometime it'd be good if you could review all the __GFP_NOFAILs in
there and see if we can remove some, thanks.
