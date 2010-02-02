From: Jan Kara <jack@suse.cz>
Subject: Re: Should we discard jbddirty bit if BH_Freed is set?
Date: Tue, 2 Feb 2010 23:02:01 +0100
Message-ID: <20100202220200.GM7056@quack.suse.cz>
References: <7bb361261001261832wb4f9ac2u96fdb6460aa45fa2@mail.gmail.com>
 <20100127122333.GA3149@quack.suse.cz>
 <7bb361261001271723n4fdad0e9l2171aa092baa0523@mail.gmail.com>
 <20100128125354.GA3124@quack.suse.cz>
 <7bb361261001281743h1ba743a4iada7f7cce5975eb3@mail.gmail.com>
 <7bb361261001292241t7dda80d8sc5f467677ad34954@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: =?utf-8?B?5LiB5a6a5Y2O?= <dingdinghua85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab0BBWBx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Feb 2010 17:01:53 -0500
Content-Disposition: inline
In-Reply-To: <7bb361261001292241t7dda80d8sc5f467677ad34954@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> From eb6567de576ac4a9337c3971a2d0549af64e15f0 Mon Sep 17 00:00:00 2001
> From: dingdinghua <dingdinghua@nrchpc.ac.cn>
> Date: Sat, 30 Jan 2010 14:23:28 +0800
> Subject: [PATCH] Jbd2: delay discarding buffers in journal_unmap_buffer
> 
> We should delay discarding buffers until we know that "add to orphan"
> operation has definitely been committed, otherwise the log space of
> committing transation may be freed and reused before truncate get
> committed, updates may get lost if crash happens.
  Thanks for the patch. For us to be able to merge the patch, we need a
Signed-off-by signature from you. Please add it in the next round of
submission.

> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 1bc74b6..c5d1c7c 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -936,8 +936,10 @@ restart_loop:
>  		 * behind for writeback and gets reallocated for another
>  		 * use in a different page. */
>  		if (buffer_freed(bh)) {
> -			clear_buffer_freed(bh);
> -			clear_buffer_jbddirty(bh);
> +			if (!jh->b_next_transaction) {
> +				clear_buffer_freed(bh);
> +				clear_buffer_jbddirty(bh);
> +			}
>  		}
  When can merge the 'if' here. Also the comment above this code
needs updating after your change.

>  		if (buffer_jbddirty(bh)) {
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index a051270..0d019f1 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1788,11 +1788,8 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
>  		 * running transaction if that is set, but nothing
>  		 * else. */
>  		set_buffer_freed(bh);
> -		if (jh->b_next_transaction) {
> -			J_ASSERT(jh->b_next_transaction ==
> -					journal->j_running_transaction);
> -			jh->b_next_transaction = NULL;
> -		}
> +		if (journal->j_running_transaction && buffer_jbddirty(bh))
> +			jh->b_next_transaction = journal->j_running_transaction;
  Also here you have to update the comment above set_buffer_freed to match
the new reality.
  Otherwise I'm fine with the patch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
