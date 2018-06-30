From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] ext4: handle layout changes to pinned DAX mappings
Date: Sat, 30 Jun 2018 11:12:32 +1000
Message-ID: <20180630011232.GP19934@dastard>
References: <20180627212252.31032-1-ross.zwisler@linux.intel.com>
 <20180627212252.31032-3-ross.zwisler@linux.intel.com>
 <20180629120223.oaslngsvspnwf4ae@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180629120223.oaslngsvspnwf4ae-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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

On Fri, Jun 29, 2018 at 02:02:23PM +0200, Lukas Czerner wrote:
> On Wed, Jun 27, 2018 at 03:22:52PM -0600, Ross Zwisler wrote:
> > Follow the lead of xfs_break_dax_layouts() and add synchronization between
> > operations in ext4 which remove blocks from an inode (hole punch, truncate
> > down, etc.) and pages which are pinned due to DAX DMA operations.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > ---
> >  fs/ext4/ext4.h     |  1 +
> >  fs/ext4/extents.c  | 12 ++++++++++++
> >  fs/ext4/inode.c    | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/ext4/truncate.h |  4 ++++
> >  4 files changed, 63 insertions(+)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 0b127853c584..34bccd64d83d 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -2460,6 +2460,7 @@ extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
> >  extern int ext4_inode_attach_jinode(struct inode *inode);
> >  extern int ext4_can_truncate(struct inode *inode);
> >  extern int ext4_truncate(struct inode *);
> > +extern int ext4_break_layouts(struct inode *);
> >  extern int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length);
> >  extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
> >  extern void ext4_set_inode_flags(struct inode *);
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 0057fe3f248d..a6aef06f455b 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4820,6 +4820,13 @@ static long ext4_zero_range(struct file *file, loff_t offset,
> >  		 * released from page cache.
> >  		 */
> >  		down_write(&EXT4_I(inode)->i_mmap_sem);
> > +
> > +		ret = ext4_break_layouts(inode);
> > +		if (ret) {
> > +			up_write(&EXT4_I(inode)->i_mmap_sem);
> > +			goto out_mutex;
> > +		}
> > +
> >  		ret = ext4_update_disksize_before_punch(inode, offset, len);
> >  		if (ret) {
> >  			up_write(&EXT4_I(inode)->i_mmap_sem);
> > @@ -5493,6 +5500,11 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
> >  	 * page cache.
> >  	 */
> >  	down_write(&EXT4_I(inode)->i_mmap_sem);
> > +
> > +	ret = ext4_break_layouts(inode);
> > +	if (ret)
> > +		goto out_mmap;
> 
> Hi,
> 
> don't we need to do the same for ext4_insert_range() since we're about
> to truncate_pagecache() as well ?
> 
> /thinking out loud/
> Xfs seems to do this before every fallocate operation, but in ext4
> it does not seem to be needed at least for simply allocating falocate...

The PNFS client may have mapped a hole over the range we are about
to allocate. Hence it's mapping will be stale, and it needs to remap
the range.

i.e. any change to the extent list needs to break the lease of any
client that may have a cached layout on that inode. i.e. it's not
just extent removal that we are protecting against - we are trying
to ensure clients using leases to access blocks directly remain
coherent with the filesystem's extent map. Hence any potential
change to the extent map requires breaking the lease....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
