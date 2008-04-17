From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] mballoc: fix hot spins after err_freebuddy and
	err_freemeta
Date: Thu, 17 Apr 2008 23:28:43 +0530
Message-ID: <20080417175843.GA7517@skywalker>
References: <4807762A.9090202@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alex@clusterfs.com, sct@redhat.com, akpm@linux-foundation.org,
	adilger@clusterfs.com, linux-ext4@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Roel Kluin <12o3l@tiscali.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55816 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001AbYDQR67 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2008 13:58:59 -0400
Content-Disposition: inline
In-Reply-To: <4807762A.9090202@tiscali.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2008 at 06:09:14PM +0200, Roel Kluin wrote:
> ext4_mb_init_backend() has a variable i of type ext4_group_t. which is typedefined
> in include/linux/ext4_fs_i.h:34 to unsigned long. Since unsigned, i >= 0 is always
> true, so fix hot spins after err_freebuddy and err_freemeta.
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index ef97f19..afba9b8 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2618,14 +2618,14 @@ static int ext4_mb_init_backend(struct super_block *sb)
>  	return 0;

The function needs more changes. For ex:

2279     if (meta_group_info[j] == NULL) {
2280               printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
2281               i--;
2282               goto err_freebuddy;
2283     }

That decrement  i--; could result in bad value if i == 0;.


> 
>  err_freebuddy:
> -	while (i >= 0) {
> +	do {
>  		kfree(ext4_get_group_info(sb, i));
> -		i--;
> -	}
> -	i = num_meta_group_infos;
> +	} while (i-- != 0);
> +	i = num_meta_group_infos - 1;
>  err_freemeta:
> -	while (--i >= 0)
> +	do {
>  		kfree(sbi->s_group_info[i]);
> +	} while (i-- != 0);
>  	iput(sbi->s_buddy_cache);
>  err_freesgi:
>  	kfree(sbi->s_group_info);

-aneesh
