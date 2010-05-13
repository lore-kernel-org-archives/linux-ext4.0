From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
Date: Thu, 13 May 2010 10:39:53 -0500
Message-ID: <1273765193.4353.157.camel@mulgrave.site>
References: <1273569821.21352.19.camel@pasglop>
	 <1273575478.21352.29.camel@pasglop>
	 <EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com>
	 <20100512222154.GA6841@shareable.org> <1273704431.21352.136.camel@pasglop>
	 <1273707708.15428.4.camel@mulgrave.site>
	 <1273709890.21352.141.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Saeed Bishara <saeed@marvell.com>,
	Nicolas Pitre <nico@marvell.com>,
	Jamie Lokier <jamie@shareable.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	"Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33719 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756262Ab0EMPj5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 May 2010 11:39:57 -0400
In-Reply-To: <1273709890.21352.141.camel@pasglop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2010-05-13 at 10:18 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2010-05-12 at 18:41 -0500, James Bottomley wrote:
> > > Which means that for coherent architectures that do not implement
> > > the ops->sync_* hooks, we are probably missing a barrier here... 
> > > 
> > > Thus if the above is expected to be a memory barrier, it's broken on
> > > cache coherent powerpc for example. On non-coherent powerpc, we do
> > cache
> > > flushes and those are implicit barriers.
> > 
> > Can you explain this a little more.  On a cache coherent machine, the
> > sync is a nop ... why would you want a nop to be any type of barrier?
> 
> Well if the driver can peek at the data after the sync, and have any
> kind of ordering guarantee that it doesn't get stale data (the load
> isn't prefetched or speculated early), that would require an mb() or at
> least rmb().

So the guarantee that it doesn't look at stale data after the sync on a
cache coherent machine means ordering the dma write to physical memory
with the subsequent cpu read ... no memory barrier can actually do that.
Usually this is done externally, by making sure the memory change is
visible before sending the irq that tells the driver it is there ... on
some numa systems, this can be a problem (hence the mmiowb/relaxed read
thing).

> It would seem sensible for drivers to assume that something like
> dma_cache_sync_for_cpu() thus has the semantics of an rmb() at least,
> no ?

I still don't see why ... I don't see how you'd ever get a read of the
area speculated before the event that tells the driver its OK to read
the memory.  In theory, I agree that it looks logical to require the
read never be speculated before the sync ... but in practice, I don't
see there ever being a problem with this since the sync isn't the event
that says the memory is safe to read.

James


