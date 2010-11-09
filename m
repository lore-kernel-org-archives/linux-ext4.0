From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/ext3/super.c: Use printf extension %pV
Date: Tue, 9 Nov 2010 23:46:58 +0100
Message-ID: <20101109224658.GA11214@quack.suse.cz>
References: <1289326685.1823.87.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54780 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab0KIWrA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Nov 2010 17:47:00 -0500
Content-Disposition: inline
In-Reply-To: <1289326685.1823.87.camel@Joe-Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 09-11-10 10:18:05, Joe Perches wrote:
> Using %pV reduces the number of printk calls and
> eliminates any possible message interleaving from
> other printk calls.
  Thanks. Merged.

						Honza

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/ext3/super.c |   56 ++++++++++++++++++++++++++++++++++++------------------
>  1 files changed, 37 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 2fedaf8..adfbe0d 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -144,12 +144,16 @@ void ext3_journal_abort_handle(const char *caller, const char *err_fn,
>  void ext3_msg(struct super_block *sb, const char *prefix,
>  		const char *fmt, ...)
>  {
> +	struct va_format vaf;
>  	va_list args;
>  
>  	va_start(args, fmt);
> -	printk("%sEXT3-fs (%s): ", prefix, sb->s_id);
> -	vprintk(fmt, args);
> -	printk("\n");
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	printk("%sEXT3-fs (%s): %pV\n", prefix, sb->s_id, &vaf);
> +
>  	va_end(args);
>  }
>  
> @@ -196,15 +200,20 @@ static void ext3_handle_error(struct super_block *sb)
>  			sb->s_id);
>  }
>  
> -void ext3_error (struct super_block * sb, const char * function,
> -		 const char * fmt, ...)
> +void ext3_error(struct super_block *sb, const char *function,
> +		const char *fmt, ...)
>  {
> +	struct va_format vaf;
>  	va_list args;
>  
>  	va_start(args, fmt);
> -	printk(KERN_CRIT "EXT3-fs error (device %s): %s: ",sb->s_id, function);
> -	vprintk(fmt, args);
> -	printk("\n");
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	printk(KERN_CRIT "EXT3-fs error (device %s): %s: %pV\n",
> +	       sb->s_id, function, &vaf);
> +
>  	va_end(args);
>  
>  	ext3_handle_error(sb);
> @@ -275,15 +284,20 @@ void __ext3_std_error (struct super_block * sb, const char * function,
>   * case we take the easy way out and panic immediately.
>   */
>  
> -void ext3_abort (struct super_block * sb, const char * function,
> -		 const char * fmt, ...)
> +void ext3_abort(struct super_block *sb, const char *function,
> +		 const char *fmt, ...)
>  {
> +	struct va_format vaf;
>  	va_list args;
>  
>  	va_start(args, fmt);
> -	printk(KERN_CRIT "EXT3-fs (%s): error: %s: ", sb->s_id, function);
> -	vprintk(fmt, args);
> -	printk("\n");
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	printk(KERN_CRIT "EXT3-fs (%s): error: %s: %pV\n",
> +	       sb->s_id, function, &vaf);
> +
>  	va_end(args);
>  
>  	if (test_opt(sb, ERRORS_PANIC))
> @@ -301,16 +315,20 @@ void ext3_abort (struct super_block * sb, const char * function,
>  		journal_abort(EXT3_SB(sb)->s_journal, -EIO);
>  }
>  
> -void ext3_warning (struct super_block * sb, const char * function,
> -		   const char * fmt, ...)
> +void ext3_warning(struct super_block *sb, const char *function,
> +		  const char *fmt, ...)
>  {
> +	struct va_format vaf;
>  	va_list args;
>  
>  	va_start(args, fmt);
> -	printk(KERN_WARNING "EXT3-fs (%s): warning: %s: ",
> -	       sb->s_id, function);
> -	vprintk(fmt, args);
> -	printk("\n");
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	printk(KERN_WARNING "EXT3-fs (%s): warning: %s: %pV\n",
> +	       sb->s_id, function, &vaf);
> +
>  	va_end(args);
>  }
>  
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
