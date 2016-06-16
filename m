From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2] ext4: optimize ext4_should_retry_alloc() to improve
 ENOSPC performance
Date: Thu, 16 Jun 2016 21:20:00 +0200
Message-ID: <20160616192000.GE2106@quack2.suse.cz>
References: <1465353418-12897-1-git-send-email-tytso@mit.edu>
 <1465354006-15091-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbcFPToq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2016 15:44:46 -0400
Content-Disposition: inline
In-Reply-To: <1465354006-15091-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 07-06-16 22:46:46, Ted Tso wrote:
> If there are pending blocks to be released after a commit, retrying
> the allocation after a journal commit has no hope of helping.  So
> track how many pending deleted blocks there might be, and don't retry
> if there are no pending blocks.
> 
> Reported-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> 
> Oops, ignore the earlier version of this patch.  I bobbled the commit
> and merged in part of another change.

Couple of notes below:

>  fs/ext4/balloc.c    |  9 ++++++++-
>  fs/ext4/ext4.h      |  1 +
>  fs/ext4/ext4_jbd2.h | 10 +++++++++-
>  fs/ext4/mballoc.c   | 12 ++++++++++--
>  4 files changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 3020fd7..371ac63 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -603,7 +603,14 @@ int ext4_claim_free_clusters(struct ext4_sb_info *sbi,
>   */
>  int ext4_should_retry_alloc(struct super_block *sb, int *retries)
>  {
> -	if (!ext4_has_free_clusters(EXT4_SB(sb), 1, 0) ||
> +	unsigned int pending_blocks;
> +
> +	spin_lock(&EXT4_SB(sb)->s_md_lock);
> +	pending_blocks = EXT4_SB(sb)->s_mb_free_pending;
> +	spin_unlock(&EXT4_SB(sb)->s_md_lock);
> +
> +	if (pending_blocks == 0 ||
> +	    !ext4_has_free_clusters(EXT4_SB(sb), 1, 0) ||
>  	    (*retries)++ > 3 ||
>  	    !EXT4_SB(sb)->s_journal)
>  		return 0;

But this is racy. Transaction commit could have finished before we called
ext4_should_retry_alloc() and so we will mistakenly think there's no hope
although there are blocks free now. But what you could probably do is just
return 1 without forcing a transaction commit when pending_blocks == 0.

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b84aa1c..96c73e6 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1430,6 +1430,7 @@ struct ext4_sb_info {
>  	unsigned short *s_mb_offsets;
>  	unsigned int *s_mb_maxs;
>  	unsigned int s_group_info_size;
> +	unsigned int s_mb_free_pending;
>  
>  	/* tunables */
>  	unsigned long s_stripe;
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 09c1ef3..b1d52c1 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -175,6 +175,13 @@ struct ext4_journal_cb_entry {
>   * There is no guaranteed calling order of multiple registered callbacks on
>   * the same transaction.
>   */
> +static inline void _ext4_journal_callback_add(handle_t *handle,
> +			struct ext4_journal_cb_entry *jce)
> +{
> +	/* Add the jce to transaction's private list */
> +	list_add_tail(&jce->jce_list, &handle->h_transaction->t_private_list);
> +}
> +
>  static inline void ext4_journal_callback_add(handle_t *handle,
>  			void (*func)(struct super_block *sb,
>  				     struct ext4_journal_cb_entry *jce,

Well, since ext4_mb_free_metadata() is the only user of
ext4_journal_callback_add(), ext4_journal_callback_add() won't have any
user after your patch. Maybe we could just stop playing these abstraction
games nobody currently uses and just implement a helper function to add
freeing callback to the transaction list including increment of the pending
counter.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
