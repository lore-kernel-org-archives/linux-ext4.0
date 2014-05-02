From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 11/37] e2fsck: fix the extended attribute checksum error
 message
Date: Fri, 2 May 2014 14:46:56 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405021445200.2154@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231334.31890.49878.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbaEBMrD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2014 08:47:03 -0400
In-Reply-To: <20140501231334.31890.49878.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 May 2014, Darrick J. Wong wrote:

> Date: Thu, 01 May 2014 16:13:34 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 11/37] e2fsck: fix the extended attribute checksum error
>     message
> 
> Make the "EA block passes checks but fails checksum" message less
> strange.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  e2fsck/problem.c |   12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 0999399..ec20bd1 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -992,19 +992,17 @@ static struct e2fsck_problem problem_table[] = {
>  	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
>  	  PROMPT_FIX, 0 },
>  
> -	/* Extended attribute block checksum for inode does not match. */
> +	/* Extended attribute block checksum does not match. */

The "for inode" is still there in the message, so I do not think
there is a reason to remove it from the comment.

>  	{ PR_1_EA_BLOCK_CSUM_INVALID,
> -	  N_("Extended attribute @a @b %b checksum for @i %i does not "
> -	     "match.  "),
> +	  N_("@a @b %b checksum for @i %i does not match.  "),
>  	  PROMPT_CLEAR, PR_INITIAL_CSUM },
>  
>  	/*
> -	 * Extended attribute block passes checks, but checksum for inode does
> -	 * not match.
> +	 * Extended attribute block passes checks, but checksum does not
> +	 * match.
>  	 */
>  	{ PR_1_EA_BLOCK_ONLY_CSUM_INVALID,
> -	  N_("Extended attribute @a @b %b passes checks, but checksum for "
> -	     "@i %i does not match.  "),
> +	  N_("@a @b %b passes checks, but checksum does not match.  "),

Is there a reason to remove the inode number from the message ?

Thanks!
-Lukas

>  	  PROMPT_FIX, 0 },
>  
>  	/*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
