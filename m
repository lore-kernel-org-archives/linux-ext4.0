From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG in ext4 with 2.6.37-rc1
Date: Thu, 4 Nov 2010 09:56:46 +1100
Message-ID: <20101103225646.GC9169@dastard>
References: <20101102202013.GA3861@elliptictech.com>
 <4CD1A67D.5060909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CD1A67D.5060909@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 03, 2010 at 02:14:21PM -0400, Eric Sandeen wrote:
> On 11/2/10 4:20 PM, Nick Bowler wrote:
> > The following BUG occurred today while compiling gcc, with 2.6.37-rc1+.
> > More precisely, commit 7fe19da4ca38 ("preempt: fix kernel build with
> > !CONFIG_BKL") with http://permalink.gmane.org/gmane.linux.nfs/36521
> > applied on top.  It basically took out the whole system.
> > 
> >   ------------[ cut here ]------------
> >   kernel BUG at /scratch_space/linux-2.6/fs/ext4/page-io.c:146!
> 
> 138 ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
> 139 {
> 140         ext4_io_end_t *io = NULL;
> 141
> 142         io = kmem_cache_alloc(io_end_cachep, flags);
> 143         if (io) {
> 144                 memset(io, 0, sizeof(*io));
> 145                 io->inode = igrab(inode);
> 146                 BUG_ON(!io->inode);
> 
> igrab can fail if it's being torn down:
> 
>                 /*
>                  * Handle the case where s_op->clear_inode is not been
>                  * called yet, and somebody is calling igrab
>                  * while the inode is getting freed.
>                  */
>                 inode = NULL;
> 
> and boom.

Oh, nasty.

FWIW, the XFS code this was copied from doesn't have this problem
because the struct inode is not tagged for reclaim in
->destroy_inode until all writeback IO is completed.  We keep a
separate active ioend reference count in the struct xfs_inode, and
the inode is never freed while there are still active IO references
(see the xfs_ioend_wait() call in xfs_fs_destroy_inode).

Hence the XFS ->writepage path does not need to take inode
references to handle the possibility of an inode being freed from
under it because the inode lifecycle model guarantees it
cannot occur.  Perhaps ext4 needs to copy more from XFS.... ;)

BTW, io_end_cachep() probably should use a mempool (like the
equivalent XFS ioend slab cache), otherwise ext4 won't be able to
make writeback progress in OOM conditions and will avoid needing to
handle ENOMEM errors in ->writepage.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
