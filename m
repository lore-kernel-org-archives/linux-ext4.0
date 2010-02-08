From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Jbd2: delay discarding buffers in journal_unmap_buffer
Date: Mon, 8 Feb 2010 17:03:33 +0100
Message-ID: <20100208160332.GF4321@quack.suse.cz>
References: <1265432063-5806-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: dingdinghua <dingdinghua@nrchpc.ac.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab0BHQD2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 11:03:28 -0500
Content-Disposition: inline
In-Reply-To: <1265432063-5806-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 06-02-10 12:54:23, dingdinghua wrote:
> Delay discarding buffers in journal_unmap_buffer until
> we know that "add to orphan" operation has definitely been
> committed, otherwise the log space of committing transation
> may be freed and reused before truncate get committed, updates
> may get lost if crash happens.
> 
> Signed-off-by: dingdinghua <dingdinghua@nrchpc.ac.cn>
  Thanks for the patch. Just two remarks to the comments below...

> ---
>  fs/jbd2/commit.c      |   10 +++++-----
>  fs/jbd2/transaction.c |   33 +++++++++++++++++++++------------
>  2 files changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 1bc74b6..aabff6a 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -930,12 +930,12 @@ restart_loop:
>  		/* A buffer which has been freed while still being
>  		 * journaled by a previous transaction may end up still
>  		 * being dirty here, but we want to avoid writing back
> -		 * that buffer in the future now that the last use has
> -		 * been committed.  That's not only a performance gain,
> -		 * it also stops aliasing problems if the buffer is left
> -		 * behind for writeback and gets reallocated for another
> +		 * that buffer in the future after the "add to orphan"
> +		 * operation been committed,  That's not only a performance
> +                 * gain, it also stops aliasing problems if the buffer is
  Please use TAB for indentation of the above line.

> +		 * left behind for writeback and gets reallocated for another
>  		 * use in a different page. */
> -		if (buffer_freed(bh)) {
> +		if (buffer_freed(bh) && !jh->b_next_transaction) {
>  			clear_buffer_freed(bh);
>  			clear_buffer_jbddirty(bh);
>  		}
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index a051270..6e2971d 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1783,16 +1783,20 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
>  	} else if (transaction == journal->j_committing_transaction) {
>  		JBUFFER_TRACE(jh, "on committing transaction");
>  		/*
> -		 * If it is committing, we simply cannot touch it.  We
> -		 * can remove it's next_transaction pointer from the
> -		 * running transaction if that is set, but nothing
> -		 * else. */
> +		 * We don't know the transaction which "add to orphan" handle
> +		 * belongs to, there are three cases:
> +		 * (1) it's a transaction which has been committed
> +		 * (2) it's the committing transaction
> +		 * (3) it's the running transaction
> +		 * We can't clear the BH_jbddirty bit and discard the buffer
> +		 * before "add to orphan" has been committed, just
> +		 * be conservative, if running transaction exists and buffer
> +		 * has been dirtied(may be by previous transaction), wait until
> +		 * running transaction complete commit and do the discard work.
> +		 */
  I was thinking about how to better explain the problem in the comment
and here's what I'd do:
  I'd add the comment below before line with transaction = jh->b_transaction
in journal_unmap_buffer:
  We cannot remove the buffer from checkpoint lists until the transaction
adding inode to orphan list (let's call it T) is committed. Otherwise if
the transaction changing the buffer would be cleaned from the journal
before T is committed, a crash will cause that the correct contents of the
buffer will be lost. On the other hand we have to clear the buffer dirty
bit at latest at the moment when the transaction marking the buffer as
freed in the filesystem structures is committed because from that moment on
the buffer can be reallocated and used by a different page. Since the
block hasn't been freed yet but the inode has already been added to orphan
list, it is safe for us to add the buffer to BJ_Forget list of the newest
transaction.

  And then I'd change the comment in the transaction ==
journal->j_committing_transaction case to:
The buffer is committing, we simply cannot touch it. So we just set
j_next_transaction to the running transaction (if there is one) and
mark buffer as freed so that commit code knows it should clear dirty
bits when it is done with the buffer.
  
									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
