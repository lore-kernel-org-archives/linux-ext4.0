From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Use superblock s_raid_stripe_width as stripe
	size during block allocation.
Date: Thu, 10 Jan 2008 09:58:59 +0530
Message-ID: <20080110042859.GB8271@skywalker>
References: <1199898469-10369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080109233627.GB3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:48536 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbYAJE3L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 23:29:11 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m0A4Tv9J000318
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 15:29:57 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0A4T9Au2654382
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 15:29:09 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0A4T8Ku002609
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 15:29:09 +1100
Content-Disposition: inline
In-Reply-To: <20080109233627.GB3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 09, 2008 at 04:36:27PM -0700, Andreas Dilger wrote:
> On Jan 09, 2008  22:37 +0530, Aneesh Kumar K.V wrote:
> > The stipe size used during block allocation is calculated as below.
> > a) if we specify a stripe=<value> option using mount time. Use that value.
> > b) if not use the value specified in super block.
> > b) If the value specfied at mount time is greater than blocks per group use
> > the value specified ini the super block.
> 
> What if the value on disk is also bad?  I'd add (after the second 'b' :-):
> 
> d) if s_stripe is still > s_blocks_per_group try s_raid_stride
> e) if s_stripe is still > s_blocks_per_group use 0

But i guess mke2fs and tune2fs should validate the value of
s_raid_stripe_width and s_raid_stride. Both of them should be less that
blocks per group. Should I add extra check in the kernel for them ?

> 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/super.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index db1edc8..10330eb 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -2136,6 +2136,16 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
> >  	sbi->s_rsv_window_head.rsv_alloc_hit = 0;
> >  	sbi->s_rsv_window_head.rsv_goal_size = 0;
> >  	ext4_rsv_window_add(sb, &sbi->s_rsv_window_head);
> > +	/*
> > +	 * set the stripe size. If we have specified it via mount option, then
> > +	 * use the mount option value. If the value specified at mount time is
> > +	 * greater than the blocks per group use the super block value.
> > +	 * Allocator needs it be less than blocks per group.
> > +	 */
> > +	if (!sbi->s_stripe ||
> > +			sbi->s_stripe >= sbi->s_blocks_per_group) {
> 

So what do you think should it be > or >=. Looking at the mballoc I
guess it should work with stripe size equal to blocks per group. I am
not sure how efficient the allocation would be though.


-aneesh
