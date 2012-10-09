From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: Avoid underflow of in ext4_trim_fs()
Date: Tue, 9 Oct 2012 10:37:14 -0300
Message-ID: <20121009133714.GA22836@andromeda.usersys.redhat.com>
References: <1349784762-28069-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab2JINhS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2012 09:37:18 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q99DbIgs019198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2012 09:37:18 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-88.phx2.redhat.com [10.3.113.88])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q99DbEvA032645
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2012 09:37:17 -0400
Content-Disposition: inline
In-Reply-To: <1349784762-28069-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 09, 2012 at 02:12:42PM +0200, Lukas Czerner wrote:
> Currently if len argument in ext4_trim_fs() is smaller than one block,
> the 'end' variable underflow. Avoid that by exiting right away if len
> is smaller than one file system block.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/mballoc.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index f8b27bf..06c8526 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4989,13 +4989,18 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  	int ret = 0;
>  
>  	start = range->start >> sb->s_blocksize_bits;
> -	end = start + (range->len >> sb->s_blocksize_bits) - 1;
>  	minlen = EXT4_NUM_B2C(EXT4_SB(sb),
>  			      range->minlen >> sb->s_blocksize_bits);
>  
>  	if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)) ||
>  	    unlikely(start >= max_blks))
>  		return -EINVAL;
> +
> +	end = range->len >> sb->s_blocksize_bits;
> +	if (0 == end)
> +		goto out;
> +	end += start - 1;
> +
>  	if (end >= max_blks)
>  		end = max_blks - 1;
>  	if (end <= first_data_blk)
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos
