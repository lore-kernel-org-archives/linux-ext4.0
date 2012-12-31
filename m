From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/jbd: set pointer = NULL, after kfree it.
Date: Mon, 31 Dec 2012 16:23:12 +0100
Message-ID: <20121231152312.GF7564@quack.suse.cz>
References: <50D7C04B.6010109@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-ext4@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab2LaPXN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Dec 2012 10:23:13 -0500
Content-Disposition: inline
In-Reply-To: <50D7C04B.6010109@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-12-12 10:39:07, Chen Gang wrote:
> 
>   set pointer = NULL, after call journal_destroy_revoke_table.
>     in journal_destroy_revoke_table, it will call kfree to free the buffer.
  The journal structure will get freed immediately after we return from
journal_init_revoke() (in case it failed) or journal_destroy_revoke() so I
don't see a point in setting the pointers to NULL. Or do I miss something?

								Honza
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  fs/jbd/revoke.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
> index 25c713e..d6457b0 100644
> --- a/fs/jbd/revoke.c
> +++ b/fs/jbd/revoke.c
> @@ -295,6 +295,7 @@ int journal_init_revoke(journal_t *journal, int hash_size)
>  
>  fail1:
>  	journal_destroy_revoke_table(journal->j_revoke_table[0]);
> +	journal->j_revoke_table[0] = NULL;
>  fail0:
>  	return -ENOMEM;
>  }
> @@ -303,10 +304,14 @@ fail0:
>  void journal_destroy_revoke(journal_t *journal)
>  {
>  	journal->j_revoke = NULL;
> -	if (journal->j_revoke_table[0])
> +	if (journal->j_revoke_table[0]) {
>  		journal_destroy_revoke_table(journal->j_revoke_table[0]);
> -	if (journal->j_revoke_table[1])
> +		journal->j_revoke_table[0] = NULL;
> +	}
> +	if (journal->j_revoke_table[1]) {
>  		journal_destroy_revoke_table(journal->j_revoke_table[1]);
> +		journal->j_revoke_table[1] = NULL;
> +	}
>  }
>  
>  
> -- 
> 1.7.10.4
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
