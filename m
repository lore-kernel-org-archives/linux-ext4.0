From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Thu, 31 May 2007 16:03:07 -0600
Message-ID: <20070531220307.GJ5181@schatzie.adilger.int>
References: <20070512020248.GQ6375@schatzie.adilger.int> <20070524114442.GA12526@schatzie.adilger.int> <46559E04.5060002@clusterfs.com> <20070531162109.GA23591@thunk.org> <20070531201902.GF5181@schatzie.adilger.int> <20070531213301.GC13660@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rupesh Thakare <rupesh@clusterfs.com>, linux-ext4@vger.kernel.org,
	Kalpak Shah <kalpak@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:52957 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbXEaWDK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 May 2007 18:03:10 -0400
Content-Disposition: inline
In-Reply-To: <20070531213301.GC13660@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 31, 2007  17:33 -0400, Theodore Tso wrote:
> Oops, I just pushed a set of bugfixes to Linux that included the
> superblock field reservations.

Oh well.

> What is in the e2fsprogs hg repository ... is:
> 
> 	..
> 	__u16   s_raid_stride;		/* RAID stride */
> 	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
> 	__u64   s_mmp_block;            /* Block for multi-mount protection */
> 	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
> 	__u32   s_reserved[163];        /* Padding to the end of the block */
> };

We're updating our patches to be based on the new HG code.

> One question which does come to mind; is there any reason why we might
> want to know the RAID level and/or the number of disks (as opposed to
> just the stripe width)?

Not so far.  The raid_stride is for bitmap placement (and could also be
used for alignment of random IOs to avoid making 2 disks busy when 1
would do).  The raid_stripe_width is the amount that delalloc+mballoc
will use for allocations+writes to avoid read-modify-write of RAID stripes.
It doesn't really matter what the RAID level is.

> And has anyone investigated where there are
> magic ioctl's or libdevmapper APi's so we can get the RAID parameters
> automatically?  If so, patches so that mke2fs can get the information
> automatically (as opposed to forcing the user to have to specify lots
> of annoying options) would be most welcome....

For now we will specify this via mke2fs or tune2fs for existing filesystems.
The XFS folks mentioned they have a library to extract this info for linux
devices (e.g. DM, MD, etc), but of course that still won't work for e.g.
external RAID devices.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
