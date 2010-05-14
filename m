From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
	88f5182)
Date: Fri, 14 May 2010 18:59:27 +0100
Message-ID: <20100514175927.GA18107@n2100.arm.linux.org.uk>
References: <1273569821.21352.19.camel@pasglop> <1273575478.21352.29.camel@pasglop> <EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com> <20100512222154.GA6841@shareable.org> <1273704431.21352.136.camel@pasglop> <20100512230841.GA10090@n2100.arm.linux.org.uk> <20100514174153.GB10133@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Saeed Bishara <saeed@marvell.com>,
	Nicolas Pitre <nico@marvell.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	"Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100514174153.GB10133@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 14, 2010 at 06:41:53PM +0100, Jamie Lokier wrote:
> Russell King - ARM Linux wrote:
> > On Thu, May 13, 2010 at 08:47:11AM +1000, Benjamin Herrenschmidt wrote:
> > > Now, in the case at hand, which is my ARM based NAS, I believe this
> > > is non cache-coherent and thus uses cache flush ops. I don't know ARM
> > > well enough but I would expect these to be implicit barriers. Russell ?
> > > Nico ?
> > 
> > ARMv5 doesn't have a weak memory ordering model, and doesn't have any
> > memory barrier instructions.
> 
> It does have buffered writes, doesn't it?  Are they always flushed by
> the cache flush ops?

Surprisingly, for DMA it's something we've always done.  Odd that.
