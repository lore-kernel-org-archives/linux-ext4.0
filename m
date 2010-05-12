From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
	88f5182)
Date: Thu, 13 May 2010 08:47:11 +1000
Message-ID: <1273704431.21352.136.camel@pasglop>
References: <1273569821.21352.19.camel@pasglop>
	<1273575478.21352.29.camel@pasglop>
	<EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com>
	<20100512222154.GA6841@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Saeed Bishara <saeed@marvell.com>, Nicolas Pitre <nico@marvell.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Shilimkar,
	Santosh" <santosh.shilimkar@ti.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20100512222154.GA6841@shareable.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2010-05-12 at 23:21 +0100, Jamie Lokier wrote:
> Shilimkar, Santosh wrote:
> > There was a memory write barrier missing before the DMA descriptors 
> > are handed over to DMA controller.
> 
> On that note, are the cache flush functions implicit memory barriers?

(Adding Fujita on CC)

That's a very good question. The generic inline implementation of
dma_sync_* is:

static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
					   size_t size,
					   enum dma_data_direction dir)
{
	struct dma_map_ops *ops = get_dma_ops(dev);

	BUG_ON(!valid_dma_direction(dir));
	if (ops->sync_single_for_cpu)
		ops->sync_single_for_cpu(dev, addr, size, dir);
	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
}

Which means that for coherent architectures that do not implement
the ops->sync_* hooks, we are probably missing a barrier here... 

Thus if the above is expected to be a memory barrier, it's broken on
cache coherent powerpc for example. On non-coherent powerpc, we do cache
flushes and those are implicit barriers.

Now, in the case at hand, which is my ARM based NAS, I believe this
is non cache-coherent and thus uses cache flush ops. I don't know ARM
well enough but I would expect these to be implicit barriers. Russell ?
Nico ?

IE. You may have found a bug here though I don't know whether it's the
bug we are hitting right now :-)

Cheers,
Ben.
