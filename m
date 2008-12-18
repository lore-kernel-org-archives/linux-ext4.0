From: Jan Kara <jack@suse.cz>
Subject: Re: [Ocfs2-devel] [PATCH 01/18] jbd2: Add buffer triggers
Date: Thu, 18 Dec 2008 19:08:21 +0100
Message-ID: <20081218180820.GC6797@atrey.karlin.mff.cuni.cz>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com> <1228871395-10273-2-git-send-email-joel.becker@oracle.com> <20081213004512.GD15241@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ocfs2-devel@oss.oracle.com, mfasheh@suse.com,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57927 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYLRSIW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 13:08:22 -0500
Content-Disposition: inline
In-Reply-To: <20081213004512.GD15241@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Tue, Dec 09, 2008 at 05:09:38PM -0800, Joel Becker wrote:
> > Filesystems often to do compute intensive operation on some
> > metadata.  If this operation is repeated many times, it can be very
> > expensive.  It would be much nicer if the operation could be performed
> > once before a buffer goes to disk.
> 
> 	I realized, well, that I'm an idiot.  The previous patch has a
> significant bug: what if a block is deallocated, then reused as a
> different type of metadata, all before the committing transaction gets
> around to firing the triggers?  It could use the new block type's
> triggers against the b_frozen_data of the old block type.
> 	The easy answer is to add b_frozen_triggers alongside
> b_frozen_data.  Here's the new patch.
  I think this is a reasonable thing to do, although I'm not sure it can
really happen - at least ext3 uses a mechanism that does not allow
reusing a freed block in the same transaction (because otherwise there's
no way of recovering unjournaled data after crash).

> 	We'd like to submit this for the merge window with the ocfs2
> meteaecc code.  We'll do that via ocfs2.git, as Ted recommended.

