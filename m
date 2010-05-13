From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
Date: Thu, 13 May 2010 12:12:33 +0900
Message-ID: <20100513121302Z.fujita.tomonori@lab.ntt.co.jp>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com>
	<20100512222154.GA6841@shareable.org>
	<1273704431.21352.136.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jamie@shareable.org, santosh.shilimkar@ti.com,
	linux-ext4@vger.kernel.org, nico@marvell.com,
	linux-kernel@vger.kernel.org, jejb@parisc-linux.org,
	akpm@linux-foundation.org, saeed@marvell.com,
	linux-arm-kernel@lists.infradead.org, fujita.tomonori@lab.ntt.co.jp
To: benh@kernel.crashing.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:32770 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab0EMDNS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 May 2010 23:13:18 -0400
In-Reply-To: <1273704431.21352.136.camel@pasglop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 13 May 2010 08:47:11 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2010-05-12 at 23:21 +0100, Jamie Lokier wrote:
> > Shilimkar, Santosh wrote:
> > > There was a memory write barrier missing before the DMA descriptors 
> > > are handed over to DMA controller.
> > 
> > On that note, are the cache flush functions implicit memory barriers?
> 
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

X86 OOSTORE uses a memory barrier dma_sync_single_for_device (seems
that some mips archs also use it and do cache operations).

I think that the DMA-API says that

- dma_sync_single_for_device() makes sure the data ready for DMA.

- dma_sync_single_for_cpu() makes sure that drivers doesn't get the
  stale data after DMA.

I guess, it means if an architecture need a memory barrier (not only
cache operations) to guarantee the above, the architecture needs to
take care of it.
