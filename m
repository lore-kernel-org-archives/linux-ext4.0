From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Fri, 26 Mar 2010 14:27:26 +0530
Message-ID: <87sk7nv4sp.fsf@linux.vnet.ibm.com>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
	<20100322012758.GE11560@thunk.org>
	<ac8f92701003230547p3e56a9cdnff8ce874535db117@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40595 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0CZI5d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 04:57:33 -0400
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id o2Q8vWIo014972
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 19:57:32 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2Q8pT6E1630266
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 19:51:29 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2Q8vUaw012645
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 19:57:31 +1100
In-Reply-To: <ac8f92701003230547p3e56a9cdnff8ce874535db117@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 23 Mar 2010 20:47:39 +0800, jing zhang <zj.barak@gmail.com> wrote:
> 2010/3/22, tytso@mit.edu <tytso@mit.edu>:
> > On Sun, Mar 21, 2010 at 10:01:06PM +0800, jing zhang wrote:
> >> From: Jing Zhang <zj.barak@gmail.com>
> >>
> >> Date: Sun Mar 21 21:59:35     2010
> >>
> >> Cc: Theodore Ts'o <tytso@mit.edu>
> >> Cc: Andreas Dilger <adilger@sun.com>
> >> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> >> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> >>
> >> ---
> >>
> >> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> >> +++ ext4_mm_leak/mballoc3.c	2010-03-21 21:37:18.000000000 +0800
> >> @@ -2360,6 +2360,24 @@ err_freesgi:
> >>  	return -ENOMEM;
> >>  }
> >>
> >> +static void ext4_mb_destroy_backend(struct super_block *sb)
> >> +{
> >> +	ext4_group_t ngroups = ext4_get_groups_count(sb);
> >> +	ext4_group_t i;
> >> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> >> +	int j;
> >> +	int num_meta_group_infos = (ngroups + EXT4_DESC_PER_BLOCK(sb) -1)
> >> +					>> EXT4_DESC_PER_BLOCK_BITS(sb);
> >> +	for (i = 0; i < ngroups; i++)
> >> +		kfree(ext4_get_group_info(sb, i));
> >> +
> >> +	for (j = 0; j < num_meta_group_infos; j++)
> >> +		kfree(sbi->s_group_info[j]);
> >> +
> >> +	kfree(sbi->s_group_info);
> >> +	iput(sbi->s_buddy_cache);
> >> +}
> >> +
> >
> > It would be better if this could be done by making ext4_mb_release()
> > more flexible, and then calling ext4_mb_release() if there is an error
> > setting up the data structures in ext4_mb_init().
> >
> > 						- Ted
> >
> 
> Yeah, Ted, going through ext4_mb_release() is clearer.
> 
> ---
> 
> diff --git a/linux-2.6.32/fs/ext4/mballoc.c b/ext4_mm_leak/mballoc3.c
> index bba1282..99ca2de 100644
> --- a/linux-2.6.32/fs/ext4/mballoc.c
> +++ b/ext4_mm_leak/mballoc3.c
> @@ -2417,8 +2417,7 @@ int ext4_mb_init(struct super_block *sb, int
> needs_recovery)
> 
>  	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
>  	if (sbi->s_locality_groups == NULL) {
> -		kfree(sbi->s_mb_offsets);
> -		kfree(sbi->s_mb_maxs);
> +		ext4_mb_release(sb);

We may want to make sure that we can safely call ext4_mb_release that
early. what i would suggest is to move s_locality_group allocation
before ext4_mb_init. that makes error handling easy



>  		return -ENOMEM;
>  	}
>  	for_each_possible_cpu(i) {
> @@ -2511,7 +2510,8 @@ int ext4_mb_release(struct super_block *sb)
>  				atomic_read(&sbi->s_mb_discarded));
>  	}
> 
> -	free_percpu(sbi->s_locality_groups);
> +	if (sbi->s_locality_groups)
> +		free_percpu(sbi->s_locality_groups);
>  	if (sbi->s_proc)
>  		remove_proc_entry("mb_groups", sbi->s_proc);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-aneesh
