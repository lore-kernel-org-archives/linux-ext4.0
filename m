From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [patch] ext4: off by one check in ext4_groupinfo_create_slab()
Date: Wed, 09 Feb 2011 18:12:17 -0600
Message-ID: <4D532D61.7030007@redhat.com>
References: <20110209232412.GC4384@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1BJAMc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Feb 2011 19:12:32 -0500
In-Reply-To: <20110209232412.GC4384@bicker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/9/11 5:24 PM, Dan Carpenter wrote:
> If cache_index == NR_GRPINFO_CACHES then we read past the end of the
> ext4_groupinfo_caches[] array a couple lines later.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Argh, you'd think I could cut and paste from jbd2 better :(

Thanks,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 02cff4a..d1fe09a 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2438,7 +2438,7 @@ static int ext4_groupinfo_create_slab(size_t size)
>  	int cache_index = blocksize_bits - EXT4_MIN_BLOCK_LOG_SIZE;
>  	struct kmem_cache *cachep;
>  
> -	if (cache_index > NR_GRPINFO_CACHES)
> +	if (cache_index >= NR_GRPINFO_CACHES)
>  		return -EINVAL;
>  
>  	if (unlikely(cache_index < 0))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

