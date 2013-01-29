From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] ext4: remove useless assignment in dx_probe()
Date: Mon, 28 Jan 2013 17:21:50 -0800
Message-ID: <20130129012150.GB4754@blackbox.djwong.org>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
 <1358496074-6228-3-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29531 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3A2BV5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 20:21:57 -0500
Content-Disposition: inline
In-Reply-To: <1358496074-6228-3-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 04:01:13PM +0800, Guo Chao wrote:
> No body care about the effect of this assignment.
> 
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> ---
>  fs/ext4/namei.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index b3717a3..e35ea3d 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -714,7 +714,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
>  				*err = ERR_BAD_DX_DIR;
>  			goto fail2;
>  		}
> -		at = entries = ((struct dx_node *) bh->b_data)->entries;
> +		entries = ((struct dx_node *) bh->b_data)->entries;

The 'at' variable seems to be used (in a if(0)'d code block) to check the
results of the binary search against a slow linear search.  Perhaps we should
get rid of the if(0) hunk about 30 lines up?  The 'at' variable itself could go
too, since it seems to be an alias of "p - 1" and frame->at.

--D
>  
>  		if (!buffer_verified(bh) &&
>  		    !ext4_dx_csum_verify(dir,
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
