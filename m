From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 2/3] ext4: Drop EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE
 flag
Date: Wed, 06 Jan 2010 11:50:35 -0800
Message-ID: <1262807435.17552.27.camel@mingming-laptop>
References: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1262805762-6862-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:35601 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab0AFTu5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jan 2010 14:50:57 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o06JnYjH013214
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jan 2010 12:49:34 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id o06JogDs038828
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jan 2010 12:50:44 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o06Jobhj027956
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jan 2010 12:50:39 -0700
In-Reply-To: <1262805762-6862-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2010-01-07 at 00:52 +0530, Aneesh Kumar K.V wrote:
> We should update reserve space if it is delalloc buffer
> and thtat is indicated by EXT4_GET_BLOCKS_DELALLOC_RESERVE flag.
> So use EXT4_GET_BLOCKS_DELALLOC_RESERVE in place of
> EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE
> 

That's a nice cleanup. With the old name, it confused me a bit on your
first patch where I thought even direct IO gets unnecessary reservation
update.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/ext4.h    |    7 ++-----
>  fs/ext4/extents.c |    4 ++--
>  fs/ext4/inode.c   |    8 ++++----
>  3 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b98de17..874d169 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -361,14 +361,11 @@ struct ext4_new_group_data {
>  	   so set the magic i_delalloc_reserve_flag after taking the 
>  	   inode allocation semaphore for */
>  #define EXT4_GET_BLOCKS_DELALLOC_RESERVE	0x0004
> -	/* Call ext4_da_update_reserve_space() after successfully 
> -	   allocating the blocks */
> -#define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0008
>  	/* caller is from the direct IO path, request to creation of an
>  	unitialized extents if not allocated, split the uninitialized
>  	extent if blocks has been preallocated already*/
> -#define EXT4_GET_BLOCKS_DIO			0x0010
> -#define EXT4_GET_BLOCKS_CONVERT			0x0020
> +#define EXT4_GET_BLOCKS_DIO			0x0008
> +#define EXT4_GET_BLOCKS_CONVERT			0x0010
>  #define EXT4_GET_BLOCKS_DIO_CREATE_EXT		(EXT4_GET_BLOCKS_DIO|\
>  					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
>  	/* Convert extent to initialized after direct IO complete */
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 3b6ff72..765a482 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3142,7 +3142,7 @@ out:
>  	 * But fallocate would have already updated quota and block
>  	 * count for this offset. So cancel these reservation
>  	 */
> -	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
> +	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
>  		ext4_da_update_reserve_space(inode, allocated, 0);
> 
>  map_out:
> @@ -3388,7 +3388,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  	 * Update reserved blocks/metadata blocks after successful
>  	 * block allocation which had been deferred till now.
>  	 */
> -	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
> +	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
>  		ext4_da_update_reserve_space(inode, allocated, 1);
> 
>  	/*
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3d1a1d6..fec4ea1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1309,7 +1309,7 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
>  		 * reserve space here.
>  		 */
>  		if ((retval > 0) &&
> -			(flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
> +			(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE))
>  			ext4_da_update_reserve_space(inode, retval, 1);
>  	}
>  	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
> @@ -2224,10 +2224,10 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
>  	 * variables are updated after the blocks have been allocated.
>  	 */
>  	new.b_state = 0;
> -	get_blocks_flags = (EXT4_GET_BLOCKS_CREATE |
> -			    EXT4_GET_BLOCKS_DELALLOC_RESERVE);
> +	get_blocks_flags = EXT4_GET_BLOCKS_CREATE ;
>  	if (mpd->b_state & (1 << BH_Delay))
> -		get_blocks_flags |= EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE;
> +		get_blocks_flags |= EXT4_GET_BLOCKS_DELALLOC_RESERVE;
> +
>  	blks = ext4_get_blocks(handle, mpd->inode, next, max_blocks,
>  			       &new, get_blocks_flags);
>  	if (blks < 0) {


