From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] jbd: clear revoked flag on buffers before a new
 transaction started
Date: Tue, 15 Nov 2011 14:27:48 +0100
Message-ID: <20111115132748.GD21732@quack.suse.cz>
References: <1321344152-13033-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab1KON2K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Nov 2011 08:28:10 -0500
Content-Disposition: inline
In-Reply-To: <1321344152-13033-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-11-11 16:02:31, Yongqiang Yang wrote:
> A revoked block in a transaction means the block is deleted by filesystem
> in the transaction.  If the block is reused in the same transaction, we
> need to cancel revoke status of the block.  We also should prohibit a block
> from being revoked more than once in a transaction.  So we need to look up
> the revoke table to check if a given block is revoked, to acceletate the
> looking up, jbd/jbd2 use revoked flag to cache status of a block.
> 
  I'd alter the change log here:
Currently, we clear revoked status only when a block is reused. However,
this can trigger a false journal error: Consider a situation when a block
is used as a metadata block, is deleted (revoked) in ordered mode, and then
the block is allocated as a data block to a file. At this moment user
changes the file's journal mode from ordered to journaled, and truncates
the file. The block will be considered re-revoked by journal because it
has revoked flag still pending from the last transaction and an assertion
triggers.

We fix the problem by keeping revoked status more uptodate - we clear
buffers' revoke bit when switching revoke tables to reflect that no buffers
are revoked in the current transaction anymore.

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/jbd/commit.c     |    5 +++++
>  fs/jbd/revoke.c     |   28 ++++++++++++++++++++++++++++
>  include/linux/jbd.h |    1 +
>  3 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
> index 8799207..075b7e8 100644
> --- a/fs/jbd/commit.c
> +++ b/fs/jbd/commit.c
> @@ -392,6 +392,11 @@ void journal_commit_transaction(journal_t *journal)
>  	jbd_debug (3, "JBD: commit phase 1\n");
>  
>  	/*
> +	 * Clear revoked flag.
  This comment does not explain nothing not obvious from the code. But we
should explain here *why* we need to clear the flags:
  We clear revoke status cached in b_state here to reflect that no buffer
is revoked in the next transaction which is going to be started.
> +	 */
> +	journal_clear_revoked_flag(journal);
  Maybe call the function journal_clear_buffer_revoked_flags()?

> +
> +	/*
>  	 * Switch to a new revoke table.
>  	 */
>  	journal_switch_revoke_table(journal);
> diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
> index 034eb82..cf73b67 100644
> --- a/fs/jbd/revoke.c
> +++ b/fs/jbd/revoke.c
> @@ -474,6 +474,34 @@ int journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
>  	return did_revoke;
>  }
>  
> +/* journal_clear_revoked_flag clears revoked flag of buffers in
> + * revoke table.
> + */
  Comment style is:
/*
 * some text
 * more text
 */

> +void journal_clear_revoked_flag(journal_t *journal)
> +{
> +	struct jbd_revoke_table_s *revoke = journal->j_revoke;
> +	int i = 0;
> +
> +	for (i = 0; i < revoke->hash_size; i++) {
> +		struct list_head *hash_list;
> +		struct list_head *list_entry;
> +		hash_list = &revoke->hash_table[i];
> +
> +		list_for_each(list_entry, hash_list) {
> +			struct jbd_revoke_record_s *record;
> +			struct buffer_head *bh;
> +			record = (struct jbd_revoke_record_s *)list_entry;
> +			bh = __find_get_block(journal->j_fs_dev,
> +					      record->blocknr,
> +					      journal->j_blocksize);
> +			if (bh) {
> +				clear_buffer_revoked(bh);
> +				__brelse(bh);
> +			}
> +		}
> +	}
> +}
> +
>  /* journal_switch_revoke table select j_revoke for next transaction
>   * we do not want to suspend any processing until all revokes are
>   * written -bzzz
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index 0f9f0b6..de59ac0 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -918,6 +918,7 @@ extern int	journal_set_revoke(journal_t *, unsigned int, tid_t);
>  extern int	journal_test_revoke(journal_t *, unsigned int, tid_t);
>  extern void	journal_clear_revoke(journal_t *);
>  extern void	journal_switch_revoke_table(journal_t *journal);
> +extern void	journal_clear_revoked_flag(journal_t *journal);
>  
>  /*
>   * The log thread user interface:
  Also please extend a comment (around line 50 in fs/jbd/journal.c) by:
We cache revoke status of a buffer in the current transaction in b_state
bits. Revoke information on buffers...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
