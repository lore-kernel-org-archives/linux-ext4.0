From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [BUG] infinite loop when unmounting ext3/4
Date: Tue, 28 Jul 2015 15:15:26 +0800
Message-ID: <20150728071502.GF18016@dhcp-13-216.nay.redhat.com>
References: <20150715143031.GB18016@dhcp-13-216.nay.redhat.com>
 <55A74CA8.9070902@huawei.com>
 <20150720072356.GC18016@dhcp-13-216.nay.redhat.com>
 <20150723204155.GA7814@quack.suse.cz>
 <20150727195440.GA22077@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joseph Qi <joseph.qi@huawei.com>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34205 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbG1HQq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jul 2015 03:16:46 -0400
Received: by pdbbh15 with SMTP id bh15so65933222pdb.1
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2015 00:16:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150727195440.GA22077@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 27, 2015 at 09:54:40PM +0200, Jan Kara wrote:
> On Thu 23-07-15 22:41:55, Jan Kara wrote:
> > On Mon 20-07-15 15:23:56, Eryu Guan wrote:
> > > On Thu, Jul 16, 2015 at 02:18:16PM +0800, Joseph Qi wrote:
> > > > I got the problem.
> > > > I am not sure why old code uses "result <= 0" even if
> > > > it won't return negative value. Could we use "result == 0" instead of
> > > > "result <= 0"?
> > > 
> > > I thought about this too, but I'm not sure if it has other side effects.
> > > Someone else familiar with this code could comment on this?
> > 
> > Well, we should rather decide, what is the right behavior of the
> > checkpointing code when the journal is aborted. When journal gets aborted,
> > we are in serious trouble. Our standard answer to this is to stop modifying
> > the filesystem as that has a chance of corrupting it even more. I think
> > that avoiding checkpointing on a filesystem with aborted journal is thus
> > what we really want.
> > 
> > To fix the issue you've reported, we just need to teach
> > jbd2_log_do_checkpoint() to cleanup all the buffers in the transactions
> > when the journal is aborted so that journal_destroy() can proceed. I can
> > have a look at it sometime next week unless someone beats me to it.
> 
> OK, attached is the patch that fixes the issue for me. Ted, can you please
> pick it up? Thanks!

I confirmed that the attached patch fixed the infinite loop on aborted
journal. Thanks!

