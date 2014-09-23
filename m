From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: support freezing ext2 (nojournal) file systems
Date: Tue, 23 Sep 2014 14:33:26 +0200
Message-ID: <20140923123326.GH2359@quack.suse.cz>
References: <1411071989-4974-1-git-send-email-tytso@mit.edu>
 <1411071989-4974-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dexuan Cui <decui@microsoft.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaIWMd3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 08:33:29 -0400
Content-Disposition: inline
In-Reply-To: <1411071989-4974-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-09-14 16:26:28, Ted Tso wrote:
> Through an oversight, when we added nojournal support to ext4, we
> didn't add support to allow file system freezing.  This is relatively
> easy to add, so let's do it.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Reported-by: Dexuan Cui <decui@microsoft.com>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4770c98..921d5b4 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1131,6 +1131,8 @@ static const struct super_operations ext4_nojournal_sops = {
>  	.drop_inode	= ext4_drop_inode,
>  	.evict_inode	= ext4_evict_inode,
>  	.sync_fs	= ext4_sync_fs,
> +	.freeze_fs	= ext4_freeze,
> +	.unfreeze_fs	= ext4_unfreeze,
>  	.put_super	= ext4_put_super,
>  	.statfs		= ext4_statfs,
>  	.remount_fs	= ext4_remount,
> @@ -4758,23 +4760,26 @@ static int ext4_freeze(struct super_block *sb)
>  
>  	journal = EXT4_SB(sb)->s_journal;
>  
> -	/* Now we set up the journal barrier. */
> -	jbd2_journal_lock_updates(journal);
> +	if (journal) {
> +		/* Now we set up the journal barrier. */
> +		jbd2_journal_lock_updates(journal);
>  
> -	/*
> -	 * Don't clear the needs_recovery flag if we failed to flush
> -	 * the journal.
> -	 */
> -	error = jbd2_journal_flush(journal);
> -	if (error < 0)
> -		goto out;
> +		/*
> +		 * Don't clear the needs_recovery flag if we failed to
> +		 * flush the journal.
> +		 */
> +		error = jbd2_journal_flush(journal);
> +		if (error < 0)
> +			goto out;
> +	}
>  
>  	/* Journal blocked and flushed, clear needs_recovery flag. */
>  	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  	error = ext4_commit_super(sb, 1);
>  out:
> -	/* we rely on upper layer to stop further updates */
> -	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
> +	if (journal)
> +		/* we rely on upper layer to stop further updates */
> +		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
>  	return error;
>  }
>  
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
