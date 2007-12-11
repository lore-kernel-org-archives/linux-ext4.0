From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Tue, 11 Dec 2007 04:00:33 -0700
Message-ID: <20071211110033.GQ3214@webber.adilger.int>
References: <20071206161045.1054bbe7@gara> <20071207101428.GE3214@webber.adilger.int> <20071207095212.037ca68a@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:60757 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXLKLAf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Dec 2007 06:00:35 -0500
Content-Disposition: inline
In-Reply-To: <20071207095212.037ca68a@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 07, 2007  09:52 -0600, Jose R. Santos wrote:
> Andreas Dilger <adilger@sun.com> wrote:
> > There is no particular reason that this ratio needs to be "*100", it could
> > just as easily be a fraction of 256 and make the multiply into a shift.
> > The free_block_ratio would be 26 in that case.
> 
> The idea here is to reserve 10% (free_block_ratio) of free blocks in a
> flexbg for allocation of new files and expansion of existing one.  The
> "*100" make the math here easy but this still something that need to be
> tune further.  I'm sure we can do this in a series of shifts, just
> haven't spent the time thinking of a clever way to do this.

This is a common misconception for code to have 10% mean 10 / 100.  It
is just as good to have 26/256

> > > @@ -622,7 +631,9 @@ struct ext4_super_block {
> > >  	__le16  s_mmp_interval;         /* # seconds to wait in MMP checking */
> > >  	__le64  s_mmp_block;            /* Block for multi-mount protection */
> > >  	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
> > > -	__u32   s_reserved[163];        /* Padding to the end of the block */
> > > +	__le16	s_flex_bg_size;		/* FLEX_BG group size */
> > 
> > Shouldn't this be "s_flex_bg_bits"?
> 
> I debated whether to store this as the s_flex_bg_size and calculate the
> bits during the filesystem mount time or just stored the bit in the
> super block to begging with.  The reason I stored the size is that it
> seemed more in line with the other fields in the super block.  I don't
> mind either way since this is more of a style issue, although saving an
> extra 8bits in the super block may be good enough reason to change it. 

I'd think being able to avoid the divide for every inode allocation is more
important than 8 bits in the superblock.

> > My preference would be to have "if (EXT2_HAS_INCOMPAT...) { ... } else {"
> > (i.e. add { } for the first part) since there are { } on the second part,
> > and it is just easier to read.
> 
> Mine too, but checkpatch complained about this. :)

Time to fix checkpatch it would seem.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