> 
> Joel
> 
> >From 23662f70a948a142be96070ead435b098318a1df Mon Sep 17 00:00:00 2001
> From: Joel Becker <joel.becker@oracle.com>
> Date: Thu, 11 Sep 2008 15:35:47 -0700
> Subject: [PATCH] jbd2: Add buffer triggers
> 
> Filesystems often to do compute intensive operation on some
> metadata.  If this operation is repeated many times, it can be very
> expensive.  It would be much nicer if the operation could be performed
> once before a buffer goes to disk.
> 
> This adds triggers to jbd2 buffer heads.  Just before writing a metadata
> buffer to the journal, jbd2 will optionally call a commit trigger associated
> with the buffer.  If the journal is aborted, an abort trigger will be
> called on any dirty buffers as they are dropped from pending
> transactions.
> 
> ocfs2 will use this feature.
> 
> Initially I tried to come up with a more generic trigger that could be
> used for non-buffer-related events like transaction completion.  It
> doesn't tie nicely, because the information a buffer trigger needs
> (specific to a journal_head) isn't the same as what a transaction
> trigger needs (specific to a tranaction_t or perhaps journal_t).  So I
> implemented a buffer set, with the understanding that
> journal/transaction wide triggers should be implemented separately.
> 
> There is only one trigger set allowed per buffer.  I can't think of any
> reason to attach more than one set.  Contrast this with a journal or
> transaction in which multiple places may want to watch the entire
> transaction separately.
> 
> The trigger sets are considered static allocation from the jbd2
> perspective.  ocfs2 will just have one trigger set per block type,
> setting the same set on every bh of the same type.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: <linux-ext4@vger.kernel.org>
> ---
>  fs/jbd2/commit.c             |    9 ++++++++
>  fs/jbd2/journal.c            |   19 +++++++++++++++++
>  fs/jbd2/transaction.c        |   47 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/jbd2.h         |   31 +++++++++++++++++++++++++++
>  include/linux/journal-head.h |    8 +++++++
>  5 files changed, 114 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index ebc667b..c8a1bac 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -509,6 +509,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  		if (is_journal_aborted(journal)) {
>  			clear_buffer_jbddirty(jh2bh(jh));
>  			JBUFFER_TRACE(jh, "journal is aborting: refile");
> +			jbd2_buffer_abort_trigger(jh,
> +						  jh->b_frozen_data ?
> +						  jh->b_frozen_triggers :
> +						  jh->b_triggers);
  Wouldn't it be nicer if the jbd2_buffer_foo_trigger() functions
checked which set of triggers they should use and used it?

>  			jbd2_journal_refile_buffer(journal, jh);
>  			/* If that was the last one, we need to clean up
>  			 * any descriptor buffers which may have been
> @@ -844,6 +848,9 @@ restart_loop:
>  		 * data.
>  		 *
>  		 * Otherwise, we can just throw away the frozen data now.
> +		 *
> +		 * We also know that the frozen data has already fired
> +		 * its triggers if they exist, so we can clear that too.
>  		 */
>  		if (jh->b_committed_data) {
>  			jbd2_free(jh->b_committed_data, bh->b_size);
> @@ -851,10 +858,12 @@ restart_loop:
>  			if (jh->b_frozen_data) {
>  				jh->b_committed_data = jh->b_frozen_data;
>  				jh->b_frozen_data = NULL;
> +				jh->b_frozen_triggers = NULL;
>  			}
>  		} else if (jh->b_frozen_data) {
>  			jbd2_free(jh->b_frozen_data, bh->b_size);
>  			jh->b_frozen_data = NULL;
> +			jh->b_frozen_triggers = NULL;
>  		}
>  
>  		spin_lock(&journal->j_list_lock);
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index e70d657..f6bff9d 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -50,6 +50,7 @@ EXPORT_SYMBOL(jbd2_journal_unlock_updates);
>  EXPORT_SYMBOL(jbd2_journal_get_write_access);
>  EXPORT_SYMBOL(jbd2_journal_get_create_access);
>  EXPORT_SYMBOL(jbd2_journal_get_undo_access);
> +EXPORT_SYMBOL(jbd2_journal_set_triggers);
>  EXPORT_SYMBOL(jbd2_journal_dirty_metadata);
>  EXPORT_SYMBOL(jbd2_journal_release_buffer);
>  EXPORT_SYMBOL(jbd2_journal_forget);
> @@ -290,6 +291,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  	struct page *new_page;
>  	unsigned int new_offset;
>  	struct buffer_head *bh_in = jh2bh(jh_in);
> +	struct jbd2_buffer_trigger_type *triggers;
>  
>  	/*
>  	 * The buffer really shouldn't be locked: only the current committing
> @@ -314,13 +316,23 @@ repeat:
>  		done_copy_out = 1;
>  		new_page = virt_to_page(jh_in->b_frozen_data);
>  		new_offset = offset_in_page(jh_in->b_frozen_data);
> +		triggers = jh_in->b_frozen_triggers;
>  	} else {
>  		new_page = jh2bh(jh_in)->b_page;
>  		new_offset = offset_in_page(jh2bh(jh_in)->b_data);
> +		triggers = jh_in->b_triggers;
>  	}
>  
>  	mapped_data = kmap_atomic(new_page, KM_USER0);
>  	/*
> +	 * Fire any commit trigger.  Do this before checking for escaping,
> +	 * as the trigger may modify the magic offset.  If a copy-out
> +	 * happens afterwards, it will have the correct data in the buffer.
> +	 */
> +	jbd2_buffer_commit_trigger(jh_in, mapped_data + new_offset,
> +				   triggers);
> +
> +	/*
>  	 * Check for escaping
>  	 */
>  	if (*((__be32 *)(mapped_data + new_offset)) ==
> @@ -352,6 +364,13 @@ repeat:
>  		new_page = virt_to_page(tmp);
>  		new_offset = offset_in_page(tmp);
>  		done_copy_out = 1;
> +
> +		/*
> +		 * This isn't strictly necessary, as we're using frozen
> +		 * data for the escaping, but it keeps consistency with
> +		 * b_frozen_data usage.
> +		 */
> +		jh_in->b_frozen_triggers = jh_in->b_triggers;
>  	}
>  
>  	/*
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 39b7805..4f925a4 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -741,6 +741,12 @@ done:
>  		source = kmap_atomic(page, KM_USER0);
>  		memcpy(jh->b_frozen_data, source+offset, jh2bh(jh)->b_size);
>  		kunmap_atomic(source, KM_USER0);
> +
> +		/*
> +		 * Now that the frozen data is saved off, we need to store
> +		 * any matching triggers.
> +		 */
> +		jh->b_frozen_triggers = jh->b_triggers;
>  	}
>  	jbd_unlock_bh_state(bh);
>  
> @@ -944,6 +950,47 @@ out:
>  }
>  
>  /**
> + * void jbd2_journal_set_triggers() - Add triggers for commit writeout
> + * @bh: buffer to trigger on
> + * @type: struct jbd2_buffer_trigger_type containing the trigger(s).
> + *
> + * Set any triggers on this journal_head.  This is always safe, because
> + * triggers for a committing buffer will be saved off, and triggers for
> + * a running transaction will match the buffer in that transaction.
> + *
> + * Call with NULL to clear the triggers.
> + */
> +void jbd2_journal_set_triggers(struct buffer_head *bh,
> +			       struct jbd2_buffer_trigger_type *type)
> +{
> +	struct journal_head *jh = bh2jh(bh);
> +
> +	jh->b_triggers = type;
> +}
> +
> +void jbd2_buffer_commit_trigger(struct journal_head *jh, void *mapped_data,
> +				struct jbd2_buffer_trigger_type *triggers)
> +{
> +	struct buffer_head *bh = jh2bh(jh);
> +
> +	if (!triggers || !triggers->t_commit)
> +		return;
> +
> +	triggers->t_commit(triggers, bh, mapped_data, bh->b_size);
> +}
> +
> +void jbd2_buffer_abort_trigger(struct journal_head *jh,
> +			       struct jbd2_buffer_trigger_type *triggers)
> +{
> +	if (!triggers || !triggers->t_abort)
> +		return;
> +
> +	triggers->t_abort(triggers, jh2bh(jh));
> +}
> +
> +
> +
> +/**
>   * int jbd2_journal_dirty_metadata() -  mark a buffer as containing dirty metadata
>   * @handle: transaction to add buffer to.
>   * @bh: buffer to mark
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index f366457..3445647 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1008,6 +1008,35 @@ int __jbd2_journal_clean_checkpoint_list(journal_t *journal);
>  int __jbd2_journal_remove_checkpoint(struct journal_head *);
>  void __jbd2_journal_insert_checkpoint(struct journal_head *, transaction_t *);
>  
> +
> +/*
> + * Triggers
> + */
> +
> +struct jbd2_buffer_trigger_type {
> +	/*
> +	 * Fired just before a buffer is written to the journal.
> +	 * mapped_data is a mapped buffer that is the frozen data for
> +	 * commit.
> +	 */
> +	void (*t_commit)(struct jbd2_buffer_trigger_type *type,
> +			 struct buffer_head *bh, void *mapped_data,
> +			 size_t size);
> +
> +	/*
> +	 * Fired during journal abort for dirty buffers that will not be
> +	 * committed.
> +	 */
> +	void (*t_abort)(struct jbd2_buffer_trigger_type *type,
> +			struct buffer_head *bh);
> +};
> +
> +extern void jbd2_buffer_commit_trigger(struct journal_head *jh,
> +				       void *mapped_data,
> +				       struct jbd2_buffer_trigger_type *triggers);
> +extern void jbd2_buffer_abort_trigger(struct journal_head *jh,
> +				      struct jbd2_buffer_trigger_type *triggers);
> +
>  /* Buffer IO */
>  extern int
>  jbd2_journal_write_metadata_buffer(transaction_t	  *transaction,
> @@ -1046,6 +1075,8 @@ extern int	 jbd2_journal_extend (handle_t *, int nblocks);
>  extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
>  extern int	 jbd2_journal_get_create_access (handle_t *, struct buffer_head *);
>  extern int	 jbd2_journal_get_undo_access(handle_t *, struct buffer_head *);
> +void		 jbd2_journal_set_triggers(struct buffer_head *,
> +					   struct jbd2_buffer_trigger_type *type);
>  extern int	 jbd2_journal_dirty_metadata (handle_t *, struct buffer_head *);
>  extern void	 jbd2_journal_release_buffer (handle_t *, struct buffer_head *);
>  extern int	 jbd2_journal_forget (handle_t *, struct buffer_head *);
> diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
> index bb70ebb..525aac3 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -12,6 +12,8 @@
>  
>  typedef unsigned int		tid_t;		/* Unique transaction ID */
>  typedef struct transaction_s	transaction_t;	/* Compound transaction type */
> +
> +
>  struct buffer_head;
>  
>  struct journal_head {
> @@ -87,6 +89,12 @@ struct journal_head {
>  	 * [j_list_lock]
>  	 */
>  	struct journal_head *b_cpnext, *b_cpprev;
> +
> +	/* Trigger type */
> +	struct jbd2_buffer_trigger_type *b_triggers;
> +
> +	/* Trigger type for the committing transaction's frozen data */
> +	struct jbd2_buffer_trigger_type *b_frozen_triggers;
>  };
>  
>  #endif		/* JOURNAL_HEAD_H_INCLUDED */
  Otherwise the patch looks nice.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
