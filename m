From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] fix bb_prealloc_list corruption due to wrong group
	locking
Date: Mon, 16 Mar 2009 22:42:40 +0530
Message-ID: <20090316171240.GA16242@skywalker>
References: <49BAD6D9.3010505@redhat.com> <49BE82A9.4000407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:44527 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZCPRNU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Mar 2009 13:13:20 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id n2GHD2O9012282
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 22:43:02 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2GHD0AB3903670
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 22:43:00 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n2GHCphL024136
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 22:42:51 +0530
Content-Disposition: inline
In-Reply-To: <49BE82A9.4000407@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 16, 2009 at 11:47:37AM -0500, Eric Sandeen wrote:
> This is for Red Hat bug 490026,
> EXT4 panic, list corruption in ext4_mb_new_inode_pa
> 
> ext4_lock_group(sb, group) is supposed to protect this list for
> each group, and a common code flow to remove an album is like
> this:
> 
>     ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
>     ext4_lock_group(sb, grp);
>     list_del(&pa->pa_group_list);
>     ext4_unlock_group(sb, grp);
> 
> so it's critical that we get the right group number back for
> this prealloc context, to lock the right group (the one 
> associated with this pa) and prevent concurrent list manipulation.
> 
> however, ext4_mb_put_pa() passes in (pa->pa_pstart - 1) with a 
> comment, /* -1 is to protect from crossing allocation group */
> 
> This makes sense for the group_pa, where pa_pstart is advanced
> by the length which has been used (in ext4_mb_release_context()),
> and when the entire length has been used, pa_pstart has been
> advanced to the first block of the next group.
> 
> However, for inode_pa, pa_pstart is never advanced; it's just
> set once to the first block in the group and not moved after
> that.  So in this case, if we subtract one in ext4_mb_put_pa(),
> we are actually locking the *previous* group, and opening the
> race with the other threads which do not subtract off the extra
> block.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> ndex: linux-2.6/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/mballoc.c
> +++ linux-2.6/fs/ext4/mballoc.c
> @@ -3589,6 +3589,7 @@ static void ext4_mb_put_pa(struct ext4_a
>  			struct super_block *sb, struct ext4_prealloc_space *pa)
>  {
>  	ext4_group_t grp;
> +	ext4_fsblk_t grp_blk;
> 
>  	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0)
>  		return;
> @@ -3603,8 +3604,12 @@ static void ext4_mb_put_pa(struct ext4_a
>  	pa->pa_deleted = 1;
>  	spin_unlock(&pa->pa_lock);
> 
> -	/* -1 is to protect from crossing allocation group */
> -	ext4_get_group_no_and_offset(sb, pa->pa_pstart - 1, &grp, NULL);
> +	grp_blk = pa->pa_pstart;
> +	/* If linear, pa_pstart is in the next block group when pa is used up */


	/* If linear, pa_pstart may be in the next block group when pa is used up */
			       ^^^^^^^^^^


> +	if (pa->pa_linear)
> +		grp_blk--;
> +
> +	ext4_get_group_no_and_offset(sb, grp_blk, &grp, NULL);
> 
>  	/*
>  	 * possible race:
> 

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
