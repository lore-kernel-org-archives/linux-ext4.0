From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2.6.32.7] ext4: number of blocks for fiemap
Date: Mon, 15 Feb 2010 14:33:03 -0600
Message-ID: <4B79AF7F.2030209@redhat.com>
References: <1257360161.22057.16.camel@michlmayr> <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com> <1257371050.13852.28.camel@michlmayr> <4B701793.9010005@canonical.com> <1266000136.4310.36.camel@michlmayr> <4D0CB743-94B6-49AB-B838-BCDD2EC8C3ED@sun.com> <1266016801.27587.13.camel@michlmayr> <20100215195001.GN5337@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, Leonard Michlmayr <leonard.michlmayr@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org Mailingl
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab0BOUdO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Feb 2010 15:33:14 -0500
In-Reply-To: <20100215195001.GN5337@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> Sorry for the delay in attending to this patch.  This is what I've
> added to the ext4 patch queue.
> 
> 						- Ted
> 
> commit 7f9aeb212e41ea20f61061d51ad11ee2449853f1
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Mon Feb 15 14:48:32 2010 -0500

Ted, it looks like perhaps you accidentally reassigned authorship for
this patch?

-Eric

>     ext4: correctly calculate number of blocks for fiemap
>     
>     ext4_fiemap() rounds the length of the requested range down to
>     blocksize, which is is not the true number of blocks that cover the
>     requested region.  This problem is especially impressive if the user
>     requests only the first byte of a file: not a single extent will be
>     reported.
>     
>     We fix this by calculating the last block of the region and then
>     subtract to find the number of blocks in the extents.
>     
>     Signed-off-by: Leonard Michlmayr <leonard.michlmayr@gmail.com>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bd80891..bc9860f 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3768,7 +3768,6 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		__u64 start, __u64 len)
>  {
>  	ext4_lblk_t start_blk;
> -	ext4_lblk_t len_blks;
>  	int error = 0;
>  
>  	/* fallback to generic here if not in extents fmt */
> @@ -3782,8 +3781,11 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
>  		error = ext4_xattr_fiemap(inode, fieinfo);
>  	} else {
> +		ext4_lblk_t last_blk, len_blks;
> +
>  		start_blk = start >> inode->i_sb->s_blocksize_bits;
> -		len_blks = len >> inode->i_sb->s_blocksize_bits;
> +		last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
> +		len_blks = last_blk - start_blk + 1;
>  
>  		/*
>  		 * Walk the extent tree gathering extent information.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

