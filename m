From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Thu, 05 Jun 2008 07:55:41 -0700
Message-ID: <1212677741.3645.44.camel@localhost.localdomain>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker>
	 <20080605032220.GC10488@mit.edu>  <20080605084329.GB8942@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:38932 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYFEOzu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 10:55:50 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m55EtnSF018442
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 10:55:49 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m55EtlTK075322
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 08:55:47 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m55EtkSp030610
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 08:55:47 -0600
In-Reply-To: <20080605084329.GB8942@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-06-05 at 14:13 +0530, Aneesh Kumar K.V wrote:
> On Wed, Jun 04, 2008 at 11:22:20PM -0400, Theodore Tso wrote:
> > when I moved this patch to the beginning of the unstable patch queue,
> > it didn't apply.  When I tried to look at it, my head started
> > spinning.  The patch applied to the wrong function, apparently,
> > because there is so much code duplication "patch" got confused.  I
> > can't blame it, though, because *I* got confused.  
> > 
> > fs/ext4/balloc.c is a complete disaster right now.  We have:
> > 
> > ext4_new_blocks_old()
> > ext4_new_meta_block()
> > ext4_new_meta_blocks()
> > ext4_new_blocks()
> > 
> > ... and without any comments, it is extremely impenetrable.  Someone
> > needs to document what the heck all of the various functions have to
> > do with each other, when they get used (i.e., with which mount options). 
> > 

One more thing, I feel we should clean up inode.c, move the functions
related to non extent file allocation from inode.c into balloc.c, and
try to keep balloc.c the single file to handle allocation for non extent
files. 

> > Why aren't we factoring out the last three into a single function?  
> 
> Something like below ? . I will send a final patch once I get the
> patchqueu updated. I am not able to reach repo.or.cz currently.
> 
looks good, a few comment
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index bd18ceb..abbc500 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1656,7 +1656,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
>  }
> 
>  /**
> - * ext4_new_blocks_old() -- core block(s) allocation function
> + * ext4_orlov_new_blocks() -- core block(s) allocation function

what is orlov means? this is core function for non extent based without
mballoc block allocation, right? 

>   * @handle:		handle to this transaction
>   * @inode:		file inode
>   * @goal:		given target block(filesystem wide)
> @@ -1669,7 +1669,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
>   * any specific goal block.
>   *
>   */
> -ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
> +ext4_fsblk_t ext4_orlov_new_blocks(handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t goal, unsigned long *count, int *errp)
>  {
>  	struct buffer_head *bitmap_bh = NULL;
> @@ -1942,88 +1942,68 @@ ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
>  	return 0;
>  }
> 
> -ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
> -		ext4_fsblk_t goal, int *errp)
> +static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
> +				ext4_lblk_t iblock, ext4_fsblk_t goal,
> +				unsigned long *count, int *errp, int meta)
>  {
>  	struct ext4_allocation_request ar;
>  	ext4_fsblk_t ret;
> 
>  	if (!test_opt(inode->i_sb, MBALLOC)) {
> -		unsigned long count = 1;
> -		ret = ext4_new_blocks_old(handle, inode, goal, &count, errp);
> +		ret = ext4_orlov_new_blocks(handle, inode, goal, count, errp);
>  		return ret;
>  	}
> 
>  	memset(&ar, 0, sizeof(ar));
> +	/* Fill with neighbour allocated blocks */
> +	ar.lleft  = 0;
> +	ar.pleft  = 0;
> +	ar.lright = 0;
> +	ar.pright = 0;
> +
>  	ar.inode = inode;
>  	ar.goal = goal;
> -	ar.len = 1;
> +	ar.len = *count;
> +	ar.logical = iblock;
> +	if (S_ISREG(inode->i_mode) && !meta)
> +		ar.flags = EXT4_MB_HINT_DATA;
> +	else
> +		/* disable in-core preallocation for non-regular files */
> +		ar.flags = 0;
>  	ret = ext4_mb_new_blocks(handle, &ar, errp);
> +	*count = ar.len;
>  	/*
>  	 * Account for the allocated meta blocks
>  	 */
> -	if (!(*errp)) {
> +	if (!(*errp) && meta) {
>  		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  	}
> -
>  	return ret;
>  }
> +
> +
> +ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
> +		ext4_fsblk_t goal, int *errp)
> +{
> +	unsigned long count = 1;
> +	return do_blk_alloc(handle, inode, 0, goal, &count, errp, 1);
> +}
> +
>  ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>  		ext4_fsblk_t goal, unsigned long *count, int *errp)
>  {
> -	struct ext4_allocation_request ar;
> -	ext4_fsblk_t ret;
> -
> -	if (!test_opt(inode->i_sb, MBALLOC)) {
> -		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
> -		return ret;
> -	}
> -
> -	memset(&ar, 0, sizeof(ar));
> -	ar.inode = inode;
> -	ar.goal = goal;
> -	ar.len = *count;
> -	ret = ext4_mb_new_blocks(handle, &ar, errp);
> -	*count = ar.len;
> -	return ret;
> +	return do_blk_alloc(handle, inode, 0, goal, count, errp, 1);
>  }
> 
>  ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
>  				ext4_lblk_t iblock, ext4_fsblk_t goal,
>  				unsigned long *count, int *errp)
>  {
> -	struct ext4_allocation_request ar;
> -	ext4_fsblk_t ret;
> -
> -	if (!test_opt(inode->i_sb, MBALLOC)) {
> -		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
> -		return ret;
> -	}
> -
> -	memset(&ar, 0, sizeof(ar));
> -	/* Fill with neighbour allocated blocks */
> -	ar.lleft  = 0;
> -	ar.pleft  = 0;
> -	ar.lright = 0;
> -	ar.pright = 0;
> -
> -	ar.inode = inode;
> -	ar.goal = goal;
> -	ar.len = *count;
> -	ar.logical = iblock;
> -	if (S_ISREG(inode->i_mode))
> -		ar.flags = EXT4_MB_HINT_DATA;
> -	else
> -		/* disable in-core preallocation for non-regular files */
> -		ar.flags = 0;
> -	ret = ext4_mb_new_blocks(handle, &ar, errp);
> -	*count = ar.len;
> -	return ret;
> +	return do_blk_alloc(handle, inode, iblock, goal, count, errp, 0);
>  }
> 
> -
>  /**
>   * ext4_count_free_blocks() -- count filesystem free blocks
>   * @sb:		superblock
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 19d48dd..c401253 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1049,7 +1049,7 @@ extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>  extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
>  					ext4_lblk_t iblock, ext4_fsblk_t goal,
>  					unsigned long *count, int *errp);
> -extern ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
> +extern ext4_fsblk_t ext4_orlov_new_blocks(handle_t *handle, struct inode *inode,
>  			ext4_fsblk_t goal, unsigned long *count, int *errp);
>  extern ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
>  						ext4_fsblk_t nblocks);
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 09922ae..a810a21 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4048,7 +4048,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>  	sbi = EXT4_SB(sb);
> 
>  	if (!test_opt(sb, MBALLOC)) {
> -		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
> +		block = ext4_orlov_new_blocks(handle, ar->inode, ar->goal,
>  					    &(ar->len), errp);
>  		return block;
>  	}

when we get to ext4_mb_new_blocks, don't we already tested MBALLOC is
turned on?

