From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v3 2/2] ext4: handle layout changes to pinned DAX mappings
Date: Thu, 5 Jul 2018 09:54:14 +1000
Message-ID: <20180704235414.GU19934@dastard>
References: <20180627212252.31032-3-ross.zwisler@linux.intel.com>
 <20180702172912.329-1-ross.zwisler@linux.intel.com>
 <20180704004923.GT19934@dastard>
 <20180704122723.lup2wovzb6u6ta6v@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180704122723.lup2wovzb6u6ta6v-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 04, 2018 at 02:27:23PM +0200, Jan Kara wrote:
> On Wed 04-07-18 10:49:23, Dave Chinner wrote:
> > On Mon, Jul 02, 2018 at 11:29:12AM -0600, Ross Zwisler wrote:
> > > Follow the lead of xfs_break_dax_layouts() and add synchronization between
> > > operations in ext4 which remove blocks from an inode (hole punch, truncate
> > > down, etc.) and pages which are pinned due to DAX DMA operations.
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > > Reviewed-by: Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> > > 
> > > Changes since v2:
> > >  * Added a comment to ext4_insert_range() explaining why we don't call
> > >    ext4_break_layouts(). (Jan)
> > 
> > Which I think is wrong and will cause data corruption.
> > 
> > > @@ -5651,6 +5663,11 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
> > >  			LLONG_MAX);
> > >  	if (ret)
> > >  		goto out_mmap;
> > > +	/*
> > > +	 * We don't need to call ext4_break_layouts() because we aren't
> > > +	 * removing any blocks from the inode.  We are just changing their
> > > +	 * offset by inserting a hole.
> > > +	 */
> > 
> > The entire point of these leases is so that a thrid party can
> > directly access the blocks underlying the file. That means they are
> > keeping their own file offset<->disk block mapping internally, and
> > they are assuming that it is valid for as long as they hold the
> > lease. If the filesystem modifies the extent map - even something
> > like a shift here which changes the offset<->disk block mapping -
> > the userspace app now has a stale mapping and so the lease *must be
> > broken* to tell it that it's mappings are now stale and it needs to
> > refetch them.
> 
> Well, ext4 has no real concept of leases and no pNFS support. And DAX
> requirements wrt consistency are much weaker than those of pNFS. This is
> mostly caused by the fact that calls like invalidate_mapping_pages() will
> flush offset<->pfn mappings DAX maintains in the radix tree automatically
> (similarly as it happens when page cache is used).

I'm more concerned about apps that use file leases behaving the same
way, not just the pNFS stuff. if we are /delegating file layouts/ to
3rd parties, then all filesystems *need* to behave the same way.
We've already defined those semantics with XFS - every time the
filesystem changes an extent layout in any way it needs to break
existing layout delegations...

> What Ross did just keeps ext4 + DAX behave similarly as ext4 + page cache
> does

Sure. But the issue I'm raising is that ext4 is not playing by the
same extent layout delegation rules that XFS has already defined for
3rd party use.

i.e. don't fuck up layout delegation behaviour consistency right
from the start just because "<this subset of functionality> is all
we need right now for ext4". All the filesystems should implement
the same semantics and behaviour right from the start, otherwise
we're just going to make life a misery for anyone who tries to use
layout delegations in future.

Haven't we learnt this lesson the hard way enough times already?

Cheers,

Dave.

-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
