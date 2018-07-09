From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 2/2] ext4: handle layout changes to pinned DAX mappings
Date: Mon, 9 Jul 2018 14:33:47 +0200
Message-ID: <20180709123347.nw3ixr64prgk7sxz@quack2.suse.cz>
References: <20180627212252.31032-3-ross.zwisler@linux.intel.com>
 <20180702172912.329-1-ross.zwisler@linux.intel.com>
 <20180704004923.GT19934@dastard>
 <20180704122723.lup2wovzb6u6ta6v@quack2.suse.cz>
 <20180704235414.GU19934@dastard> <20180705035952.GB5699@magnolia>
 <20180705165310.GB22200@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180705165310.GB22200-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Thu 05-07-18 10:53:10, Ross Zwisler wrote:
> On Wed, Jul 04, 2018 at 08:59:52PM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 05, 2018 at 09:54:14AM +1000, Dave Chinner wrote:
> > > On Wed, Jul 04, 2018 at 02:27:23PM +0200, Jan Kara wrote:
> > > > On Wed 04-07-18 10:49:23, Dave Chinner wrote:
> > > > > On Mon, Jul 02, 2018 at 11:29:12AM -0600, Ross Zwisler wrote:
> > > > > > Follow the lead of xfs_break_dax_layouts() and add synchronization between
> > > > > > operations in ext4 which remove blocks from an inode (hole punch, truncate
> > > > > > down, etc.) and pages which are pinned due to DAX DMA operations.
> > > > > > 
> > > > > > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > > > > Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > > > > > Reviewed-by: Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > > > ---
> > > > > > 
> > > > > > Changes since v2:
> > > > > >  * Added a comment to ext4_insert_range() explaining why we don't call
> > > > > >    ext4_break_layouts(). (Jan)
> > > > > 
> > > > > Which I think is wrong and will cause data corruption.
> > > > > 
> > > > > > @@ -5651,6 +5663,11 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
> > > > > >  			LLONG_MAX);
> > > > > >  	if (ret)
> > > > > >  		goto out_mmap;
> > > > > > +	/*
> > > > > > +	 * We don't need to call ext4_break_layouts() because we aren't
> > > > > > +	 * removing any blocks from the inode.  We are just changing their
> > > > > > +	 * offset by inserting a hole.
> > > > > > +	 */
> > 
> > Does calling ext4_break_layouts from insert range not work?
> > 
> > It's my understanding that file leases work are a mechanism for the
> > filesystem to delegate some of its authority over physical space
> > mappings to "client" software.  AFAICT it's used for mmap'ing pmem
> > directly into userspace and exporting space on shared storage over
> > pNFS.  Some day we might use the same mechanism for the similar things
> > that RDMA does, or the swapfile code since that's essentially how it
> > works today.
> > 
> > The other part of these file leases is that the filesystem revokes them
> > any time it wants to perform a mapping operation on a file.  This breaks
> > my mental model of how leases work, and if you commit to this for ext4
> > then I'll have to remember that leases are different between xfs and
> > ext4.  Worse, since the reason for skipping ext4_break_layouts seems to
> > be the implementation detail that "DAX won't care", then someone else
> > wiring up pNFS/future RDMA/whatever will also have to remember to put it
> > back into ext4 or else kaboom.
> > 
> > Granted, Dave said all these things already, but I actually feel
> > strongly enough to reiterate.
> 
> Jan, would you like me to call ext4_break_layouts() in ext4_insert_range() to
> keep the lease mechanism consistent between ext4 and XFS, or would you prefer
> the s/ext4_break_layouts()/ext4_dax_unmap_pages()/ rename?

Let's just call it from ext4_insert_range(). I think the simple semantics
Dave and Darrick defend is more maintainable and insert range isn't really
performance critical operation.

The question remains whether equivalent of BREAK_UNMAP is really required
also for allocation of new blocks using fallocate. Because that doesn't
really seem fundamentally different from normal write which uses
BREAK_WRITE for xfs_break_layouts(). And that it more often used operation
so bothering with GUP synchronization when not needed could hurt there.
Dave, Darrick?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
