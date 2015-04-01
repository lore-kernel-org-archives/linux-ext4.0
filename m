From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] e2fsck: completely ignore last-mount and last-write
 within fudge_time
Date: Wed, 1 Apr 2015 15:06:42 +0200
Message-ID: <20150401130642.GL26339@quack.suse.cz>
References: <5509DCE4.1010706@redhat.com>
 <20150329023226.GA19097@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbbDANGq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Apr 2015 09:06:46 -0400
Content-Disposition: inline
In-Reply-To: <20150329023226.GA19097@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 28-03-15 22:32:26, Ted Tso wrote:
> I'm a bit more partial to this method of fixing the issue.
> 
> What do folks think?
> 
>       	       	       	       	      	 - Ted
> 					 
> commit f096708126412c0569e40cfbd5740729976bf12a
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sat Mar 28 21:39:54 2015 -0400
> 
>     e2fsck: use PROMPT_NONE for FUTURE_SB_LAST_*_FUDGED problems
>     
>     This allows us to print a message warning the user that there is
>     something funny going on with their hardware clock (probably time zone
>     issues caused by trying to be compatible with legacy OS's such as
>     Windows), without triggering a full file system check.
>     
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
  OK, so this will just print the error but won't fix it unless in preen
or full check mode. Am I right. That sounds fine to me.

								Honza

> 
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 12cf836..f442a33 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -386,14 +386,14 @@ static struct e2fsck_problem problem_table[] = {
>  	/* Last mount time is in the future (fudged) */
>  	{ PR_0_FUTURE_SB_LAST_MOUNT_FUDGED,
>  	  N_("@S last mount time is in the future.\n\t(by less than a day, "
> -	     "probably due to the hardware clock being incorrectly set)  "),
> -	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
> +	     "probably due to the hardware clock being incorrectly set)\n"),
> +	  PROMPT_NONE, PR_PREEN_OK | PR_NO_OK },
>  
>  	/* Last write time is in the future (fudged) */
>  	{ PR_0_FUTURE_SB_LAST_WRITE_FUDGED,
>  	  N_("@S last write time is in the future.\n\t(by less than a day, "
> -	     "probably due to the hardware clock being incorrectly set).  "),
> -	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
> +	     "probably due to the hardware clock being incorrectly set)\n"),
> +	  PROMPT_NONE, PR_PREEN_OK | PR_NO_OK },
>  
>  	/* Block group checksum (latch question) is invalid. */
>  	{ PR_0_GDT_CSUM_LATCH,
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
