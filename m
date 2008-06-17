From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Tue, 17 Jun 2008 16:18:04 +0530
Message-ID: <20080617104804.GA13550@skywalker>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker> <20080605032220.GC10488@mit.edu> <20080605084329.GB8942@skywalker> <1212677741.3645.44.camel@localhost.localdomain> <4855E0F2.9070207@cn.fujitsu.com> <48578721.4020205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, Theodore Tso <tytso@mit.edu>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:41130 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYFQKsj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 06:48:39 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5HAlxPN018967
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 20:47:59 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5HAmaib205806
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 20:48:36 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5HAmZNJ001820
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 20:48:35 +1000
Content-Disposition: inline
In-Reply-To: <48578721.4020205@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 17, 2008 at 05:42:57PM +0800, Shen Feng wrote:
> 
> 
> Shen Feng Wrote:
> > 
> > Mingming Cao Wrote:
> >> On Thu, 2008-06-05 at 14:13 +0530, Aneesh Kumar K.V wrote:
> >>> On Wed, Jun 04, 2008 at 11:22:20PM -0400, Theodore Tso wrote:
> >>>> when I moved this patch to the beginning of the unstable patch queue,
> >>>> it didn't apply.  When I tried to look at it, my head started
> >>>> spinning.  The patch applied to the wrong function, apparently,
> >>>> because there is so much code duplication "patch" got confused.  I
> >>>> can't blame it, though, because *I* got confused.  
> >>>>
> > 
> > ...snip...
> > 
> >>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> >>> index 09922ae..a810a21 100644
> >>> --- a/fs/ext4/mballoc.c
> >>> +++ b/fs/ext4/mballoc.c
> >>> @@ -4048,7 +4048,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
> >>>  	sbi = EXT4_SB(sb);
> >>>
> >>>  	if (!test_opt(sb, MBALLOC)) {
> >>> -		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
> >>> +		block = ext4_orlov_new_blocks(handle, ar->inode, ar->goal,
> >>>  					    &(ar->len), errp);
> >>>  		return block;
> >>>  	}
> >> when we get to ext4_mb_new_blocks, don't we already tested MBALLOC is
> >> turned on?
> >>
> > 
> > ext4_ext_get_blocks calls ext4_mb_new_blocks. So we have to check this.
> > So maybe ext4_ext_get_blocks should call ext4_new_blocks and 
> > we can remove this check.
> > 
> 
> How about this patch?
> I tested it with bonnie++ and ltp fs test using mballoc and nonomballoc
> options.

NACK. you need the ar.lleft/pleft and ar.lright/pright values so that
mballoc can merge the requests properly. Look at
ext4_mb_normalize_request . So you can't do the below change.


> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> ---
>  fs/ext4/extents.c |   25 +++++++++----------------
>  fs/ext4/mballoc.c |    6 ------
>  2 files changed, 9 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 47929c4..3f6be32 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2528,7 +2528,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  	ext4_fsblk_t goal, newblock;
>  	int err = 0, depth, ret;
>  	unsigned long allocated = 0;
> -	struct ext4_allocation_request ar;
> +	ext4_lblk_t lleft, lright;
> +	ext4_fsblk_t pleft, pright;
> 
>  	__clear_bit(BH_New, &bh_result->b_state);
>  	ext_debug("blocks %u/%lu requested for inode %u\n",
> @@ -2653,12 +2654,12 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  		ext4_init_block_alloc_info(inode);
> 
>  	/* find neighbour allocated blocks */
> -	ar.lleft = iblock;
> -	err = ext4_ext_search_left(inode, path, &ar.lleft, &ar.pleft);
> +	lleft = iblock;
> +	err = ext4_ext_search_left(inode, path, &lleft, &pleft);
>  	if (err)
>  		goto out2;
> -	ar.lright = iblock;
> -	err = ext4_ext_search_right(inode, path, &ar.lright, &ar.pright);
> +	lright = iblock;
> +	err = ext4_ext_search_right(inode, path, &lright, &pright);
>  	if (err)
>  		goto out2;
> 
> @@ -2685,16 +2686,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  		allocated = max_blocks;
> 
>  	/* allocate new block */
> -	ar.inode = inode;
> -	ar.goal = ext4_ext_find_goal(inode, path, iblock);
> -	ar.logical = iblock;
> -	ar.len = allocated;
> -	if (S_ISREG(inode->i_mode))
> -		ar.flags = EXT4_MB_HINT_DATA;
> -	else
> -		/* disable in-core preallocation for non-regular files */
> -		ar.flags = 0;
> -	newblock = ext4_mb_new_blocks(handle, &ar, &err);
> +	goal = ext4_ext_find_goal(inode, path, iblock);
> +	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
>  	if (!newblock)
>  		goto out2;
>  	ext_debug("allocate new block: goal %llu, found %llu/%lu\n",
> @@ -2702,7 +2695,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
> 
>  	/* try to insert new extent into found leaf and return */
>  	ext4_ext_store_pblock(&newex, newblock);
> -	newex.ee_len = cpu_to_le16(ar.len);
> +	newex.ee_len = cpu_to_le16(allocated);
>  	if (create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
>  		ext4_ext_mark_uninitialized(&newex);
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex);
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index c9900aa..bc82d39 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4010,12 +4010,6 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>  	sb = ar->inode->i_sb;
>  	sbi = EXT4_SB(sb);
> 
> -	if (!test_opt(sb, MBALLOC)) {
> -		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
> -					    &(ar->len), errp);
> -		return block;
> -	}
> -
>  	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
>  		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
>  		ar->len--;
> -- 1.5.5.1 
