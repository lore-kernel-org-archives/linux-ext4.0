From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] e2fsck: completely ignore last-mount and last-write
 within fudge_time
Date: Wed, 18 Mar 2015 21:40:23 +0100
Message-ID: <20150318204023.GB28368@quack.suse.cz>
References: <5509DCE4.1010706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041AbbCRUk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2015 16:40:29 -0400
Content-Disposition: inline
In-Reply-To: <5509DCE4.1010706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 18-03-15 15:15:32, Eric Sandeen wrote:
> In some cases, particularly with RTC set to localtime, we may have
> timestamps in the superblock off by up to 24 hours.
> 
> Today, even if accept_time_fudge is set, we find the problem, alert
> the user, fix it, and set E2F_FLAG_PROBLEMS_FIXED in fix_problem().
> 
> This flag causes check_if_skip() to return (not exit), and a full
> check ensues.  This will happen on every single boot.
> 
> This runs counter to what the man page implies; the text there sounds
> like time offsets of up to 24h will be ignored.  But in truth, the
> only difference accept_time_fudge makes today is to change the message
> presented to the user.  Actual action taken by e2fsck is identical.
> 
> So: Change the code so that last-mount and last-write times are
> completely ignored if they are within 24h (the fudge_time), and
> clarify the man page to show that this is the case.
> 
> If accept_fudge_time is set to false, ctx->fudge_time will be 0,
> and no leeway will be given.
> 
> (As a historical note, both Fedora and OpenSUSE had set
> broken_system_clock to 1 to work around this behavior in the past,
> but that defeated all time-based checks).
> 
  Looks good. You can add:
Acked-by: Jan Kara <jack@suse.cz>

							Honza

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
> index 9ebfbbf..515af37 100644
> --- a/e2fsck/e2fsck.conf.5.in
> +++ b/e2fsck/e2fsck.conf.5.in
> @@ -103,6 +103,7 @@ buggy or misconfigured virtualization manager or the
>  installer not having access to a network time server
>  during the installation process.  So by default, we allow
>  the superblock times to be fudged by up to 24 hours.
> +No repair action will be taken in this case.
>  This can be disabled by setting
>  .I accept_time_fudge
>  to the
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index a63e61c..c05ba4b 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -383,18 +383,6 @@ static struct e2fsck_problem problem_table[] = {
>  	  N_("The test_fs flag is set (and ext4 is available).  "),
>  	  PROMPT_CLEAR, PR_PREEN_OK },
>  
> -	/* Last mount time is in the future (fudged) */
> -	{ PR_0_FUTURE_SB_LAST_MOUNT_FUDGED,
> -	  N_("@S last mount time is in the future.\n\t(by less than a day, "
> -	     "probably due to the hardware clock being incorrectly set)  "),
> -	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
> -
> -	/* Last write time is in the future (fudged) */
> -	{ PR_0_FUTURE_SB_LAST_WRITE_FUDGED,
> -	  N_("@S last write time is in the future.\n\t(by less than a day, "
> -	     "probably due to the hardware clock being incorrectly set).  "),
> -	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
> -
>  	/* Block group checksum (latch question) is invalid. */
>  	{ PR_0_GDT_CSUM_LATCH,
>  	  N_("One or more @b @g descriptor checksums are invalid.  "),
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index 3c28166..4e8d76e 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -219,11 +219,11 @@ struct problem_context {
>  /* The test_fs filesystem flag is set and ext4 is available */
>  #define PR_0_CLEAR_TESTFS_FLAG			0x00003B
>  
> -/* Last mount time is in the future (fudged) */
> -#define PR_0_FUTURE_SB_LAST_MOUNT_FUDGED	0x00003C
> +/* Last mount time is in the future (fudged) -- NO LONGER USED */
> +/* #define PR_0_FUTURE_SB_LAST_MOUNT_FUDGED	0x00003C */
>  
> -/* Last write time is in the future (fudged) */
> -#define PR_0_FUTURE_SB_LAST_WRITE_FUDGED	0x00003D
> +/* Last write time is in the future (fudged) -- NO LONGER USED */
> +/* #define PR_0_FUTURE_SB_LAST_WRITE_FUDGED	0x00003D */
>  
>  /* Block group checksum (latch question) */
>  #define PR_0_GDT_CSUM_LATCH			0x00003E
> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index 1e7e749..4d7a3bf 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -856,11 +856,9 @@ void check_super_block(e2fsck_t ctx)
>  	 */
>  	if (!broken_system_clock &&
>  	    !(ctx->flags & E2F_FLAG_TIME_INSANE) &&
> -	    fs->super->s_mtime > (__u32) ctx->now) {
> +	    fs->super->s_mtime > (__u32) ctx->now + ctx->time_fudge) {
>  		pctx.num = fs->super->s_mtime;
>  		problem = PR_0_FUTURE_SB_LAST_MOUNT;
> -		if (fs->super->s_mtime <= (__u32) ctx->now + ctx->time_fudge)
> -			problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
>  		if (fix_problem(ctx, problem, &pctx)) {
>  			fs->super->s_mtime = ctx->now;
>  			fs->flags |= EXT2_FLAG_DIRTY;
> @@ -868,11 +866,9 @@ void check_super_block(e2fsck_t ctx)
>  	}
>  	if (!broken_system_clock &&
>  	    !(ctx->flags & E2F_FLAG_TIME_INSANE) &&
> -	    fs->super->s_wtime > (__u32) ctx->now) {
> +	    fs->super->s_wtime > (__u32) ctx->now + ctx->time_fudge) {
>  		pctx.num = fs->super->s_wtime;
>  		problem = PR_0_FUTURE_SB_LAST_WRITE;
> -		if (fs->super->s_wtime <= (__u32) ctx->now + ctx->time_fudge)
> -			problem = PR_0_FUTURE_SB_LAST_WRITE_FUDGED;
>  		if (fix_problem(ctx, problem, &pctx)) {
>  			fs->super->s_wtime = ctx->now;
>  			fs->flags |= EXT2_FLAG_DIRTY;
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
