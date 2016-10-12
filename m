From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: super.c: Update logging style using PR_CONT
Date: Wed, 12 Oct 2016 12:41:57 +0200
Message-ID: <20161012104157.GB14664@quack2.suse.cz>
References: <ac72258a7f35042014aede22502d947b59ada155.1476237454.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753844AbcJLKm6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Oct 2016 06:42:58 -0400
Content-Disposition: inline
In-Reply-To: <ac72258a7f35042014aede22502d947b59ada155.1476237454.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 11-10-16 18:57:58, Joe Perches wrote:
> Recent commit require line continuing printks to use PR_CONT.
> 
> Update super.c to use PR_CONT and use vsprintf extension %pV
> to avoid a printk/vprintk/printk("\n") sequence as well.

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/ext4/super.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6db81fbcbaa6..20da99da0a34 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -597,14 +597,15 @@ void __ext4_std_error(struct super_block *sb, const char *function,
>  void __ext4_abort(struct super_block *sb, const char *function,
>  		unsigned int line, const char *fmt, ...)
>  {
> +	struct va_format vaf;
>  	va_list args;
>  
>  	save_error_info(sb, function, line);
>  	va_start(args, fmt);
> -	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: ", sb->s_id,
> -	       function, line);
> -	vprintk(fmt, args);
> -	printk("\n");
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: %pV\n",
> +	       sb->s_id, function, line, &vaf);
>  	va_end(args);
>  
>  	if ((sb->s_flags & MS_RDONLY) == 0) {
> @@ -2715,12 +2716,12 @@ static void print_daily_error_info(unsigned long arg)
>  		       es->s_first_error_func,
>  		       le32_to_cpu(es->s_first_error_line));
>  		if (es->s_first_error_ino)
> -			printk(": inode %u",
> +			printk(KERN_CONT ": inode %u",
>  			       le32_to_cpu(es->s_first_error_ino));
>  		if (es->s_first_error_block)
> -			printk(": block %llu", (unsigned long long)
> +			printk(KERN_CONT ": block %llu", (unsigned long long)
>  			       le64_to_cpu(es->s_first_error_block));
> -		printk("\n");
> +		printk(KERN_CONT "\n");
>  	}
>  	if (es->s_last_error_time) {
>  		printk(KERN_NOTICE "EXT4-fs (%s): last error at time %u: %.*s:%d",
> @@ -2729,12 +2730,12 @@ static void print_daily_error_info(unsigned long arg)
>  		       es->s_last_error_func,
>  		       le32_to_cpu(es->s_last_error_line));
>  		if (es->s_last_error_ino)
> -			printk(": inode %u",
> +			printk(KERN_CONT ": inode %u",
>  			       le32_to_cpu(es->s_last_error_ino));
>  		if (es->s_last_error_block)
> -			printk(": block %llu", (unsigned long long)
> +			printk(KERN_CONT ": block %llu", (unsigned long long)
>  			       le64_to_cpu(es->s_last_error_block));
> -		printk("\n");
> +		printk(KERN_CONT "\n");
>  	}
>  	mod_timer(&sbi->s_err_report, jiffies + 24*60*60*HZ);  /* Once a day */
>  }
> -- 
> 2.10.0.rc2.1.g053435c
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
