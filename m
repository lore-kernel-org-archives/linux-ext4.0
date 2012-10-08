From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix error handling in ext4_fill_super()
Date: Mon, 8 Oct 2012 15:48:34 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210081547590.31773@dhcp-1-104.brq.redhat.com>
References: <alpine.LFD.2.00.1210081424290.25096@localhost> <1349699574-32194-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab2JHNsp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 09:48:45 -0400
In-Reply-To: <1349699574-32194-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I forgot to add Eugene to the cc, sorry.

-Lukas

On Mon, 8 Oct 2012, Lukas Czerner wrote:

> Date: Mon,  8 Oct 2012 14:32:54 +0200
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
> Subject: [PATCH] ext4: fix error handling in ext4_fill_super()
> 
> There are some places in ext4_fill_super() where we would not return
> proper error code if something fails. The confusion is caused probably
> due to the fact that we have two "kind-of" return variables 'ret'and
> 'err'.
> 
> 'ret' is used to return error code from ext4_fill_super() where err is
> used to store return values from other functions within ext4_fill_super().
> However some places were missing the obligatory 'ret = err'. We could
> put the assignment where it is missing, but we can have better "future
> proof" solution. Or we could convert the code to use just one, but it
> would require more rewrites.
> 
> This commit fixes the problem by returning value from 'err' variable if
> it is set and 'ret' otherwise in error handling branch of the
> ext4_fill_super(). The reasoning is that 'ret' value is often set to
> default "-EINVAL" or explicit value, where 'err' is used to store
> return value from other functions and should be otherwise zero.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/super.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 69c55d4..c02c676 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3223,7 +3223,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	unsigned int i;
>  	int needs_recovery, has_huge_files, has_bigalloc;
>  	__u64 blocks_count;
> -	int err;
> +	int err = 0;
>  	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
>  	ext4_group_t first_not_zeroed;
>  
> @@ -3252,6 +3252,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	for (cp = sb->s_id; (cp = strchr(cp, '/'));)
>  		*cp = '!';
>  
> +	/* -EINVAL is default */
>  	ret = -EINVAL;
>  	blocksize = sb_min_blocksize(sb, EXT4_MIN_BLOCK_SIZE);
>  	if (!blocksize) {
> @@ -3629,7 +3630,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  			 " too large to mount safely on this system");
>  		if (sizeof(sector_t) < 8)
>  			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
> -		ret = err;
>  		goto failed_mount;
>  	}
>  
> @@ -3737,7 +3737,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  	if (err) {
>  		ext4_msg(sb, KERN_ERR, "insufficient memory");
> -		ret = err;
>  		goto failed_mount3;
>  	}
>  
> @@ -3863,8 +3862,8 @@ no_journal:
>  	if (es->s_overhead_clusters)
>  		sbi->s_overhead = le32_to_cpu(es->s_overhead_clusters);
>  	else {
> -		ret = ext4_calculate_overhead(sb);
> -		if (ret)
> +		err = ext4_calculate_overhead(sb);
> +		if (err)
>  			goto failed_mount_wq;
>  	}
>  
> @@ -3876,6 +3875,7 @@ no_journal:
>  		alloc_workqueue("ext4-dio-unwritten", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
>  	if (!EXT4_SB(sb)->dio_unwritten_wq) {
>  		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
> +		ret = -ENOMEM;
>  		goto failed_mount_wq;
>  	}
>  
> @@ -3978,8 +3978,8 @@ no_journal:
>  	/* Enable quota usage during mount. */
>  	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
>  	    !(sb->s_flags & MS_RDONLY)) {
> -		ret = ext4_enable_quotas(sb);
> -		if (ret)
> +		err = ext4_enable_quotas(sb);
> +		if (err)
>  			goto failed_mount7;
>  	}
>  #endif  /* CONFIG_QUOTA */
> @@ -4050,7 +4050,7 @@ out_fail:
>  	kfree(sbi);
>  out_free_orig:
>  	kfree(orig_data);
> -	return ret;
> +	return err ? err : ret;
>  }
>  
>  /*
> 