Eryu
> 
> 								Honza
> > > > On 2015/7/15 22:30, Eryu Guan wrote:
> > > > > Hi all,
> > > > > 
> > > > > I found an infinite loop when unmounting a known bad ext3 image (using
> > > > > ext4 driver) with 4.2-rc1 kernel.
> > > > > 
> > > > > The fs image can be found here
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=10882#c1
> > > > > 
> > > > > Reproduce steps:
> > > > >   mount -o loop ext3.img /mnt/ext3
> > > > >   rm -rf /mnt/ext3/{dev,proc,sys}
> > > > >   umount /mnt/ext3	# never return
> > > > > 
> > > > > And this issue was introduced by
> > > > > 6f6a6fd jbd2: fix ocfs2 corrupt when updating journal superblock fails
> > > > > 
> > > > > It's looping in
> > > > > fs/jbd2/journal.c:jbd2_journal_destroy()
> > > > > ...
> > > > > 1693         while (journal->j_checkpoint_transactions != NULL) {                                                                             
> > > > > 1694                 spin_unlock(&journal->j_list_lock);                                                                                      
> > > > > 1695                 mutex_lock(&journal->j_checkpoint_mutex);                                                                                
> > > > > 1696                 jbd2_log_do_checkpoint(journal);                                                                                         
> > > > > 1697                 mutex_unlock(&journal->j_checkpoint_mutex);                                                                              
> > > > > 1698                 spin_lock(&journal->j_list_lock);                                                                                        
> > > > > 1699         }
> > > > > ...
> > > > > 
> > > > > Because jbd2_cleanup_journal_tail() is returning -EIO on aborted journal
> > > > > now instead of 1, and jbd2_log_do_checkpoint() won't cleanup
> > > > > journal->j_checkpoint_transactions in this while loop.
> > > > > 
> > > > > A quick hack would be
> > > > > 
> > > > > diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> > > > > index 4227dc4..1b2ea47 100644
> > > > > --- a/fs/jbd2/checkpoint.c
> > > > > +++ b/fs/jbd2/checkpoint.c
> > > > > @@ -220,11 +220,13 @@ int jbd2_log_do_checkpoint(journal_t *journal)
> > > > >          * don't need checkpointing, just eliminate them from the
> > > > >          * journal straight away.
> > > > >          */
> > > > > -       result = jbd2_cleanup_journal_tail(journal);
> > > > > -       trace_jbd2_checkpoint(journal, result);
> > > > > -       jbd_debug(1, "cleanup_journal_tail returned %d\n", result);
> > > > > -       if (result <= 0)
> > > > > -               return result;
> > > > > +       if (!is_journal_aborted(journal)) {
> > > > > +               result = jbd2_cleanup_journal_tail(journal);
> > > > > +               trace_jbd2_checkpoint(journal, result);
> > > > > +               jbd_debug(1, "cleanup_journal_tail returned %d\n", result);
> > > > > +               if (result <= 0)
> > > > > +                       return result;
> > > > > +       }
> > > > >  
> > > > >         /*
> > > > >          * OK, we need to start writing disk blocks.  Take one transaction
> > > > > 
> > > > > to restore the old behavior (continue on aborted journal). Maybe someone
> > > > > has a better fix.
> > > > > 
> > > > > Thanks,
> > > > > Eryu
> > > > > 
> > > > > .
> > > > > 
> > > > 
> > > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > -- 
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

> From 2839d314353b6d9e88355dc0b30927d38b2cb7b7 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.com>
> Date: Mon, 27 Jul 2015 21:42:08 +0200
> Subject: [PATCH] jbd2: Avoid infinite loop when destroying aborted journal
> 
> Commit 6f6a6fda2945 "jbd2: fix ocfs2 corrupt when updating journal
> superblock fails" changed jbd2_cleanup_journal_tail() to return EIO when
> the journal is aborted. That makes logic in jbd2_log_do_checkpoint()
> bail out which is fine, except that jbd2_journal_destroy() expects
> jbd2_log_do_checkpoint() to always make a progress in cleaning the
> journal. Without it jbd2_journal_destroy() just loops in an infinite
> loop.
> 
> Fix jbd2_journal_destroy() to cleanup journal checkpoint lists of
> jbd2_log_do_checkpoint() fails with error.
> 
> Reported-by: Eryu Guan <guaneryu@gmail.com>
> Fixes: 6f6a6fda294506dfe0e3e0a253bb2d2923f28f0a
> Signed-off-by: Jan Kara <jack@suse.com>
> ---
>  fs/jbd2/checkpoint.c | 39 +++++++++++++++++++++++++++++++++------
>  fs/jbd2/commit.c     |  2 +-
>  fs/jbd2/journal.c    | 11 ++++++++++-
>  include/linux/jbd2.h |  3 ++-
>  4 files changed, 46 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 4227dc4f7437..8c44654ce274 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -417,12 +417,12 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
>   * journal_clean_one_cp_list
>   *
>   * Find all the written-back checkpoint buffers in the given list and
> - * release them.
> + * release them. If 'destroy' is set, clean all buffers unconditionally.
>   *
>   * Called with j_list_lock held.
>   * Returns 1 if we freed the transaction, 0 otherwise.
>   */
> -static int journal_clean_one_cp_list(struct journal_head *jh)
> +static int journal_clean_one_cp_list(struct journal_head *jh, bool destroy)
>  {
>  	struct journal_head *last_jh;
>  	struct journal_head *next_jh = jh;
> @@ -436,7 +436,10 @@ static int journal_clean_one_cp_list(struct journal_head *jh)
>  	do {
>  		jh = next_jh;
>  		next_jh = jh->b_cpnext;
> -		ret = __try_to_free_cp_buf(jh);
> +		if (!destroy)
> +			ret = __try_to_free_cp_buf(jh);
> +		else
> +			ret = __jbd2_journal_remove_checkpoint(jh) + 1;
>  		if (!ret)
>  			return freed;
>  		if (ret == 2)
> @@ -459,10 +462,11 @@ static int journal_clean_one_cp_list(struct journal_head *jh)
>   * journal_clean_checkpoint_list
>   *
>   * Find all the written-back checkpoint buffers in the journal and release them.
> + * If 'destroy' is set, release all buffers unconditionally.
>   *
>   * Called with j_list_lock held.
>   */
> -void __jbd2_journal_clean_checkpoint_list(journal_t *journal)
> +void __jbd2_journal_clean_checkpoint_list(journal_t *journal, bool destroy)
>  {
>  	transaction_t *transaction, *last_transaction, *next_transaction;
>  	int ret;
> @@ -476,7 +480,8 @@ void __jbd2_journal_clean_checkpoint_list(journal_t *journal)
>  	do {
>  		transaction = next_transaction;
>  		next_transaction = transaction->t_cpnext;
> -		ret = journal_clean_one_cp_list(transaction->t_checkpoint_list);
> +		ret = journal_clean_one_cp_list(transaction->t_checkpoint_list,
> +						destroy);
>  		/*
>  		 * This function only frees up some memory if possible so we
>  		 * dont have an obligation to finish processing. Bail out if
> @@ -492,7 +497,7 @@ void __jbd2_journal_clean_checkpoint_list(journal_t *journal)
>  		 * we can possibly see not yet submitted buffers on io_list
>  		 */
>  		ret = journal_clean_one_cp_list(transaction->
> -				t_checkpoint_io_list);
> +				t_checkpoint_io_list, destroy);
>  		if (need_resched())
>  			return;
>  		/*
> @@ -506,6 +511,28 @@ void __jbd2_journal_clean_checkpoint_list(journal_t *journal)
>  }
>  
>  /*
> + * Remove buffers from all checkpoint lists as journal is aborted and we just
> + * need to free memory
> + */
> +void jbd2_journal_destroy_checkpoint(journal_t *journal)
> +{
> +	/*
> +	 * We loop because __jbd2_journal_clean_checkpoint_list() may abort
> +	 * early due to a need of rescheduling.
> +	 */
> +	while (1) {
> +		spin_lock(&journal->j_list_lock);
> +		if (!journal->j_checkpoint_transactions) {
> +			spin_unlock(&journal->j_list_lock);
> +			break;
> +		}
> +		__jbd2_journal_clean_checkpoint_list(journal, true);
> +		spin_unlock(&journal->j_list_lock);
> +		cond_resched();
> +	}
> +}
> +
> +/*
>   * journal_remove_checkpoint: called after a buffer has been committed
>   * to disk (either by being write-back flushed to disk, or being
>   * committed to the log).
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index b73e0215baa7..362e5f614450 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -510,7 +510,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	 * frees some memory
>  	 */
>  	spin_lock(&journal->j_list_lock);
> -	__jbd2_journal_clean_checkpoint_list(journal);
> +	__jbd2_journal_clean_checkpoint_list(journal, false);
>  	spin_unlock(&journal->j_list_lock);
>  
>  	jbd_debug(3, "JBD2: commit phase 1\n");
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 4ff3fad4e9e3..2721513adb1f 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1693,8 +1693,17 @@ int jbd2_journal_destroy(journal_t *journal)
>  	while (journal->j_checkpoint_transactions != NULL) {
>  		spin_unlock(&journal->j_list_lock);
>  		mutex_lock(&journal->j_checkpoint_mutex);
> -		jbd2_log_do_checkpoint(journal);
> +		err = jbd2_log_do_checkpoint(journal);
>  		mutex_unlock(&journal->j_checkpoint_mutex);
> +		/*
> +		 * If checkpointing failed, just free the buffers to avoid
> +		 * looping forever
> +		 */
> +		if (err) {
> +			jbd2_journal_destroy_checkpoint(journal);
> +			spin_lock(&journal->j_list_lock);
> +			break;
> +		}
>  		spin_lock(&journal->j_list_lock);
>  	}
>  
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index edb640ae9a94..eb1cebed3f36 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1042,8 +1042,9 @@ void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
>  extern void jbd2_journal_commit_transaction(journal_t *);
>  
>  /* Checkpoint list management */
> -void __jbd2_journal_clean_checkpoint_list(journal_t *journal);
> +void __jbd2_journal_clean_checkpoint_list(journal_t *journal, bool destroy);
>  int __jbd2_journal_remove_checkpoint(struct journal_head *);
> +void jbd2_journal_destroy_checkpoint(journal_t *journal);
>  void __jbd2_journal_insert_checkpoint(struct journal_head *, transaction_t *);
>  
>  
> -- 
> 2.1.4
> 

