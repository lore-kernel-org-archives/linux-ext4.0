From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix overhead calculations in ext4_stats, again
Date: Mon, 29 Oct 2012 18:13:56 +0100
Message-ID: <20121029171356.GF18767@quack.suse.cz>
References: <50896FD6.1010807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab2J2RN7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2012 13:13:59 -0400
Content-Disposition: inline
In-Reply-To: <50896FD6.1010807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-10-12 11:59:02, Eric Sandeen wrote:
> "overhead" was a write-only variable in this function after commit
> 952fc18e; we set it to 0 for minixdf, or to sbi->s_overhead if !minixdf,
> but never read it again after that.
> 
> We need to use it, not sbi->s_overhead, when subtracting out overhead
> for f_blocks, or we get the wrong answer for minixdf.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
  Yeah, looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
> 
> "Once more, with feeling!" ;)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e44b233..2feaf78 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4758,7 +4758,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  
>  	buf->f_type = EXT4_SUPER_MAGIC;
>  	buf->f_bsize = sb->s_blocksize;
> -	buf->f_blocks = ext4_blocks_count(es) - EXT4_C2B(sbi, sbi->s_overhead);
> +	buf->f_blocks = ext4_blocks_count(es) - EXT4_C2B(sbi, overhead);
>  	bfree = percpu_counter_sum_positive(&sbi->s_freeclusters_counter) -
>  		percpu_counter_sum_positive(&sbi->s_dirtyclusters_counter);
>  	/* prevent underflow in case that few free space is available */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
