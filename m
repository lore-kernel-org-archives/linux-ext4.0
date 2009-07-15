From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH]JBD2/JBD: race condition while writing updates to journal
Date: Wed, 15 Jul 2009 16:47:29 +0200
Message-ID: <20090715144729.GC22826@atrey.karlin.mff.cuni.cz>
References: <4A3F3B32.9090606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dingdinghua@nrchpc.ac.cn,
	dingdinghua <dingdinghua85@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38556 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbZGOOra (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 10:47:30 -0400
Content-Disposition: inline
In-Reply-To: <4A3F3B32.9090606@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Ted, I don't think this got merged...

								Honza
> resend this patch:
> 
> At committing phase, we call jbd2_journal_write_metadata_buffer to
> prepare log block's buffer_head, in this function, new_bh->b_data is set
> to b_frozen_data or bh_in->b_data. We call "jbd_unlock_bh_state(bh_in)"
> too early, since at this point , we haven't file bh_in to BJ_shadow
> list, and we may set new_bh->b_data to bh_in->b_data, at this time,
> another thread may call get write access of bh_in, modify bh_in->b_data
> and dirty it. So , if new_bh->b_data is set to bh_in->b_data, the
> committing transaction may flush the newly modified buffer content to
> disk, preserve work done in jbd2_journal_get_write_access is useless.
> jbd also has this problem.
> 
> here is the patch based on kernel version 2.6.30:
> 
> Signed-off-by: dingdinghua <dingdinghua@nrchpc.ac.cn>
> Acked-by: Jan Kara <jack@suse.cz>
> 
> ---
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 737f724..ff5dcb5 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -287,6 +287,7 @@ int journal_write_metadata_buffer(transaction_t *transaction,
>  	struct page *new_page;
>  	unsigned int new_offset;
>  	struct buffer_head *bh_in = jh2bh(jh_in);
> +	journal_t *journal = transaction->t_journal;
>  
>  	/*
>  	 * The buffer really shouldn't be locked: only the current committing
> @@ -300,6 +301,11 @@ int journal_write_metadata_buffer(transaction_t *transaction,
>  	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
>  
>  	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
> +	/* keep subsequent assertions sane */
> +	new_bh->b_state = 0;
> +	init_buffer(new_bh, NULL, NULL);
> +	atomic_set(&new_bh->b_count, 1);
> +	new_jh = journal_add_journal_head(new_bh);	/* This sleeps */
>  
>  	/*
>  	 * If a new transaction has already done a buffer copy-out, then
> @@ -361,14 +367,6 @@ repeat:
>  		kunmap_atomic(mapped_data, KM_USER0);
>  	}
>  
> -	/* keep subsequent assertions sane */
> -	new_bh->b_state = 0;
> -	init_buffer(new_bh, NULL, NULL);
> -	atomic_set(&new_bh->b_count, 1);
> -	jbd_unlock_bh_state(bh_in);
> -
> -	new_jh = journal_add_journal_head(new_bh);	/* This sleeps */
> -
>  	set_bh_page(new_bh, new_page, new_offset);
>  	new_jh->b_transaction = NULL;
>  	new_bh->b_size = jh2bh(jh_in)->b_size;
> @@ -385,7 +383,11 @@ repeat:
>  	 * copying is moved to the transaction's shadow queue.
>  	 */
>  	JBUFFER_TRACE(jh_in, "file as BJ_Shadow");
> -	journal_file_buffer(jh_in, transaction, BJ_Shadow);
> +	spin_lock(&journal->j_list_lock);
> +	__journal_file_buffer(jh_in, transaction, BJ_Shadow);
> +	spin_unlock(&journal->j_list_lock);
> +	jbd_unlock_bh_state(bh_in);
> +
>  	JBUFFER_TRACE(new_jh, "file as BJ_IO");
>  	journal_file_buffer(new_jh, transaction, BJ_IO);
>  
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 18bfd5d..4a0b48f 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -297,6 +297,8 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  	unsigned int new_offset;
>  	struct buffer_head *bh_in = jh2bh(jh_in);
>  	struct jbd2_buffer_trigger_type *triggers;
> +	journal_t *journal = transaction->t_journal;
> +
>  
>  	/*
>  	 * The buffer really shouldn't be locked: only the current committing
> @@ -310,6 +312,11 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
>  
>  	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
> +	/* keep subsequent assertions sane */
> +	new_bh->b_state = 0;
> +	init_buffer(new_bh, NULL, NULL);
> +	atomic_set(&new_bh->b_count, 1);
> +	new_jh = jbd2_journal_add_journal_head(new_bh);	/* This sleeps */
>  
>  	/*
>  	 * If a new transaction has already done a buffer copy-out, then
> @@ -388,14 +395,6 @@ repeat:
>  		kunmap_atomic(mapped_data, KM_USER0);
>  	}
>  
> -	/* keep subsequent assertions sane */
> -	new_bh->b_state = 0;
> -	init_buffer(new_bh, NULL, NULL);
> -	atomic_set(&new_bh->b_count, 1);
> -	jbd_unlock_bh_state(bh_in);
> -
> -	new_jh = jbd2_journal_add_journal_head(new_bh);	/* This sleeps */
> -
>  	set_bh_page(new_bh, new_page, new_offset);
>  	new_jh->b_transaction = NULL;
>  	new_bh->b_size = jh2bh(jh_in)->b_size;
> @@ -412,7 +411,11 @@ repeat:
>  	 * copying is moved to the transaction's shadow queue.
>  	 */
>  	JBUFFER_TRACE(jh_in, "file as BJ_Shadow");
> -	jbd2_journal_file_buffer(jh_in, transaction, BJ_Shadow);
> +	spin_lock(&journal->j_list_lock);
> +	__jbd2_journal_file_buffer(jh_in, transaction, BJ_Shadow);
> +	spin_unlock(&journal->j_list_lock);
> +	jbd_unlock_bh_state(bh_in);
> +
>  	JBUFFER_TRACE(new_jh, "file as BJ_IO");
>  	jbd2_journal_file_buffer(new_jh, transaction, BJ_IO);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
