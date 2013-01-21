From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix memory leak when quota options are specified
 multiple times
Date: Mon, 21 Jan 2013 11:31:38 +0100
Message-ID: <20130121103138.GB5588@quack.suse.cz>
References: <50FBC2D8.9070807@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab3AUKbl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 05:31:41 -0500
Content-Disposition: inline
In-Reply-To: <50FBC2D8.9070807@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 20-01-13 18:11:36, Chen Gang wrote:
> 
>   When usrjquota or grpjquota mount options are specified several times,
>   we leak memory storing the names. Free the memory correctly.
  The port looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c |   48 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c014edd..a4a8ecc 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1351,21 +1351,25 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
>  			"Not enough memory for storing quotafile name");
>  		return -1;
>  	}
> -	if (sbi->s_qf_names[qtype] &&
> -		strcmp(sbi->s_qf_names[qtype], qname)) {
> -		ext4_msg(sb, KERN_ERR,
> -			"%s quota file already specified", QTYPE2NAME(qtype));
> +	if (sbi->s_qf_names[qtype]) {
> +		int ret = 1;
> +
> +		if (strcmp(sbi->s_qf_names[qtype], qname)) {
> +			ext4_msg(sb, KERN_ERR,
> +				"%s quota file already specified",
> +				QTYPE2NAME(qtype));
> +			ret = -1;
> +		}
>  		kfree(qname);
> -		return -1;
> +		return ret;
>  	}
> -	sbi->s_qf_names[qtype] = qname;
> -	if (strchr(sbi->s_qf_names[qtype], '/')) {
> +	if (strchr(qname, '/')) {
>  		ext4_msg(sb, KERN_ERR,
>  			"quotafile must be on filesystem root");
> -		kfree(sbi->s_qf_names[qtype]);
> -		sbi->s_qf_names[qtype] = NULL;
> +		kfree(qname);
>  		return -1;
>  	}
> +	sbi->s_qf_names[qtype] = qname;
>  	set_opt(sb, QUOTA);
>  	return 1;
>  }
> @@ -1381,10 +1385,7 @@ static int clear_qf_name(struct super_block *sb, int qtype)
>  			" when quota turned on");
>  		return -1;
>  	}
> -	/*
> -	 * The space will be released later when all options are confirmed
> -	 * to be correct
> -	 */
> +	kfree(sbi->s_qf_names[qtype]);
>  	sbi->s_qf_names[qtype] = NULL;
>  	return 1;
>  }
> @@ -4605,7 +4606,18 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  #ifdef CONFIG_QUOTA
>  	old_opts.s_jquota_fmt = sbi->s_jquota_fmt;
>  	for (i = 0; i < MAXQUOTAS; i++)
> -		old_opts.s_qf_names[i] = sbi->s_qf_names[i];
> +		if (sbi->s_qf_names[i]) {
> +			old_opts.s_qf_names[i] = kstrdup(sbi->s_qf_names[i],
> +							GFP_KERNEL);
> +			if (!old_opts.s_qf_names[i]) {
> +				int j;
> +
> +				for (j = 0; j < i; j++)
> +					kfree(old_opts.s_qf_names[j]);
> +				return -ENOMEM;
> +			}
> +		} else
> +			old_opts.s_qf_names[i] = NULL;
>  #endif
>  	if (sbi->s_journal && sbi->s_journal->j_task->io_context)
>  		journal_ioprio = sbi->s_journal->j_task->io_context->ioprio;
> @@ -4738,9 +4750,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  #ifdef CONFIG_QUOTA
>  	/* Release old quota file names */
>  	for (i = 0; i < MAXQUOTAS; i++)
> -		if (old_opts.s_qf_names[i] &&
> -		    old_opts.s_qf_names[i] != sbi->s_qf_names[i])
> -			kfree(old_opts.s_qf_names[i]);
> +		kfree(old_opts.s_qf_names[i]);
>  	if (enable_quota) {
>  		if (sb_any_quota_suspended(sb))
>  			dquot_resume(sb, -1);
> @@ -4769,9 +4779,7 @@ restore_opts:
>  #ifdef CONFIG_QUOTA
>  	sbi->s_jquota_fmt = old_opts.s_jquota_fmt;
>  	for (i = 0; i < MAXQUOTAS; i++) {
> -		if (sbi->s_qf_names[i] &&
> -		    old_opts.s_qf_names[i] != sbi->s_qf_names[i])
> -			kfree(sbi->s_qf_names[i]);
> +		kfree(sbi->s_qf_names[i]);
>  		sbi->s_qf_names[i] = old_opts.s_qf_names[i];
>  	}
>  #endif
> -- 
> 1.7.10.4
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
