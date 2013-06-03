From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/6] jbd2: optimize jbd2_journal_force_commit
Date: Mon, 03 Jun 2013 15:16:38 +0400
Message-ID: <87ppw3fnqh.fsf@openvz.org>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org> <1369732741-26070-2-git-send-email-dmonakhov@openvz.org> <20130528212205.GB16408@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:60691 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3FCLQm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jun 2013 07:16:42 -0400
Received: by mail-la0-f41.google.com with SMTP id fn20so350648lab.0
        for <linux-ext4@vger.kernel.org>; Mon, 03 Jun 2013 04:16:41 -0700 (PDT)
In-Reply-To: <20130528212205.GB16408@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 28 May 2013 23:22:05 +0200, Jan Kara <jack@suse.cz> wrote:
> On Tue 28-05-13 13:18:56, Dmitry Monakhov wrote:
> > Current implementation of jbd2_journal_force_commit() is suboptimal because
> > result in empty and useless commits. But callers just want to force and wait
> > any unfinished commits. We already has jbd2_journal_force_commit_nested()
> > which does exactly what we want, except we are guaranteed that we do not hold
> > journal transaction open.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>   Hum, didn't I already review something like this?
Off course you did. As result you have pointed an incorrect error value.
This was fixed in this version.
> 
> > ---
> >  fs/jbd2/journal.c     |   55 ++++++++++++++++++++++++++++++++++++------------
> >  fs/jbd2/transaction.c |   23 --------------------
> >  include/linux/jbd2.h  |    2 +-
> >  3 files changed, 42 insertions(+), 38 deletions(-)
> > 
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 886ec2f..078e8ea 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -566,21 +566,19 @@ int jbd2_log_start_commit(journal_t *journal, tid_t tid)
> >  }
> >  
> >  /*
> > - * Force and wait upon a commit if the calling process is not within
> > - * transaction.  This is used for forcing out undo-protected data which contains
> > - * bitmaps, when the fs is running out of space.
> > - *
> > - * We can only force the running transaction if we don't have an active handle;
> > - * otherwise, we will deadlock.
> > - *
> > - * Returns true if a transaction was started.
> > + * Force and wait any uncommitted transactions.  We can only force the running
> > + * transaction if we don't have an active handle, otherwise, we will deadlock.
> >   */
> > -int jbd2_journal_force_commit_nested(journal_t *journal)
> > +int __jbd2_journal_force_commit(journal_t *journal, int nested, int *progress)
> >  {
> >  	transaction_t *transaction = NULL;
> >  	tid_t tid;
> > -	int need_to_start = 0;
> > +	int need_to_start = 0, ret = 0;
> >  
> > +	J_ASSERT(!current->journal_info || nested);
> > +
> > +	if (progress)
> > +		*progress = 0;
> >  	read_lock(&journal->j_state_lock);
> >  	if (journal->j_running_transaction && !current->journal_info) {
> >  		transaction = journal->j_running_transaction;
> > @@ -590,16 +588,45 @@ int jbd2_journal_force_commit_nested(journal_t *journal)
> >  		transaction = journal->j_committing_transaction;
> >  
> >  	if (!transaction) {
> > +		/* Nothing to commit */
> >  		read_unlock(&journal->j_state_lock);
> > -		return 0;	/* Nothing to retry */
> > +		return 0;
> >  	}
> > -
> >  	tid = transaction->t_tid;
> >  	read_unlock(&journal->j_state_lock);
> >  	if (need_to_start)
> >  		jbd2_log_start_commit(journal, tid);
> > -	jbd2_log_wait_commit(journal, tid);
> > -	return 1;
> > +	ret = jbd2_log_wait_commit(journal, tid);
> > +	if (!ret && progress)
> > +		*progress = 1;
> > +
> > +	return ret;
> > +}
>   Can't we just make this function return <0, 0, 1 and get rid of
> 'progress' argument? Caller jbd2_journal_force_commit() can then return 0
> if __jbd2_journal_force_commit() returned >= 0...
Ok, sound reasonable. In fact __jbd2_journal_force_commit() should be
static so misuse is no likely to happen.
> 
> > +
> > +/**
> > + * Force and wait upon a commit if the calling process is not within
> > + * transaction.  This is used for forcing out undo-protected data which contains
> > + * bitmaps, when the fs is running out of space.
> > + *
> > + * @journal: journal to force
> > + * Returns true if progress was made.
> > + */
> > +int jbd2_journal_force_commit_nested(journal_t *journal)
> > +{
> > +	int progress;
> > +
> > +	__jbd2_journal_force_commit(journal, 1, &progress);
> > +	return progress;
> > +}
> > +
> > +/**
> > + * int journal_force_commit() - force any uncommitted transactions
> > + * @journal: journal to force
> > + *
> > + */
> > +int jbd2_journal_force_commit(journal_t *journal)
> > +{
> > +	return __jbd2_journal_force_commit(journal, 0, NULL);
> >  }
>   Also if we move the WARN_ON(!current->journal_info) here, we can remove
> the 'nested' argument.
Also agree. Will send you with updated version soon.
> 
> 								Honza
> 
> >  /*
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index 10f524c..dae6b3d 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -1522,29 +1522,6 @@ int jbd2_journal_stop(handle_t *handle)
> >  	return err;
> >  }
> >  
> > -/**
> > - * int jbd2_journal_force_commit() - force any uncommitted transactions
> > - * @journal: journal to force
> > - *
> > - * For synchronous operations: force any uncommitted transactions
> > - * to disk.  May seem kludgy, but it reuses all the handle batching
> > - * code in a very simple manner.
> > - */
> > -int jbd2_journal_force_commit(journal_t *journal)
> > -{
> > -	handle_t *handle;
> > -	int ret;
> > -
> > -	handle = jbd2_journal_start(journal, 1);
> > -	if (IS_ERR(handle)) {
> > -		ret = PTR_ERR(handle);
> > -	} else {
> > -		handle->h_sync = 1;
> > -		ret = jbd2_journal_stop(handle);
> > -	}
> > -	return ret;
> > -}
> > -
> >  /*
> >   *
> >   * List management code snippets: various functions for manipulating the
> > diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> > index 6e051f4..c9e1ab6 100644
> > --- a/include/linux/jbd2.h
> > +++ b/include/linux/jbd2.h
> > @@ -1125,6 +1125,7 @@ extern void	   jbd2_journal_ack_err    (journal_t *);
> >  extern int	   jbd2_journal_clear_err  (journal_t *);
> >  extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
> >  extern int	   jbd2_journal_force_commit(journal_t *);
> > +extern int	   jbd2_journal_force_commit_nested(journal_t *);
> >  extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
> >  extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
> >  				struct jbd2_inode *inode, loff_t new_size);
> > @@ -1199,7 +1200,6 @@ int __jbd2_log_space_left(journal_t *); /* Called with journal locked */
> >  int jbd2_log_start_commit(journal_t *journal, tid_t tid);
> >  int __jbd2_log_start_commit(journal_t *journal, tid_t tid);
> >  int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
> > -int jbd2_journal_force_commit_nested(journal_t *journal);
> >  int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
> >  int jbd2_complete_transaction(journal_t *journal, tid_t tid);
> >  int jbd2_log_do_checkpoint(journal_t *journal);
> > -- 
> > 1.7.1
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
