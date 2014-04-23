From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: use EINVAL if not a regular file in
 ext4_fallocate()
Date: Wed, 23 Apr 2014 14:08:23 +0800
Message-ID: <20140423060823.GA9262@gmail.com>
References: <000e01cf5b8d$c57e9f80$507bde80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62498 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaDWGCA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2014 02:02:00 -0400
Received: by mail-pa0-f48.google.com with SMTP id hz1so421984pad.7
        for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2014 23:02:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <000e01cf5b8d$c57e9f80$507bde80$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 19, 2014 at 02:11:07PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Punch hole return EOPNOTSUPP about a non-REGULAR file also. So change EINVAL
> to be consistent with xfs. And move this check to the start of
> ext4_fallocate().

IMHO, EOPNOTSUPP makes sense to me.  From the man page of fallocate(2):

EOPNOTSUPP
      The filesystem containing the file referred to by fd does not
      support this operation; or the mode is not supported by the
      filesystem containing the file referred to by fd.

Regards,
                                                - Zheng

> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/ext4/extents.c | 9 +++------
>  fs/ext4/inode.c   | 3 ---
>  2 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 3276865..b38f487 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4741,9 +4741,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  
>  	trace_ext4_zero_range(inode, offset, len, mode);
>  
> -	if (!S_ISREG(inode->i_mode))
> -		return -EINVAL;
> -
>  	/*
>  	 * Write out all dirty pages to avoid race conditions
>  	 * Then release them.
> @@ -4888,6 +4885,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
>  		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
>  		return -EOPNOTSUPP;
> +	
> +	if (!S_ISREG(inode->i_mode))
> +		return -EINVAL;
>  
>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>  		return ext4_punch_hole(inode, offset, len);
> @@ -5403,9 +5403,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  	    len & (EXT4_BLOCK_SIZE(sb) - 1))
>  		return -EINVAL;
>  
> -	if (!S_ISREG(inode->i_mode))
> -		return -EINVAL;
> -
>  	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1)
>  		return -EOPNOTSUPP;
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d7b7462..d6cbbe3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3524,9 +3524,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>  	unsigned int credits;
>  	int ret = 0;
>  
> -	if (!S_ISREG(inode->i_mode))
> -		return -EOPNOTSUPP;
> -
>  	trace_ext4_punch_hole(inode, offset, length, 0);
>  
>  	/*
> -- 
> 1.7.11-rc0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
