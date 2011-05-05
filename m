From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd/jbd2: remove obsolete summarise_journal_usage.
Date: Thu, 5 May 2011 18:14:54 +0200
Message-ID: <20110505161454.GM5323@quack.suse.cz>
References: <1304610859-480-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab1EEQPB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 12:15:01 -0400
Content-Disposition: inline
In-Reply-To: <1304610859-480-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 05-05-11 23:54:19, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> summarise_journal_usage seems to be obsolete for a long time,
> so remove it.
  Yes. Added to my tree. Thanks.

								Honza
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/jbd/commit.c  |    6 ------
>  fs/jbd2/commit.c |    6 ------
>  2 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
> index 69b1804..9cbf9e4 100644
> --- a/fs/jbd/commit.c
> +++ b/fs/jbd/commit.c
> @@ -302,12 +302,6 @@ void journal_commit_transaction(journal_t *journal)
>  	 * all outstanding updates to complete.
>  	 */
>  
> -#ifdef COMMIT_STATS
> -	spin_lock(&journal->j_list_lock);
> -	summarise_journal_usage(journal);
> -	spin_unlock(&journal->j_list_lock);
> -#endif
> -
>  	/* Do we need to erase the effects of a prior journal_flush? */
>  	if (journal->j_flags & JFS_FLUSHED) {
>  		jbd_debug(3, "super block updated\n");
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 6e28000..29148a8 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -338,12 +338,6 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	 * all outstanding updates to complete.
>  	 */
>  
> -#ifdef COMMIT_STATS
> -	spin_lock(&journal->j_list_lock);
> -	summarise_journal_usage(journal);
> -	spin_unlock(&journal->j_list_lock);
> -#endif
> -
>  	/* Do we need to erase the effects of a prior jbd2_journal_flush? */
>  	if (journal->j_flags & JBD2_FLUSHED) {
>  		jbd_debug(3, "super block updated\n");
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
