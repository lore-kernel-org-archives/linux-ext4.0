From: Jan Kara <jack@suse.cz>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
Date: Fri, 22 Jun 2012 02:12:02 +0200
Message-ID: <20120622001202.GG11645@quack.suse.cz>
References: <4FDEC3C2.4060909@secunet.com>
 <x49fw9smohy.fsf@segfault.boston.devel.redhat.com>
 <4FE0155A.6010404@secunet.com>
 <x49ehpbjiyp.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jaxboe@fusionio.com>,
	Nick Piggin <npiggin@kernel.dk>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49ehpbjiyp.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 19-06-12 13:43:26, Jeff Moyer wrote:
> Torsten Hilbrich <torsten.hilbrich@secunet.com> writes:
> 
> > The system where I reproduced the problem upstream is an amd64 based
> > ubuntu 12.04 installation. I used both v3.3.8 and v3.4 for reproducing.
> >
> > The partition layout is the following:
> >
> > ======================================================================
> >
> > Disk /dev/sda: 120.0 GB, 120034123776 bytes
> > 255 heads, 63 sectors/track, 14593 cylinders, total 234441648 sectors
> > Units = sectors of 1 * 512 = 512 bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disk identifier: 0x1669c708
> >
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/sda1   *          63    86285114    43142526   83  Linux
> > /dev/sda2       216797175   234436544     8819685   82  Linux swap / Solaris
> > /dev/sda3        86285115    87088364      401625   83  Linux
> > /dev/sda4        87088426   216797174    64854374+   5  Extended
> > /dev/sda5        87088428    91104614     2008093+  83  Linux
> > /dev/sda6        91104678   216797174    62846248+  8e  Linux LVM
> >
> > Partition table entries are not in disk order
> 
> OK, got it to reproduce, thanks for the info.  The attached patch fixed
> the problem for me.
> 
> Note, though, that the patch doesn't make sense to me.  blkdev_max_block
> returns i_size_read(blkdev_inode) >> block_size.  This should be the
> *size* of the block device, not the max block.  The code in
> fs/block_device.c uses the return value in two different ways!
> 
> static int
> blkdev_get_block(struct inode *inode, sector_t iblock,
>                 struct buffer_head *bh, int create)
> {
>         if (iblock >= blkdev_max_block(I_BDEV(inode))) {
> 
> Here, the return value from blkdev_max_block is interpreted as the size
> of the device, so actually max_block + 1.
> 
> static int
> blkdev_get_blocks(struct inode *inode, sector_t iblock,
>                 struct buffer_head *bh, int create)
> {
>         sector_t end_block = blkdev_max_block(I_BDEV(inode));
>         unsigned long max_blocks = bh->b_size >> inode->i_blkbits;
> 
>         if ((iblock + max_blocks) > end_block) {
> 
> Here, the return value is treated as the maximum addressable block
> number.  Given the fact that I had to modify init_page_buffers to treat
> the return value from blkdev_max_block as the maximum addressable block,
> I clearly have something wrong with my logic.  Nick, Jens, care to set
> my head straight?
  I think it can have something to do with the fact that the partition size
is not a multiple of 4k (i.e. expected block size)?

  BTW: blkdev_max_block() is a terrible name for something that intends to
return size in blocks...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
