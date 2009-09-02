From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 1/4]ext4: Fix wrong comparisons in mext_check_arguments()
Date: Thu, 03 Sep 2009 00:02:43 +0800
Message-ID: <4A9E9723.50803@gmail.com>
References: <4A9DE3DE.2010509@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:12068 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZIBQCx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 12:02:53 -0400
Received: by ey-out-2122.google.com with SMTP id 25so217599eya.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2009 09:02:54 -0700 (PDT)
In-Reply-To: <4A9DE3DE.2010509@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Akira,

Akira Fujita wrote:
> ext4: Fix wrong comparisons in mext_check_arguments()
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> mext_check_arguments() in move_extents.c has wrong comparisons.
> orig_start which is passed from user-space is block unit,
> but i_size of inode is byte unit, therefore the checks do not work fine.
> This mis-check leads to the overflow of 'len' and then hits BUG_ON()
> in ext4_move_extens().   The patch fixes this issue.
While the bug is true, I wander if it checks all conditions, because i_size isn't 
blocksize aligned.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> ---
>  fs/ext4/move_extent.c |   39 ++++++++++++++++++++++++---------------
>  1 files changed, 24 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 5821e0b..60ed567 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -972,43 +972,52 @@ mext_check_arguments(struct inode *orig_inode,
>  	}
> 
>  	if (orig_inode->i_size > donor_inode->i_size) {
> -		if (orig_start >= donor_inode->i_size) {
> +		if (orig_start << orig_inode->i_blkbits >=
> +						donor_inode->i_size) {
>  			ext4_debug("ext4 move extent: orig start offset "
>  			"[%llu] should be less than donor file size "
>  			"[%lld] [ino:orig %lu, donor_inode %lu]\n",
> -			orig_start, donor_inode->i_size,
> -			orig_inode->i_ino, donor_inode->i_ino);
> +			orig_start << orig_inode->i_blkbits,
> +			donor_inode->i_size, orig_inode->i_ino,
> +			donor_inode->i_ino);
>  			return -EINVAL;
>  		}
> -
> -		if (orig_start + *len > donor_inode->i_size) {
> +		if ((orig_start + *len) << orig_inode->i_blkbits >
> +						donor_inode->i_size) {
>  			ext4_debug("ext4 move extent: End offset [%llu] should "
>  				"be less than donor file size [%lld]."
>  				"So adjust length from %llu to %lld "
>  				"[ino:orig %lu, donor %lu]\n",
> -				orig_start + *len, donor_inode->i_size,
> -				*len, donor_inode->i_size - orig_start,
> +				(orig_start + *len) << orig_inode->i_blkbits,
> +				donor_inode->i_size,
> +				*len, (donor_inode->i_size >>
> +				orig_inode->i_blkbits) - orig_start,
>  				orig_inode->i_ino, donor_inode->i_ino);
> -			*len = donor_inode->i_size - orig_start;
> +			*len = (donor_inode->i_size >> orig_inode->i_blkbits) -
> +				orig_start;
>  		}
>  	} else {
> -		if (orig_start >= orig_inode->i_size) {
> +		if (orig_start << orig_inode->i_blkbits >=
> +						orig_inode->i_size) {
>  			ext4_debug("ext4 move extent: start offset [%llu] "
>  				"should be less than original file size "
>  				"[%lld] [inode:orig %lu, donor %lu]\n",
> -				 orig_start, orig_inode->i_size,
> -				orig_inode->i_ino, donor_inode->i_ino);
> +				orig_start << orig_inode->i_blkbits,
> +				orig_inode->i_size, orig_inode->i_ino,
> +				donor_inode->i_ino);
>  			return -EINVAL;
>  		}
> -
> -		if (orig_start + *len > orig_inode->i_size) {
> +		if ((orig_start + *len) << orig_inode->i_blkbits >
> +						orig_inode->i_size) {
>  			ext4_debug("ext4 move extent: Adjust length "
>  				"from %llu to %lld. Because it should be "
>  				"less than original file size "
>  				"[ino:orig %lu, donor %lu]\n",
> -				*len, orig_inode->i_size - orig_start,
> +				*len, (orig_inode->i_size >>
> +				orig_inode->i_blkbits) - orig_start,
>  				orig_inode->i_ino, donor_inode->i_ino);
> -			*len = orig_inode->i_size - orig_start;
> +			*len = (orig_inode->i_size >> orig_inode->i_blkbits) -
> +				orig_start;
>  		}
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Best Regards,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
