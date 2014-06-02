From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] e2fsck: make a prompt message translatable by not
 using fill-in words
Date: Mon, 2 Jun 2014 19:40:01 -0400
Message-ID: <20140602234001.GJ30598@thunk.org>
References: <1401738524-11455-1-git-send-email-bensberg@justemail.net>
 <1401738524-11455-2-git-send-email-bensberg@justemail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benno Schulenberg <bensberg@justemail.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46706 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbaFBXkD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2014 19:40:03 -0400
Content-Disposition: inline
In-Reply-To: <1401738524-11455-2-git-send-email-bensberg@justemail.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2014 at 09:48:42PM +0200, Benno Schulenberg wrote:
> Signed-off-by: Benno Schulenberg <bensberg@justemail.net>
> ---
>  e2fsck/journal.c |    1 -
>  e2fsck/problem.c |    2 +-
>  2 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index a7b1150..a3b3967 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -820,7 +820,6 @@ errcode_t e2fsck_check_ext3_journal(e2fsck_t ctx)
>  no_has_journal:
>  	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
>  		recover = sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER;
> -		pctx.str = "inode";
>  		if (fix_problem(ctx, PR_0_JOURNAL_HAS_JOURNAL, &pctx)) {
>  			if (recover &&
>  			    !fix_problem(ctx, PR_0_JOURNAL_RECOVER_SET, &pctx))
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 2b564a8..e393417 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -225,7 +225,7 @@ static struct e2fsck_problem problem_table[] = {
>  
>  	/* Superblock has_journal flag is clear but has a journal */
>  	{ PR_0_JOURNAL_HAS_JOURNAL,
> -	  N_("@S has_@j flag is clear, but a @j %s is present.\n"),
> +	  N_("@S has_@j flag is clear, but a @j @i is present.\n"),

It's probably better to just make this read "but a journal is
present".  The reason why we were doing the fill-in word was because
the intent was to be able to make the distinction between a journal
inode and an external journal device.  The intent was never realied,
and at this point it's better to just take out the specifity of
whether we are using a journal inode or a journal device.

	       	       	       	     - Ted
