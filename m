From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH][RFC] ext4: avoid taking down_read(&grp->alloc_sem)
Date: Mon, 14 Feb 2011 15:04:05 +0530
Message-ID: <8739nrc642.fsf@linux.vnet.ibm.com>
References: <AANLkTimUmo5v14oKodaBKFtZPEHHuR9kZS5OSVtEFj2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:50743 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1BNJeJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 04:34:09 -0500
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp07.in.ibm.com (8.14.4/8.13.1) with ESMTP id p1E9Y6o8026233
	for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 15:04:06 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p1E9Y68Q2924760
	for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 15:04:06 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p1E9Y6hv011941
	for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 20:34:06 +1100
In-Reply-To: <AANLkTimUmo5v14oKodaBKFtZPEHHuR9kZS5OSVtEFj2c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 9 Feb 2011 12:05:11 +0200, "Amir G." <amir73il@users.sourceforge.net> wrote:
> Hi Aneesh,
> 
> As you are signed off on most of the recent alloc_sem related code changes,
> can you please comment on the patch below, which tries to avoid taking
> the read lock most of the times on a 4K block fs.
> 
> Can anyone tell what performance impact (if any) will be caused by avoiding
> the read lock on most allocations? group spin lock will still be taken, but for
> much shorter periods of time (cycles).
> 
> Any ideas how this patch can be properly tested?

A quick check says the changes are correct. But i am not sure whether we
want to conditionalize these locks unless they appear as highly
contented locks in a profile. 

> 
> Thanks,
> Amir.
> 
> grp->alloc_sem is used to synchronize buddy cache users with buddy cache init
> of other groups that use the same buddy cache page and with adding blocks to
> group on online resize.
> 
> When blocks_per_page <= 2, each group has it's own private buddy cache page
> so taking the read lock for every allocation is futile and can be avoided for
> every group, but the last one.
> 
> The write lock is taken in ext4_mb_init_group() and in ext4_add_groupblocks()
> to synchronize the buddy cache init of a group on first time allocation after
> mount and after extending the last group.
> 
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> ---
>  fs/ext4/mballoc.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 1b3256b..22a5251 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1160,7 +1160,15 @@ ext4_mb_load_buddy(struct super_block *sb,
> ext4_group_t group,
>  	e4b->bd_group = group;
>  	e4b->bd_buddy_page = NULL;
>  	e4b->bd_bitmap_page = NULL;
> -	e4b->alloc_semp = &grp->alloc_sem;
> +	/*
> +	 * We only need to take the read lock if other groups share the buddy
> +	 * page with this group or if blocks may be added to this (last) group
> +	 * by ext4_group_extend().
> +	 */
> +	if (blocks_per_page > 2 || group == sbi->s_groups_count - 1)


If we can say groups_per_page > 1 that would make it more clear. 

> +		e4b->alloc_semp = &grp->alloc_sem;
> +	else
> +		e4b->alloc_semp = NULL;
> 
>  	/* Take the read lock on the group alloc
>  	 * sem. This would make sure a parallel
> @@ -1169,7 +1177,8 @@ ext4_mb_load_buddy(struct super_block *sb,
> ext4_group_t group,
>  	 * till we are done with allocation
>  	 */
>  repeat_load_buddy:
> -	down_read(e4b->alloc_semp);
> +	if (e4b->alloc_semp)
> +		down_read(e4b->alloc_semp);
> 
>  	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
>  		/* we need to check for group need init flag
> @@ -1177,7 +1186,8 @@ repeat_load_buddy:
>  		 * that new blocks didn't get added to the group
>  		 * when we are loading the buddy cache
>  		 */
> -		up_read(e4b->alloc_semp);
> +		if (e4b->alloc_semp)
> +			up_read(e4b->alloc_semp);
>  		/*
>  		 * we need full data about the group
>  		 * to make a good selection
> @@ -1277,7 +1287,8 @@ err:
>  	e4b->bd_bitmap = NULL;
> 
>  	/* Done with the buddy cache */
> -	up_read(e4b->alloc_semp);
> +	if (e4b->alloc_semp)
> +		up_read(e4b->alloc_semp);
>  	return ret;
>  }
> 

-aneesh
