From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Fri, 26 Mar 2010 14:24:38 +0530
Message-ID: <87tys3v4xd.fsf@linux.vnet.ibm.com>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53887 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0CZIyp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 04:54:45 -0400
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp06.au.ibm.com (8.14.3/8.13.1) with ESMTP id o2Q8sXoY002883
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 19:54:33 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2Q8meE11667288
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 19:48:40 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2Q8sgom017111
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 19:54:43 +1100
In-Reply-To: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 21 Mar 2010 22:01:06 +0800, jing zhang <zj.barak@gmail.com> wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Sun Mar 21 21:59:35     2010
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> 
> ---
> 
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc3.c	2010-03-21 21:37:18.000000000 +0800
> @@ -2360,6 +2360,24 @@ err_freesgi:
>  	return -ENOMEM;
>  }
> 
> +static void ext4_mb_destroy_backend(struct super_block *sb)
> +{
> +	ext4_group_t ngroups = ext4_get_groups_count(sb);
> +	ext4_group_t i;
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	int j;
> +	int num_meta_group_infos = (ngroups + EXT4_DESC_PER_BLOCK(sb) -1)
> +					>> EXT4_DESC_PER_BLOCK_BITS(sb);
> +	for (i = 0; i < ngroups; i++)
> +		kfree(ext4_get_group_info(sb, i));
> +
> +	for (j = 0; j < num_meta_group_infos; j++)
> +		kfree(sbi->s_group_info[j]);
> +
> +	kfree(sbi->s_group_info);
> +	iput(sbi->s_buddy_cache);
> +}
> +
>  int ext4_mb_init(struct super_block *sb, int needs_recovery)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> @@ -2419,6 +2437,7 @@ int ext4_mb_init(struct super_block *sb,
>  	if (sbi->s_locality_groups == NULL) {
>  		kfree(sbi->s_mb_offsets);
>  		kfree(sbi->s_mb_maxs);
> +		ext4_mb_destroy_backend(sb);
>  		return -ENOMEM;
>  	}
>  	for_each_possible_cpu(i) {

A better fix would be move s_locality_group allocation before
ext4_mb_init_backend

-aneesh
