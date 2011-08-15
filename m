From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs / ext3: Always unlock updates in ext3_freeze()
Date: Mon, 15 Aug 2011 14:22:18 +0200
Message-ID: <20110815122218.GB6971@quack.suse.cz>
References: <201108112329.23043.rjw@sisk.pl>
 <201108112331.13241.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201108112331.13241.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,
On Thu 11-08-11 23:31:13, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> In analogy with ext4 make ext3_freeze() always call
> journal_unlock_updates() to prevent it from leaving a locked mutex
> behind.  Accordingly, modify ext3_unfreeze() so that it doesn't
> call journal_unlock_updates() any more.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> Sorry for the duplicate, the previous one was sent too early.
> 
> ---
>  fs/ext3/super.c |   39 ++++++++++++++++++---------------------
>  1 file changed, 18 insertions(+), 21 deletions(-)
> 
> Index: linux/fs/ext3/super.c
> ===================================================================
> --- linux.orig/fs/ext3/super.c
> +++ linux/fs/ext3/super.c
> @@ -2535,30 +2535,28 @@ static int ext3_sync_fs(struct super_blo
>   */
>  static int ext3_freeze(struct super_block *sb)
>  {
> -	int error = 0;
> +	int error;
>  	journal_t *journal;
>  
> -	if (!(sb->s_flags & MS_RDONLY)) {
> -		journal = EXT3_SB(sb)->s_journal;
> +	if (sb->s_flags & MS_RDONLY)
> +		return 0;
>  
> -		/* Now we set up the journal barrier. */
> -		journal_lock_updates(journal);
> +	journal = EXT3_SB(sb)->s_journal;
>  
> -		/*
> -		 * We don't want to clear needs_recovery flag when we failed
> -		 * to flush the journal.
> -		 */
> -		error = journal_flush(journal);
> -		if (error < 0)
> -			goto out;
> -
> -		/* Journal blocked and flushed, clear needs_recovery flag. */
> -		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
> -		error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
> -		if (error)
> -			goto out;
> -	}
> -	return 0;
> +	/* Now we set up the journal barrier. */
> +	journal_lock_updates(journal);
> +
> +	/*
> +	 * We don't want to clear needs_recovery flag when we failed
> +	 * to flush the journal.
> +	 */
> +	error = journal_flush(journal);
> +	if (error < 0)
> +		goto out;
> +
> +	/* Journal blocked and flushed, clear needs_recovery flag. */
> +	EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
> +	error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
>  
>  out:
>  	journal_unlock_updates(journal);
> @@ -2577,7 +2575,6 @@ static int ext3_unfreeze(struct super_bl
>  		EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
>  		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
>  		unlock_super(sb);
> -		journal_unlock_updates(EXT3_SB(sb)->s_journal);
>  	}
>  	return 0;
>  }
  It's not so simple as this. Ext3 relies on the mutex (the one hidden in
journal_lock_updates()) to make sure that new transaction cannot be started
while the filesystem is frozen - that's essentially what makes the
filesystem frozen. So if we want to get rid of the mutex we have to achieve
blocking by something else - ext4 uses vfs_check_frozen() in
ext4_journal_start().
  BTW,  filesystem freezing never really worked for mmaped writes under
ext3 - ext3 would have to implement page_mkwrite() callback for that - so
if you want to rely on it for suspending, this will be non-trivial.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
