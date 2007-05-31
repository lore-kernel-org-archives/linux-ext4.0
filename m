From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] store RAID stride in superblock
Date: Thu, 31 May 2007 17:33:01 -0400
Message-ID: <20070531213301.GC13660@thunk.org>
References: <20070512020248.GQ6375@schatzie.adilger.int> <20070524114442.GA12526@schatzie.adilger.int> <46559E04.5060002@clusterfs.com> <20070531162109.GA23591@thunk.org> <20070531201902.GF5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rupesh Thakare <rupesh@clusterfs.com>, linux-ext4@vger.kernel.org,
	Kalpak Shah <kalpak@clusterfs.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51342 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbXEaVdE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2007 17:33:04 -0400
Content-Disposition: inline
In-Reply-To: <20070531201902.GF5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 31, 2007 at 02:19:02PM -0600, Andreas Dilger wrote:
> Ah, we've been doing it the other way around here.  It makes sense to keep
> the s_raid_stripe_width fields together.  I think this code is preliminary
> enough that nobody has actually started using it yet.  Can you please post
> what the end of ext2_super_block looks like (whether you decide to reorder
> the fields or not).

Oops, I just pushed a set of bugfixes to Linux that included the
superblock field reservations.  I was going back and forth about
whether to keep them together, or whether to keep the extra u16 s_pad
and then have to reserve another u16 field plus another u16 field for
MMP seconds field.  Since you guys had been talking about the MMP code
for longer period of time (I think you first made the proposal a few
months ago), I had assumed it had precedence (and had possibly already
been in use at some customer somewhere), so I used Kalpak's original
MMP superblock field reservations.  

I don't think it's worth changing at this point.  (If no one is using
it yet, it won't be too hard to switch around so we're all doing the
same thing. :-)  What is in the e2fsprogs hg repository as well as the
for_linus branch of ext4.git is:

	..
	__u16   s_raid_stride;		/* RAID stride */
	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
	__u64   s_mmp_block;            /* Block for multi-mount protection */
	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
	__u32   s_reserved[163];        /* Padding to the end of the block */
};

One question which does come to mind; is there any reason why we might
want to know the RAID level and/or the number of disks (as opposed to
just the stripe width)?  And has anyone investigated where there are
magic ioctl's or libdevmapper APi's so we can get the RAID parameters
automatically?  If so, patches so that mke2fs can get the information
automatically (as opposed to forcing the user to have to specify lots
of annoying options) would be most welcome....

						- Ted
