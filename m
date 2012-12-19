From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: don't wake kjournald unnecessarily
Date: Wed, 19 Dec 2012 09:09:58 +0100
Message-ID: <20121219080958.GA20163@quack.suse.cz>
References: <50D0A1FD.7040203@redhat.com>
 <50D12DAA.9050700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Dave Wysochanski <dwysocha@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2LSIKJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Dec 2012 03:10:09 -0500
Content-Disposition: inline
In-Reply-To: <50D12DAA.9050700@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 18-12-12 20:59:54, Eric Sandeen wrote:
> Don't send an extra wakeup to kjournald in the case where we
> already have the proper target in j_commit_request, i.e. that
> transaction has already been requested for commit.
> 
> commit deeeaf13 "jbd2: fix fsync() tid wraparound bug" changed
> the logic leading to a wakeup, but it caused some extra wakeups
> which were found to lead to a measurable performance regression.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
  Looks good. You can add: Reviewed-by: Jan Kara <jack@suse.cz>

							Honza
> ---
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index dbf41f9..89970d5 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -518,7 +518,8 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t target)
>  	 * currently running transaction (if it exists).  Otherwise,
>  	 * the target tid must be an old one.
>  	 */
> -	if (journal->j_running_transaction &&
> +	if (journal->j_commit_request != target &&
> +	    journal->j_running_transaction &&
>  	    journal->j_running_transaction->t_tid == target) {
>  		/*
>  		 * We want a new commit: OK, mark the request and wakeup the
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
