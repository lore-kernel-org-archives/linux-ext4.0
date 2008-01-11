From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] New inode allocation for FLEX_BG meta-data groups.
Date: Fri, 11 Jan 2008 16:44:17 -0600
Message-ID: <20080111164417.328b7505@gara>
References: <20080111112818.0cdeadbd@gara>
	<20080111214658.GS3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47915 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759665AbYAKWoU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2008 17:44:20 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0BMiJiU015135
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 17:44:19 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0BMiJxd116908
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 17:44:19 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0BMiJlA026381
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 17:44:19 -0500
In-Reply-To: <20080111214658.GS3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 11 Jan 2008 14:46:58 -0700
Andreas Dilger <adilger@sun.com> wrote:

> On Jan 11, 2008  11:28 -0600, Jose R. Santos wrote:
> > @@ -127,6 +127,8 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
> >  		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
> >  	}
> >  
> > +	if (sbi->s_log_groups_per_flex)
> > +		return free_blocks;
> >  	return free_blocks - sbi->s_itb_per_group - 2;
> 
> To be honest, I think this is a wart in ext4_init_block_bitmap() that
> it returns the number of free blocks in the group.  That value should
> really be set at mke2fs or e2fsck time, and if the last group is marked
> BLOCK_UNINIT it gets the free blocks count wrong because it always starts
> with EXT4_BLOCKS_PER_GROUP().
> 
> The above patch may also be incorrect since there may be inode tables or
> bitmaps in the above group even in the case of FLEX_BG filesystems.
> 
> > +#define free_block_ratio 10
> > +
> > +static int find_group_flex(struct super_block *sb, struct inode *parent, ext4_group_t *best_group)
> > +{
> > +	n_fbg_groups = (sbi->s_groups_count + flex_size - 1) / flex_size;
> 
> Can be a shift?

You're right.  This should be:

n_fbg_groups = (sbi->s_groups_count + flex_size - 1) >> sbi->s_log_groups_per_flex;

> I would suggest doing some kind of testing to see how well this allocation
> policy is working.  We don't want to force all allocations contiguously at
> the start of the filesystem, or we end up with FAT...

I've done several IO patterns with multiple threads and all of my test
are either same or faster performance than with the regular allocator.
Im hopping that moving this to the patch queue will expose the
allocator to more tests.
 
> > +static int ext4_fill_flex_info(struct super_block *sb)
> > +{
> > +	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
> 
> Hmm, I guess no le*_to_cpu() because this is 8 bits?

Correct.

> > +
> > +	flex_group_count = (sbi->s_groups_count + groups_per_flex - 1) /
> > +		groups_per_flex;
> > +	sbi->s_flex_groups = kmalloc(flex_group_count *
> > +				     sizeof(struct flex_groups), GFP_KERNEL);
> > +	if (sbi->s_flex_groups == NULL) {
> > +		printk(KERN_ERR "EXT4-fs: not enough memory\n");
> 
> This should report "not enough memory for N flex groups" or something.

OK.
 
> > @@ -2105,6 +2154,13 @@ static int ext4_fill_super (struct super_block *sb,
> > +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> > +		if (!ext4_fill_flex_info(sb)) {
> > +			printk(KERN_ERR
> > +			       "EXT4-fs: unable to initialize flex_bg meta info!\n");
> > +			goto failed_mount2;
> 
> Should this be considered a fatal error, or could sbi->s_log_groups_per_flex
> just be set to 0 and the filesystem be used as-is (maybe with sub-optimal
> allocations or something)?  Otherwise this renders the filesystem unusable.

I thought about doing that but using a sub-optimal allocator would
permanently screw up the ondisk data locality.  Maybe mounting the
filesystem read-only would be more appropriate.

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 



-JRS
