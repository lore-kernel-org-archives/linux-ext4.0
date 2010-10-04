From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Simplify return path of journal_init_common()
Date: Mon, 4 Oct 2010 11:47:47 +0200
Message-ID: <20101004094747.GD3589@quack.suse.cz>
References: <1286171398-3479-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab0JDJsl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Oct 2010 05:48:41 -0400
Content-Disposition: inline
In-Reply-To: <1286171398-3479-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 04-10-10 14:49:58, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/jbd/journal.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 2c4b1f1..6f20a75 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -698,7 +698,7 @@ static journal_t * journal_init_common (void)
>  
>  	journal = kzalloc(sizeof(*journal), GFP_KERNEL);
>  	if (!journal)
> -		goto fail;
> +		goto out;
>  
>  	init_waitqueue_head(&journal->j_wait_transaction_locked);
>  	init_waitqueue_head(&journal->j_wait_logspace);
> @@ -721,11 +721,10 @@ static journal_t * journal_init_common (void)
>  	err = journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
>  	if (err) {
>  		kfree(journal);
> -		goto fail;
> +		journal = NULL;
>  	}
> +out:
>  	return journal;
> -fail:
> -	return NULL;
  If you want to do something like this (but frankly I'm not so convinced
that the cleanup is worth the code churn), then just do directly
"return NULL". The function is simple enough... Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
