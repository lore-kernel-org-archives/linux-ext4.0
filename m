From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: improve error messages for inconsistent journal
 heads
Date: Thu, 13 Mar 2014 21:28:01 +0100
Message-ID: <20140313202801.GD504@quack.suse.cz>
References: <1394657089-29456-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaCMU2D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2014 16:28:03 -0400
Content-Disposition: inline
In-Reply-To: <1394657089-29456-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 12-03-14 16:44:49, Ted Tso wrote:
> Fix up error messages printed when the transaction pointers in a
> journal head are inconsistent.  This improves the error messages which
> are printed when running xfstests generic/068 in data=journal mode.
> See the bug report at: https://bugzilla.kernel.org/show_bug.cgi?id=60786
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4_jbd2.c   | 10 ++++++++++
>  fs/jbd2/transaction.c | 33 ++++++++++++++-------------------
>  2 files changed, 24 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 3fe29de..c3fb607 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -259,6 +259,16 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
>  		if (WARN_ON_ONCE(err)) {
>  			ext4_journal_abort_handle(where, line, __func__, bh,
>  						  handle, err);
> +			if (inode == NULL) {
> +				pr_err("EXT4: jbd2_journal_dirty_metadata "
> +				       "failed: handle type %u started at "
> +				       "line %u, credits %u/%u, errcode %d",
> +				       handle->h_type,
> +				       handle->h_line_no,
> +				       handle->h_requested_credits,
> +				       handle->h_buffer_credits, err);
> +				return err;
> +			}
>  			ext4_error_inode(inode, where, line,
>  					 bh->b_blocknr,
>  					 "journal_dirty_metadata failed: "
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index d999b1f..38cfcf5 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1313,7 +1313,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
>  			     journal->j_running_transaction)) {
>  			printk(KERN_ERR "JBD2: %s: "
>  			       "jh->b_transaction (%llu, %p, %u) != "
> -			       "journal->j_running_transaction (%p, %u)",
> +			       "journal->j_running_transaction (%p, %u)\n",
>  			       journal->j_devname,
>  			       (unsigned long long) bh->b_blocknr,
>  			       jh->b_transaction,
> @@ -1336,30 +1336,25 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
>  	 */
>  	if (jh->b_transaction != transaction) {
>  		JBUFFER_TRACE(jh, "already on other transaction");
> -		if (unlikely(jh->b_transaction !=
> -			     journal->j_committing_transaction)) {
> -			printk(KERN_ERR "JBD2: %s: "
> -			       "jh->b_transaction (%llu, %p, %u) != "
> -			       "journal->j_committing_transaction (%p, %u)",
> +		if (unlikely(((jh->b_transaction !=
> +			       journal->j_committing_transaction)) ||
> +			     (jh->b_next_transaction != transaction))) {
> +			printk(KERN_ERR "jbd2_journal_dirty_metadata: %s: "
> +			       "bad jh for block %llu: "
> +			       "transaction (%p, %u), "
> +			       "jh->b_transaction (%p, %u), "
> +			       "jh->b_next_transaction (%p, %u), jlist %u\n",
>  			       journal->j_devname,
>  			       (unsigned long long) bh->b_blocknr,
> +			       transaction, transaction->t_tid,
>  			       jh->b_transaction,
> -			       jh->b_transaction ? jh->b_transaction->t_tid : 0,
> -			       journal->j_committing_transaction,
> -			       journal->j_committing_transaction ?
> -			       journal->j_committing_transaction->t_tid : 0);
> -			ret = -EINVAL;
> -		}
> -		if (unlikely(jh->b_next_transaction != transaction)) {
> -			printk(KERN_ERR "JBD2: %s: "
> -			       "jh->b_next_transaction (%llu, %p, %u) != "
> -			       "transaction (%p, %u)",
> -			       journal->j_devname,
> -			       (unsigned long long) bh->b_blocknr,
> +			       jh->b_transaction ?
> +			       jh->b_transaction->t_tid : 0,
>  			       jh->b_next_transaction,
>  			       jh->b_next_transaction ?
>  			       jh->b_next_transaction->t_tid : 0,
> -			       transaction, transaction->t_tid);
> +			       jh->b_jlist);
> +			WARN_ON(1);
>  			ret = -EINVAL;
>  		}
>  		/* And this case is illegal: we can't reuse another
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
