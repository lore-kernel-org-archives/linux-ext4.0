From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Convert bitops to buffer fns
Date: Fri, 8 Oct 2010 17:26:04 +0200
Message-ID: <20101008152604.GA20805@quack.suse.cz>
References: <1286535906-8215-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56122 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab0JHP1B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Oct 2010 11:27:01 -0400
Content-Disposition: inline
In-Reply-To: <1286535906-8215-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 08-10-10 20:05:06, Namhyung Kim wrote:
> Convert set/clear_bit(BH_JWrite, ...) to set/clear_buffer_jwrite()
> for consistency.
  Thanks. Merged.

								Honza

> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/jbd/commit.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
> index 95d8c11..c842832 100644
> --- a/fs/jbd/commit.c
> +++ b/fs/jbd/commit.c
> @@ -617,7 +617,7 @@ void journal_commit_transaction(journal_t *journal)
>                     (this will requeue both the metadata buffer and the
>                     temporary IO buffer). new_bh goes on BJ_IO*/
>  
> -		set_bit(BH_JWrite, &jh2bh(jh)->b_state);
> +		set_buffer_jwrite(jh2bh(jh));
>  		/*
>  		 * akpm: journal_write_metadata_buffer() sets
>  		 * new_bh->b_transaction to commit_transaction.
> @@ -627,7 +627,7 @@ void journal_commit_transaction(journal_t *journal)
>  		JBUFFER_TRACE(jh, "ph3: write metadata");
>  		flags = journal_write_metadata_buffer(commit_transaction,
>  						      jh, &new_jh, blocknr);
> -		set_bit(BH_JWrite, &jh2bh(new_jh)->b_state);
> +		set_buffer_jwrite(jh2bh(new_jh));
>  		wbuf[bufs++] = jh2bh(new_jh);
>  
>  		/* Record the new block's tag in the current descriptor
> @@ -737,7 +737,7 @@ wait_for_iobuf:
>                     shadowed buffer */
>  		jh = commit_transaction->t_shadow_list->b_tprev;
>  		bh = jh2bh(jh);
> -		clear_bit(BH_JWrite, &bh->b_state);
> +		clear_buffer_jwrite(bh);
>  		J_ASSERT_BH(bh, buffer_jbddirty(bh));
>  
>  		/* The metadata is now released for reuse, but we need
> -- 
> 1.7.2.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
