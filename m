From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/1] jbd2: fix incorrect unlock on j_list_lock
Date: Wed, 18 Mar 2015 11:43:21 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1503181142160.23465@localhost.localdomain>
References: <1426644518-29680-1-git-send-email-tsgatesv@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, taesoo@gatech.edu,
	changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu,
	csong84@gatech.edu
To: Taesoo Kim <tsgatesv@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbbCRKn0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2015 06:43:26 -0400
In-Reply-To: <1426644518-29680-1-git-send-email-tsgatesv@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 17 Mar 2015, Taesoo Kim wrote:

> Date: Tue, 17 Mar 2015 22:08:38 -0400
> From: Taesoo Kim <tsgatesv@gmail.com>
> To: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
> Cc: taesoo@gatech.edu, changwoo@gatech.edu, sanidhya@gatech.edu,
>     blee@gatech.edu, csong84@gatech.edu, Taesoo Kim <tsgatesv@gmail.com>
> Subject: [PATCH 1/1] jbd2: fix incorrect unlock on j_list_lock
> 
> When 'jh->b_transaction == transaction' (asserted by below)
> 
>   J_ASSERT_JH(jh, (jh->b_transaction == transaction || ...
> 
> 'journal->j_list_lock' will be incorrectly unlocked, since
> the the lock is aquired only at the end of if / else-if
> statements (missing the else case).

The patch looks good, thanks.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Btw, were you able to reproduce the problem, or have you seen the
problem in the wild ? Or did you just spot it in the code ?

Thanks!
-Lukas

> 
> Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>
> ---
>  fs/jbd2/transaction.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 5f09370..edb7f59 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1091,6 +1091,7 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
>  		JBUFFER_TRACE(jh, "file as BJ_Reserved");
>  		spin_lock(&journal->j_list_lock);
>  		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
> +		spin_unlock(&journal->j_list_lock);
>  	} else if (jh->b_transaction == journal->j_committing_transaction) {
>  		/* first access by this transaction */
>  		jh->b_modified = 0;
> @@ -1098,8 +1099,8 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
>  		JBUFFER_TRACE(jh, "set next transaction");
>  		spin_lock(&journal->j_list_lock);
>  		jh->b_next_transaction = transaction;
> +		spin_unlock(&journal->j_list_lock);
>  	}
> -	spin_unlock(&journal->j_list_lock);
>  	jbd_unlock_bh_state(bh);
> 
>  	/*
> --
> 2.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
