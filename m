From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ext4: fix delalloc retry loop logic v2
Date: Thu, 04 Feb 2010 16:59:25 +0530
Message-ID: <87y6j9qlwq.fsf@linux.vnet.ibm.com>
References: <87zl3qrwnx.fsf@openvz.org> <87sk9irve0.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:40630 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0BDL3c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Feb 2010 06:29:32 -0500
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp04.in.ibm.com (8.14.3/8.13.1) with ESMTP id o14BTTvw009103
	for <linux-ext4@vger.kernel.org>; Thu, 4 Feb 2010 16:59:29 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o14BTT9L2879580
	for <linux-ext4@vger.kernel.org>; Thu, 4 Feb 2010 16:59:29 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o14BTSMC022145
	for <linux-ext4@vger.kernel.org>; Thu, 4 Feb 2010 22:29:28 +1100
In-Reply-To: <87sk9irve0.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 03 Feb 2010 22:07:03 +0300, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Dmitry Monakhov <dmonakhov@openvz.org> writes:
> 
> > Theodore please review this patch ASAP, currently ext4+quota is 
> > fatally broken due to your patch. Christmas holidays when you
> > submit your patch is not good time for good review, IMHO
> > i was too lazy to review it carefully.
> > Testcase is trivial it is enough just hit a quota barrier.
> > dmon$ set-quota-limit /mnt id=dmon --bsoft=1000 --bsoft=1000
> > dmon$ dd if=/dev/zefo of=/mnt/file 
> >
> > kernel BUG at fs/jbd2/transaction.c:1027!
> OOps, i'm sorry. seems that i've send wrong patch version
> the only difference is follows:
> -	dqretry = (ret == -EDQUOT) || EXT4_I(inode)->i_reserved_meta_blocks;
> +	dqretry = (ret == -EDQUOT) && EXT4_I(inode)->i_reserved_meta_blocks;
> Correct version attached.
> From 3dd53f88470fdc4ec3f06da34cfc760fa8359be8 Mon Sep 17 00:00:00 2001
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> Date: Wed, 3 Feb 2010 22:03:17 +0300
> Subject: [PATCH 2/2] ext4: fix delalloc retry loop logic -v2
> 
> Current delalloc write path is broken:
> ext4_da_write_begin()
>   ext4_journal_start(inode, 1);  -> current->journal != NULL
>   block_write_begin
>     ext4_da_get_block_prep()
>       ext4_da_reserve_space()
>         ext4_should_retry_alloc() -> deadlock
> 	write_inode_now() -> BUG_ON due to lack of journal credits
> 
> Bug was partly introduced by following commit:
>   0637c6f4135f592f094207c7c21e7c0fc5557834
>   ext4: Patch up how we claim metadata blocks for quota purposes
> In order to preserve retry logic and eliminate bugs we have to
> move retry loop to ext4_da_write_begin()
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |   41 ++++++++++++++++++-----------------------
>  1 files changed, 18 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2d3fe4d..bd9e573 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1815,7 +1815,6 @@ static int ext4_journalled_write_end(struct file *file,
>   */
>  static int ext4_da_reserve_space(struct inode *inode, sector_t lblock)
>  {
> -	int retries = 0;
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	unsigned long md_needed, md_reserved;
> @@ -1825,7 +1824,6 @@ static int ext4_da_reserve_space(struct inode *inode, sector_t lblock)
>  	 * in order to allocate nrblocks
>  	 * worse case is one extent per block
>  	 */
> -repeat:
>  	spin_lock(&ei->i_block_reservation_lock);
>  	md_reserved = ei->i_reserved_meta_blocks;
>  	md_needed = ext4_calc_metadata_amount(inode, lblock);
> @@ -1836,27 +1834,11 @@ repeat:
>  	 * later. Real quota accounting is done at pages writeout
>  	 * time.
>  	 */
> -	if (vfs_dq_reserve_block(inode, md_needed + 1)) {
> -		/* 
> -		 * We tend to badly over-estimate the amount of
> -		 * metadata blocks which are needed, so if we have
> -		 * reserved any metadata blocks, try to force out the
> -		 * inode and see if we have any better luck.
> -		 */
> -		if (md_reserved && retries++ <= 3)
> -			goto retry;
> +	if (vfs_dq_reserve_block(inode, md_needed + 1))
>  		return -EDQUOT;
> -	}
> 
>  	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
>  		vfs_dq_release_reservation_block(inode, md_needed + 1);
> -		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
> -		retry:
> -			if (md_reserved)
> -				write_inode_now(inode, (retries == 3));
> -			yield();
> -			goto repeat;
> -		}
>  		return -ENOSPC;
>  	}
>  	spin_lock(&ei->i_block_reservation_lock);
> @@ -3033,7 +3015,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
>  			       loff_t pos, unsigned len, unsigned flags,
>  			       struct page **pagep, void **fsdata)
>  {
> -	int ret, retries = 0;
> +	int ret, dqretry, retries = 0;
>  	struct page *page;
>  	pgoff_t index;
>  	unsigned from, to;
> @@ -3090,9 +3072,22 @@ retry:
>  			ext4_truncate_failed_write(inode);
>  	}
> 
> -	if (!(flags & EXT4_AOP_FLAG_NORETRY) &&
> -		ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> -		goto retry;
> +	dqretry = (ret == -EDQUOT) && EXT4_I(inode)->i_reserved_meta_blocks;
> +	if ( !(flags & EXT4_AOP_FLAG_NORETRY) &&
> +		(ret == -ENOSPC || dqretry) &&
> +		ext4_should_retry_alloc(inode->i_sb, &retries)) {
> +		if (dqretry) {
> +			/*
> +			 * We tend to badly over-estimate the amount of
> +			 * metadata blocks which are needed, so if we have
> +			 * reserved any metadata blocks, try to force out the
> +			 * inode and see if we have any better luck.
> +			 */
> +			write_inode_now(inode, (retries == 3));
> +		}
> +		yield();
> + 		goto retry;
> +	}
>  out:
>  	return ret;
>  }


Where is EXT4_AOP_FLAG_NORETRY defined ?. I have submitted a different
version of the patch and it is already upstream with commit
1db913823c0f8360fccbd24ca67eb073966a5ffd


-aneesh
