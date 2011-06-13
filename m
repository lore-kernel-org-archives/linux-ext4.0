From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3/ioctl.c: quite sparse warnings about different
 address spaces
Date: Mon, 13 Jun 2011 15:47:04 +0200
Message-ID: <20110613134704.GD4907@quack.suse.cz>
References: <201106101459.06129.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, jack@suse.cz,
	akpm@linux-foundation.org, adilger.kernel@dilger.ca
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38538 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab1FMNrH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jun 2011 09:47:07 -0400
Content-Disposition: inline
In-Reply-To: <201106101459.06129.hartleys@visionengravers.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 10-06-11 14:59:05, H Hartley Sweeten wrote:
> The 'from' argument for copy_from_user and the 'to' argument for
> copy_to_user should both be tagged as __user address space.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
  Thanks. Merged.

								Honza
> 
> ---
> 
> diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
> index f4090bd..c7f4394 100644
> --- a/fs/ext3/ioctl.c
> +++ b/fs/ext3/ioctl.c
> @@ -285,7 +285,7 @@ group_add_out:
>  		if (!capable(CAP_SYS_ADMIN))
>  			return -EPERM;
>  
> -		if (copy_from_user(&range, (struct fstrim_range *)arg,
> +		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
>  				   sizeof(range)))
>  			return -EFAULT;
>  
> @@ -293,7 +293,7 @@ group_add_out:
>  		if (ret < 0)
>  			return ret;
>  
> -		if (copy_to_user((struct fstrim_range *)arg, &range,
> +		if (copy_to_user((struct fstrim_range __user *)arg, &range,
>  				 sizeof(range)))
>  			return -EFAULT;
>  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
