From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/7] Freeze and thaw the journal on ext4 freeze
Date: Fri, 6 Jan 2012 01:32:48 +0100
Message-ID: <20120106003248.GA3790@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
 <1323367477-21685-3-git-send-email-kamal@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Surbhi Palande <surbhi.palande@canonical.com>
To: Kamal Mostafa <kamal@canonical.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1323367477-21685-3-git-send-email-kamal@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 08-12-11 10:04:32, Kamal Mostafa wrote:
> From: Surbhi Palande <surbhi.palande@canonical.com>
> 
> Freeze and thaw the journal when you freeze and thaw the filesystem.
> 
> BugLink: https://bugs.launchpad.net/bugs/897421
> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
> Cc: Kamal Mostafa <kamal@canonical.com>
> Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
  The patch looks good. You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/super.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3858767..751908b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4330,14 +4330,11 @@ static int ext4_freeze(struct super_block *sb)
>  
>  	journal = EXT4_SB(sb)->s_journal;
>  
> -	/* Now we set up the journal barrier. */
> -	jbd2_journal_lock_updates(journal);
> -
> +	error = jbd2_journal_freeze(journal);
>  	/*
> -	 * Don't clear the needs_recovery flag if we failed to flush
> +	 * Don't clear the needs_recovery flag if we failed to freeze
>  	 * the journal.
>  	 */
> -	error = jbd2_journal_flush(journal);
>  	if (error < 0)
>  		goto out;
>  
> @@ -4345,8 +4342,6 @@ static int ext4_freeze(struct super_block *sb)
>  	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  	error = ext4_commit_super(sb, 1);
>  out:
> -	/* we rely on s_frozen to stop further updates */
> -	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
>  	return error;
>  }
>  
> @@ -4356,10 +4351,14 @@ out:
>   */
>  static int ext4_unfreeze(struct super_block *sb)
>  {
> +	journal_t *journal;
>  	if (sb->s_flags & MS_RDONLY)
>  		return 0;
>  
>  	lock_super(sb);
> +	journal = EXT4_SB(sb)->s_journal;
> +
> +	jbd2_journal_thaw(journal);
>  	/* Reset the needs_recovery flag before the fs is unlocked. */
>  	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  	ext4_commit_super(sb, 1);
> -- 
> 1.7.5.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
