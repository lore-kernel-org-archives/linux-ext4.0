From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix COLLAPSE RANGE test failure when bigalloc is
 enable
Date: Wed, 4 Jun 2014 15:27:50 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406041456210.2927@localhost.localdomain>
References: <001001cf7fcc$34f3c2c0$9edb4840$@samsung.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbaFDN16 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2014 09:27:58 -0400
In-Reply-To: <001001cf7fcc$34f3c2c0$9edb4840$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 4 Jun 2014, Namjae Jeon wrote:

> Date: Wed, 04 Jun 2014 17:08:45 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
>     Ashish Sangwan <a.sangwan@samsung.com>
> Subject: [PATCH] ext4: fix COLLAPSE RANGE test failure when bigalloc is enable
> 
> Blocks in collapse range should be collapsed per cluster unit when bigalloc
> is enable. If bigalloc is not enable, EXT4_CLUSTER_SIZE will be same with
> EXT4_BLOCK_SIZE.

I wonder why it is so ? Bigalloc only affects the way we allocate
and free blocks, it does not affect extent tree at all and so
freeing and allocating extents at the block boundary on bigalloc
file system should be just fine - underlying code should be able to
handle it.

It might be that there is some complication in shift_extent code
which is not obvious to me. Could you please describe the problem
and why this is needed little bit more ?

Have you done some testing with bigalloc enabled file system with
respect to collapse range ?

Thanks!
-Lukas

> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/ext4/extents.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 4da228a..2b9f5f3 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5403,16 +5403,13 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  	int ret;
>  
>  	/* Collapse range works only on fs block size aligned offsets. */
> -	if (offset & (EXT4_BLOCK_SIZE(sb) - 1) ||
> -	    len & (EXT4_BLOCK_SIZE(sb) - 1))
> +	if (offset & (EXT4_CLUSTER_SIZE(sb) - 1) ||
> +	    len & (EXT4_CLUSTER_SIZE(sb) - 1))
>  		return -EINVAL;
>  
>  	if (!S_ISREG(inode->i_mode))
>  		return -EINVAL;
>  
> -	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1)
> -		return -EOPNOTSUPP;
> -
>  	trace_ext4_collapse_range(inode, offset, len);
>  
>  	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
> 
