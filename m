From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] ext4: Fix regression in mount option parsing and a
 small cleanup
Date: Tue, 17 Apr 2012 00:15:43 +0200
Message-ID: <20120416221543.GA29258@quack.suse.cz>
References: <1334579134-19885-1-git-send-email-jack@suse.cz>
 <20120416170607.GC31129@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2DPWPp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Apr 2012 18:15:45 -0400
Content-Disposition: inline
In-Reply-To: <20120416170607.GC31129@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 16-04-12 13:06:07, Ted Tso wrote:
> On Mon, Apr 16, 2012 at 02:25:30PM +0200, Jan Kara wrote:
> > 
> > 
> >   this patch series aims at fixing a regression in parsing of
> > journalled quota mount options introduced by Ted's mount option
> > parsing rewrite. Patches 1 and 2 cleanup the code a bit and patch 3
> > then fixes the regression. Patch 4 is a tiny cleanup.
> 
> Hi Jan,
> 
> Apologies for breaking the journalled mount options, and thank you for
> this patch series.  I agree it's an improvement on what we currently
> have.  My main concern with though, is I'd like to fix this for 3.4,
> and the four patches together is a bit larger than what I feel
> comfortable pushing to Linus at this point.  What do you think of this
> patch now, and I'll we'll add your changes for the next merge window?
  Yeah, I figured it might be a bit too big. I didn't think of the simple
trick which makes the quick fix small :) The patch looks good (and I've
also tested it) so you can add:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> From 816c710aa92cdf442e6fc722b74bb99bf8575a30 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Mon, 16 Apr 2012 12:54:07 -0400
> Subject: [PATCH] ext4: fix handling of journalled quota options
> 
> Commit 26092bf5 broke handling of journalled quota mount options by
> trying to parse argument of every mount option as a number.  Fix this
> by dealing with the quota options before we call match_int().
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c |   32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ef7db50..6da1935 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1305,20 +1305,20 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
>  		ext4_msg(sb, KERN_ERR,
>  			"Cannot change journaled "
>  			"quota options when quota turned on");
> -		return 0;
> +		return -1;
>  	}
>  	qname = match_strdup(args);
>  	if (!qname) {
>  		ext4_msg(sb, KERN_ERR,
>  			"Not enough memory for storing quotafile name");
> -		return 0;
> +		return -1;
>  	}
>  	if (sbi->s_qf_names[qtype] &&
>  		strcmp(sbi->s_qf_names[qtype], qname)) {
>  		ext4_msg(sb, KERN_ERR,
>  			"%s quota file already specified", QTYPE2NAME(qtype));
>  		kfree(qname);
> -		return 0;
> +		return -1;
>  	}
>  	sbi->s_qf_names[qtype] = qname;
>  	if (strchr(sbi->s_qf_names[qtype], '/')) {
> @@ -1326,7 +1326,7 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
>  			"quotafile must be on filesystem root");
>  		kfree(sbi->s_qf_names[qtype]);
>  		sbi->s_qf_names[qtype] = NULL;
> -		return 0;
> +		return -1;
>  	}
>  	set_opt(sb, QUOTA);
>  	return 1;
> @@ -1341,7 +1341,7 @@ static int clear_qf_name(struct super_block *sb, int qtype)
>  		sbi->s_qf_names[qtype]) {
>  		ext4_msg(sb, KERN_ERR, "Cannot change journaled quota options"
>  			" when quota turned on");
> -		return 0;
> +		return -1;
>  	}
>  	/*
>  	 * The space will be released later when all options are confirmed
> @@ -1450,6 +1450,16 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  	const struct mount_opts *m;
>  	int arg = 0;
>  
> +#ifdef CONFIG_QUOTA
> +	if (token == Opt_usrjquota)
> +		return set_qf_name(sb, USRQUOTA, &args[0]);
> +	else if (token == Opt_grpjquota)
> +		return set_qf_name(sb, GRPQUOTA, &args[0]);
> +	else if (token == Opt_offusrjquota)
> +		return clear_qf_name(sb, USRQUOTA);
> +	else if (token == Opt_offgrpjquota)
> +		return clear_qf_name(sb, GRPQUOTA);
> +#endif
>  	if (args->from && match_int(args, &arg))
>  		return -1;
>  	switch (token) {
> @@ -1549,18 +1559,6 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  				sbi->s_mount_opt |= m->mount_opt;
>  			}
>  #ifdef CONFIG_QUOTA
> -		} else if (token == Opt_usrjquota) {
> -			if (!set_qf_name(sb, USRQUOTA, &args[0]))
> -				return -1;
> -		} else if (token == Opt_grpjquota) {
> -			if (!set_qf_name(sb, GRPQUOTA, &args[0]))
> -				return -1;
> -		} else if (token == Opt_offusrjquota) {
> -			if (!clear_qf_name(sb, USRQUOTA))
> -				return -1;
> -		} else if (token == Opt_offgrpjquota) {
> -			if (!clear_qf_name(sb, GRPQUOTA))
> -				return -1;
>  		} else if (m->flags & MOPT_QFMT) {
>  			if (sb_any_quota_loaded(sb) &&
>  			    sbi->s_jquota_fmt != m->mount_opt) {
> -- 
> 1.7.10.rc3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
