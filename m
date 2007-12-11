From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Tue, 11 Dec 2007 10:08:12 -0600
Message-ID: <20071211100812.557b923b@gara>
References: <20071206161045.1054bbe7@gara>
	<20071207101428.GE3214@webber.adilger.int>
	<20071207095212.037ca68a@gara>
	<20071211110033.GQ3214@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39119 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbXLKSS0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Dec 2007 13:18:26 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lBBIING3008175
	for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2007 13:18:23 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBBIINag455612
	for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2007 13:18:23 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBBIINqA026560
	for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2007 13:18:23 -0500
In-Reply-To: <20071211110033.GQ3214@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 11 Dec 2007 04:00:33 -0700
Andreas Dilger <adilger@sun.com> wrote:

> On Dec 07, 2007  09:52 -0600, Jose R. Santos wrote:
> > Andreas Dilger <adilger@sun.com> wrote:
> > > There is no particular reason that this ratio needs to be "*100", it could
> > > just as easily be a fraction of 256 and make the multiply into a shift.
> > > The free_block_ratio would be 26 in that case.
> > 
> > The idea here is to reserve 10% (free_block_ratio) of free blocks in a
> > flexbg for allocation of new files and expansion of existing one.  The
> > "*100" make the math here easy but this still something that need to be
> > tune further.  I'm sure we can do this in a series of shifts, just
> > haven't spent the time thinking of a clever way to do this.
> 
> This is a common misconception for code to have 10% mean 10 / 100.  It
> is just as good to have 26/256

I understand that part, but my point is that changing the multiply to
256 doesn't do anything to eliminate the divide by blocks_per_flex.
Give that is more common to have an arch with no divide instruction
than one with no multiply, it seems more important to take care of the
divide by blocks_per_flex rather than the multiply by 100.

We could store the blocks_per_flex_bits in the sbi to do this but the
last flexbg is not guarantied to be the same size as the other flexbg
so it needs to be treated differently.

Hum...  Now that I think of it, the last flexbg is not treated
differently on the current patch either.  Looks like I found a bug. :)

> > > > @@ -622,7 +631,9 @@ struct ext4_super_block {
> > > >  	__le16  s_mmp_interval;         /* # seconds to wait in MMP checking */
> > > >  	__le64  s_mmp_block;            /* Block for multi-mount protection */
> > > >  	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
> > > > -	__u32   s_reserved[163];        /* Padding to the end of the block */
> > > > +	__le16	s_flex_bg_size;		/* FLEX_BG group size */
> > > 
> > > Shouldn't this be "s_flex_bg_bits"?
> > 
> > I debated whether to store this as the s_flex_bg_size and calculate the
> > bits during the filesystem mount time or just stored the bit in the
> > super block to begging with.  The reason I stored the size is that it
> > seemed more in line with the other fields in the super block.  I don't
> > mind either way since this is more of a style issue, although saving an
> > extra 8bits in the super block may be good enough reason to change it. 
> 
> I'd think being able to avoid the divide for every inode allocation is more
> important than 8 bits in the superblock.

We already avoid the divide since what we store in the sbi IS the bits
which are calculated at mount time for each fs.  Base on the other
fields in the super block struct, I decided to put explicit size of the
flexbg in the super block.  The kernel code can decide how best to use
that number which in this case its used to calculate the number of bits
in order to avoid doing divides.

So this is really a styling issue in how to record data in the super
block.  The only technical issue with this is whether it's important to
save those extra 8 bits in the super block struct.
 
> > > My preference would be to have "if (EXT2_HAS_INCOMPAT...) { ... } else {"
> > > (i.e. add { } for the first part) since there are { } on the second part,
> > > and it is just easier to read.
> > 
> > Mine too, but checkpatch complained about this. :)
> 
> Time to fix checkpatch it would seem.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 



-JRS
