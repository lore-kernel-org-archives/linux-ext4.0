From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] fs / ext3: Always unlock updates in ext3_freeze()
Date: Mon, 15 Aug 2011 20:09:13 +0200
Message-ID: <201108152009.13776.rjw@sisk.pl>
References: <201108112329.23043.rjw@sisk.pl> <201108112331.13241.rjw@sisk.pl> <20110815122218.GB6971@quack.suse.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110815122218.GB6971@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Monday, August 15, 2011, Jan Kara wrote:
>   Hi,
> On Thu 11-08-11 23:31:13, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > In analogy with ext4 make ext3_freeze() always call
> > journal_unlock_updates() to prevent it from leaving a locked mutex
> > behind.  Accordingly, modify ext3_unfreeze() so that it doesn't
> > call journal_unlock_updates() any more.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> > 
> > Sorry for the duplicate, the previous one was sent too early.
> > 
> > ---
> >  fs/ext3/super.c |   39 ++++++++++++++++++---------------------
> >  1 file changed, 18 insertions(+), 21 deletions(-)
> > 
> > Index: linux/fs/ext3/super.c
> > ===================================================================
> > --- linux.orig/fs/ext3/super.c
> > +++ linux/fs/ext3/super.c
> > @@ -2535,30 +2535,28 @@ static int ext3_sync_fs(struct super_blo
> >   */
> >  static int ext3_freeze(struct super_block *sb)
> >  {
> > -	int error = 0;
> > +	int error;
> >  	journal_t *journal;
> >  
> > -	if (!(sb->s_flags & MS_RDONLY)) {
> > -		journal = EXT3_SB(sb)->s_journal;
> > +	if (sb->s_flags & MS_RDONLY)
> > +		return 0;
> >  
> > -		/* Now we set up the journal barrier. */
> > -		journal_lock_updates(journal);
> > +	journal = EXT3_SB(sb)->s_journal;
> >  
> > -		/*
> > -		 * We don't want to clear needs_recovery flag when we failed
> > -		 * to flush the journal.
> > -		 */
> > -		error = journal_flush(journal);
> > -		if (error < 0)
> > -			goto out;
> > -
> > -		/* Journal blocked and flushed, clear needs_recovery flag. */
> > -		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
> > -		error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
> > -		if (error)
> > -			goto out;
> > -	}
> > -	return 0;
> > +	/* Now we set up the journal barrier. */
> > +	journal_lock_updates(journal);
> > +
> > +	/*
> > +	 * We don't want to clear needs_recovery flag when we failed
> > +	 * to flush the journal.
> > +	 */
> > +	error = journal_flush(journal);
> > +	if (error < 0)
> > +		goto out;
> > +
> > +	/* Journal blocked and flushed, clear needs_recovery flag. */
> > +	EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
> > +	error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
> >  
> >  out:
> >  	journal_unlock_updates(journal);
> > @@ -2577,7 +2575,6 @@ static int ext3_unfreeze(struct super_bl
> >  		EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
> >  		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
> >  		unlock_super(sb);
> > -		journal_unlock_updates(EXT3_SB(sb)->s_journal);
> >  	}
> >  	return 0;
> >  }
>   It's not so simple as this. Ext3 relies on the mutex (the one hidden in
> journal_lock_updates()) to make sure that new transaction cannot be started
> while the filesystem is frozen - that's essentially what makes the
> filesystem frozen. So if we want to get rid of the mutex we have to achieve
> blocking by something else - ext4 uses vfs_check_frozen() in
> ext4_journal_start().

I see.  Still, freeze_bdev() may be called by user space through a syscall,
as far as I can say, so it shouldn't leave the mutex locked.

>   BTW,  filesystem freezing never really worked for mmaped writes under
> ext3 - ext3 would have to implement page_mkwrite() callback for that - so
> if you want to rely on it for suspending, this will be non-trivial.

At this point the purpose of freezing filesystems is basically to
prevent XFS from deadlocking with hibernation's memory preallocation.
For other filesystems it may or may not make a difference depending on
their implementation of freeze/unfreeze_super().

Thanks,
Rafael
