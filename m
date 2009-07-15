From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fix race bwtween write_metadata_buffer and get_write_access
Date: Wed, 15 Jul 2009 21:44:04 +0200
Message-ID: <20090715194404.GI22826@atrey.karlin.mff.cuni.cz>
References: <1247132827-29614-1-git-send-email-dingdinghua85@gmail.com> <20090713144128.GA28970@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dingdinghua <dingdinghua85@gmail.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39429 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbZGOToF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 15:44:05 -0400
Content-Disposition: inline
In-Reply-To: <20090713144128.GA28970@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, Jul 09, 2009 at 05:47:07PM +0800, dingdinghua wrote:
> > At committing phase, we call jbd2_journal_write_metadata_buffer to
> > prepare log block's buffer_head, in this function, new_bh->b_data is set
> > to b_frozen_data or bh_in->b_data. We call "jbd_unlock_bh_state(bh_in)"
> > too early, since at this point , we haven't file bh_in to BJ_shadow
> > list, and we may set new_bh->b_data to bh_in->b_data, at this time,
> > another thread may call get write access of bh_in, modify bh_in->b_data
> > and dirty it. So , if new_bh->b_data is set to bh_in->b_data, the
> > committing transaction may flush the newly modified buffer content to
> > disk, preserve work done in jbd2_journal_get_write_access is useless.
> > jbd also has this problem.
> 
> Hi Dingding,
> 
> I split your patch into two pieces; one for jbd2 (which is in the ext4
> patch queue), and one for jbd (which is attached here).  The jbd2
> patch (along with recently added patches to the ext4 patch queue) is
> undergoing testing as we speak.
> 
> Both patches look good to me, but for the ext3/jbd one, it should
> probably get a second opinion.  Andrew, can take a quick peek?
  The patch looks fine. I've added it to my tree for merging.

								Honza
> 
> jbd: fix race bwtween write_metadata_buffer and get_write_access
> 
> From: dingdinghua <dingdinghua85@gmail.com>
> 
> The function journal_write_metadata_buffer() calls
> jbd_unlock_bh_state(bh_in) too early; this could potentially allow
> another thread to call get_write_access on the buffer head, modify the
> data, and dirty it, and allowing the wrong data to be written into the
> journal.  Fortunately, if we lose this race, the only time this will
> actually cause filesystem corruption is if there is a system crash or
> other unclean shutdown of the system before the next commit can take
> place.
> 
> Signed-off-by: dingdinghua <dingdinghua85@gmail.com>
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
