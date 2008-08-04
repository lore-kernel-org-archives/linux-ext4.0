From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Problem with delayed allocation
Date: Mon, 4 Aug 2008 21:03:31 +0530
Message-ID: <20080804153331.GD9397@skywalker>
References: <E1KPNNn-0003IN-0B@closure.thunk.org> <20080804145249.GA9397@skywalker> <20080804152730.GC9397@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:48700 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750AbYHDPdp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 11:33:45 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m74FXhPQ018204
	for <linux-ext4@vger.kernel.org>; Mon, 4 Aug 2008 21:03:43 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m74FXhSD1630226
	for <linux-ext4@vger.kernel.org>; Mon, 4 Aug 2008 21:03:43 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m74FXgJN028757
	for <linux-ext4@vger.kernel.org>; Mon, 4 Aug 2008 21:03:42 +0530
Content-Disposition: inline
In-Reply-To: <20080804152730.GC9397@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Mon, Aug 04, 2008 at 08:57:30PM +0530, Aneesh Kumar K.V wrote:
> On Mon, Aug 04, 2008 at 08:22:49PM +0530, Aneesh Kumar K.V wrote:
> > On Sat, Aug 02, 2008 at 04:07:19PM -0400, Theodore Ts'o wrote:
> > > 
> > > Apparently __fsync_super(), which is called right before remounting a
> > > filesystem read-only, isn't working correctly.  To reproduce, create a
> > > script which does this:
> > > 
> > > #!/bin/sh
> > > DEVICE=/dev/closure/test
> > > mke2fs -t ext4dev /dev/closure/test
> > > mount $DEVICE /mnt
> > > cd /mnt
> > > tar xfj /var/tmp/linux-2.6.26.tar.gz  <----- or some really big file
> > > du -s
> > > cd ..
> > > mount -o remount,ro /mnt
> > > sync
> > > dmesg > /tmp/dmesg.out  <----- note all of the ext4_da_writepages error messages
> > > umount /mnt
> > > du -s /mnt
> > > sync
> > > mount $DEVICE /mnt
> > > du -s /mnt    <---  note that size of the unpacked hierarcy is much smaller
> > > 
> > > This doesn't happen if the ext4 filesystem is mounted with nodelalloc,
> > > so I assume the problem is in ext4_da_writepages().
> > > 
> > 
> > Can you try this patch and see if it makes any difference ?
> > 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 25adfc3..5a8a2d3 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -518,6 +518,7 @@ void generic_sync_sb_inodes(struct super_block *sb,
> >  		spin_lock(&inode_lock);
> >  		if (wbc->nr_to_write <= 0) {
> >  			wbc->more_io = 1;
> > +			printk(KERN_CRIT "Breaking from the %s loop\n", __func__);
> >  			break;
> >  		}
> >  		if (!list_empty(&sb->s_more_io))
> > @@ -611,6 +612,8 @@ void sync_inodes_sb(struct super_block *sb, int wait)
> >  			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
> >  			nr_dirty + nr_unstable;
> >  	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
> > +	wbc.nr_to_write =  LONG_MAX;
> > +
> >  	sync_sb_inodes(sb, &wbc);
> >  }
> >  
> 
> 
> I guess this could be the reason. I am not hitting the error during
> remount, ro with this change. But I have other changes also accumulated
> as a part of rewrite.
> 
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4a50445..ecabe77 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2225,8 +2288,10 @@ static int ext4_da_writepages(struct address_space *mapping,
>  	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
>  		return 0;
>  
> +#if 0
>  	if (wbc->nr_to_write > mapping->nrpages)
>  		wbc->nr_to_write = mapping->nrpages;
> +#endif
>  
>  
>  	if (!wbc->range_cyclic) {

The reason why you are able to reproduce it with the linus tree is
because of

/*
 * set the max dirty pages could be write at a time
 * to fit into the reserved transaction credits
 */
if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
	wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;



-aneesh
