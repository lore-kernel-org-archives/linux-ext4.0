From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] EXT4:  Use is_power_of_2() routine for clarity.
Date: Fri, 24 Apr 2009 10:03:31 -0500
Message-ID: <49F1D4C3.5040804@redhat.com>
References: <alpine.LFD.2.00.0904240905050.12966@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Andrew Morton <akpm@osdl.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56276 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbZDXPEm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 11:04:42 -0400
In-Reply-To: <alpine.LFD.2.00.0904240905050.12966@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Robert P. J. Day wrote:
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

Looks fine, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2958f4e..479d5ef 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1479,7 +1479,7 @@ set_qf_format:
>  				return 0;
>  			if (option < 0 || option > (1 << 30))
>  				return 0;
> -			if (option & (option - 1)) {
> +			if (!is_power_of_2(option)) {
>  				printk(KERN_ERR "EXT4-fs: inode_readahead_blks"
>  				       " must be a power of 2\n");
>  				return 0;
> @@ -2092,7 +2092,7 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
>  		return -EINVAL;
> 
>  	/* inode_readahead_blks must be a power of 2 */
> -	if (t & (t-1))
> +	if (!is_power_of_2(t))
>  		return -EINVAL;
> 
>  	sbi->s_inode_readahead_blks = t;
> 
