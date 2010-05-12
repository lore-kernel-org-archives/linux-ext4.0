From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
Date: Wed, 12 May 2010 18:41:48 -0500
Message-ID: <1273707708.15428.4.camel@mulgrave.site>
References: <1273569821.21352.19.camel@pasglop>
	 <1273575478.21352.29.camel@pasglop>
	 <EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com>
	 <20100512222154.GA6841@shareable.org>  <1273704431.21352.136.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jamie Lokier <jamie@shareable.org>,
	"Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Nicolas Pitre <nico@marvell.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Saeed Bishara <saeed@marvell.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41953 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147Ab0ELXlv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 May 2010 19:41:51 -0400
In-Reply-To: <1273704431.21352.136.camel@pasglop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2010-05-13 at 08:47 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2010-05-12 at 23:21 +0100, Jamie Lokier wrote:
> > Shilimkar, Santosh wrote:
> > > There was a memory write barrier missing before the DMA descriptors 
> > > are handed over to DMA controller.
> > 
> > On that note, are the cache flush functions implicit memory barriers?

Not exactly ... they *should* be stream ordered with respect to accesses
to the memory they're flushing (which isn't the same thing, and no-one
ever went broke overestimating the stupidity of chip designers, but if a
flush instruction needs explicit ordering, I'd expect that to be built
into the arch layer).

> (Adding Fujita on CC)
> 
> That's a very good question. The generic inline implementation of
> dma_sync_* is:
> 
> static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
> 					   size_t size,
> 					   enum dma_data_direction dir)
> {
> 	struct dma_map_ops *ops = get_dma_ops(dev);
> 
> 	BUG_ON(!valid_dma_direction(dir));
> 	if (ops->sync_single_for_cpu)
> 		ops->sync_single_for_cpu(dev, addr, size, dir);
> 	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
> }
> 
> Which means that for coherent architectures that do not implement
> the ops->sync_* hooks, we are probably missing a barrier here... 
> 
> Thus if the above is expected to be a memory barrier, it's broken on
> cache coherent powerpc for example. On non-coherent powerpc, we do cache
> flushes and those are implicit barriers.

Can you explain this a little more.  On a cache coherent machine, the
sync is a nop ... why would you want a nop to be any type of barrier?

James


