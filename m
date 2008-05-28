From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: error processing and coding enhancement for
	mballoc
Date: Wed, 28 May 2008 15:18:49 +0530
Message-ID: <20080528094849.GC15851@skywalker>
References: <483BC796.9020402@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alex@clusterfs.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:49914 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYE1Jtb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 May 2008 05:49:31 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4S9n12L004150
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 15:19:01 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4S9mgr1700544
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 15:18:42 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4S9n0wv025145
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 15:19:01 +0530
Content-Disposition: inline
In-Reply-To: <483BC796.9020402@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 27, 2008 at 04:34:30PM +0800, Shen Feng wrote:
> *ext4_mb_seq_history_open: check if sbi->s_mb_history is NULL
> *ext4_mb_history_init: replace kmalloc and memset with kzalloc
> *ext4_mb_init_backend: remove memset since kzalloc is used
> *ext4_mb_init: the return value of ext4_mb_init_backend is int,
>  but i is unsigned, replace it with a new int variable.
> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> ---
>  fs/ext4/mballoc.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index add55f0..35c12db 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1963,6 +1963,8 @@ static int ext4_mb_seq_history_open(struct inode *inode, struct file *file)
>  	int rc;
>  	int size;
> 
> +	if (unlikely(sbi->s_mb_history == NULL))
> +		return -ENOMEM;
>  	s = kmalloc(sizeof(*s), GFP_KERNEL);
>  	if (s == NULL)
>  		return -ENOMEM;
> @@ -2165,9 +2167,7 @@ static void ext4_mb_history_init(struct super_block *sb)
>  	sbi->s_mb_history_cur = 0;
>  	spin_lock_init(&sbi->s_mb_history_lock);
>  	i = sbi->s_mb_history_max * sizeof(struct ext4_mb_history);
> -	sbi->s_mb_history = kmalloc(i, GFP_KERNEL);
> -	if (likely(sbi->s_mb_history != NULL))
> -		memset(sbi->s_mb_history, 0, i);
> +	sbi->s_mb_history = kzalloc(i, GFP_KERNEL);
>  	/* if we can't allocate history, then we simple won't use it */
>  }
> 
> @@ -2281,7 +2281,6 @@ static int ext4_mb_init_backend(struct super_block *sb)
>  			i++;
>  			goto err_freebuddy;
>  		}
> -		memset(meta_group_info[j], 0, len);
>  		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
>  			&(meta_group_info[j]->bb_state));
> 
> @@ -2336,6 +2335,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>  	unsigned i;
>  	unsigned offset;
>  	unsigned max;
> +	int ret;
> 
>  	if (!test_opt(sb, MBALLOC))
>  		return 0;
> @@ -2370,12 +2370,12 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>  	} while (i <= sb->s_blocksize_bits + 1);
> 
>  	/* init file for buddy data */
> -	i = ext4_mb_init_backend(sb);
> -	if (i) {
> +	ret = ext4_mb_init_backend(sb);
> +	if (ret != 0) {
>  		clear_opt(sbi->s_mount_opt, MBALLOC);
>  		kfree(sbi->s_mb_offsets);
>  		kfree(sbi->s_mb_maxs);
> -		return i;
> +		return ret;
>  	}
> 
>  	spin_lock_init(&sbi->s_md_lock);
> -- 
> 1.5.4.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
