From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Use superblock s_raid_stripe_width as stripe size
	during block allocation.
Date: Thu, 10 Jan 2008 01:22:23 -0700
Message-ID: <20080110082223.GF3351@webber.adilger.int>
References: <1199898469-10369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080109233627.GB3351@webber.adilger.int> <20080110042859.GB8271@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:60651 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYAJIWY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jan 2008 03:22:24 -0500
Content-Disposition: inline
In-Reply-To: <20080110042859.GB8271@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 10, 2008  09:58 +0530, Aneesh Kumar K.V wrote:
> > d) if s_stripe is still > s_blocks_per_group try s_raid_stride
> > e) if s_stripe is still > s_blocks_per_group use 0
> 
> But i guess mke2fs and tune2fs should validate the value of
> s_raid_stripe_width and s_raid_stride. Both of them should be less that
> blocks per group. Should I add extra check in the kernel for them ?

It's true that mke2fs and tune2fs should validate this, but it is also
possible to become corrupted, and e2fsck doesn't fix it yet nor can it
make a good estimate of the right value.

> > > +	if (!sbi->s_stripe ||
> > > +			sbi->s_stripe >= sbi->s_blocks_per_group) {
> > 
> 
> So what do you think should it be > or >=. Looking at the mballoc I
> guess it should work with stripe size equal to blocks per group. I am
> not sure how efficient the allocation would be though.

I think if s_stripe == s_blocks_per_group that is fine...  For 1kB block
filesystem that is only 8MB in size.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
