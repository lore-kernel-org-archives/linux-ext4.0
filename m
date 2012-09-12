From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: enable FITRIM ioctl on bigalloc file system
Date: Wed, 12 Sep 2012 13:59:04 -0300
Message-ID: <20120912165904.GA20409@andromeda.usersys.redhat.com>
References: <1341342642-4156-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760536Ab2ILQ7I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:08 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8CGx8U9025930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2012 12:59:08 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-109.phx2.redhat.com [10.3.113.109])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q8CGx5SN031792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2012 12:59:07 -0400
Content-Disposition: inline
In-Reply-To: <1341342642-4156-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 03, 2012 at 09:10:42PM +0200, Lukas Czerner wrote:
> With a minor tweaks regarding minimum extent size to discard and
> discarded bytes reporting the FITRIM can be enabled on bigalloc file
> system and it works without any problem.
> 
> This patch fixes minlen handling and discarded bytes reporting to
> take into consideration bigalloc enabled file systems and finally
> removes the restriction and allow FITRIM to be used on file system with
> bigalloc feature enabled.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/ioctl.c   |    7 -------
>  fs/ext4/mballoc.c |    5 +++--
>  2 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index e34deac..9d6e0bc 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -420,13 +420,6 @@ resizefs_out:
>  		if (!blk_queue_discard(q))
>  			return -EOPNOTSUPP;
>  
> -		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> -			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
> -			ext4_msg(sb, KERN_ERR,
> -				 "FITRIM not supported with bigalloc");
> -			return -EOPNOTSUPP;
> -		}
> -
>  		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
>  		    sizeof(range)))
>  			return -EFAULT;
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 1cd6994..c4bd0a6 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4984,7 +4984,8 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  
>  	start = range->start >> sb->s_blocksize_bits;
>  	end = start + (range->len >> sb->s_blocksize_bits) - 1;
> -	minlen = range->minlen >> sb->s_blocksize_bits;
> +	minlen = EXT4_NUM_B2C(EXT4_SB(sb),
> +			      range->minlen >> sb->s_blocksize_bits);
>  
>  	if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)) ||
>  	    unlikely(start >= max_blks))
> @@ -5044,6 +5045,6 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  		atomic_set(&EXT4_SB(sb)->s_last_trim_minblks, minlen);
>  
>  out:
> -	range->len = trimmed * sb->s_blocksize;
> +	range->len = EXT4_C2B(EXT4_SB(sb), trimmed) << sb->s_blocksize_bits;
>  	return ret;
>  }

Looks good to me,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos
