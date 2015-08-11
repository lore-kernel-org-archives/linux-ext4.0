From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: don't manipulate recovery flag when freezing
 no-journal fs
Date: Tue, 11 Aug 2015 21:22:37 +0200
Message-ID: <20150811192237.GE2659@quack.suse.cz>
References: <55C28AA6.6070606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Stu Mark <smark@datto.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbbHKTWm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2015 15:22:42 -0400
Content-Disposition: inline
In-Reply-To: <55C28AA6.6070606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 05-08-15 15:13:58, Eric Sandeen wrote:
> At some point along this sequence of changes:
> 
> f6e63f9 ext4: fold ext4_nojournal_sops into ext4_sops
> bb04457 ext4: support freezing ext2 (nojournal) file systems
> 9ca9238 ext4: Use separate super_operations structure for no_journal filesystems
> 
> ext4 started setting needs_recovery on filesystems without journals
> when they are unfrozen.  This makes no sense, and in fact confuses
> blkid to the point where it doesn't recognize the filesystem at all.
> 
> (freeze ext2; unfreeze ext2; run blkid; see no output; run dumpe2fs,
> see needs_recovery set on fs w/ no journal).
> 
> To fix this, don't manipulate the INCOMPAT_RECOVER feature on
> filesystems without journals.
> 
> Reported-by: Stu Mark <smark@datto.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.com>

								Honza

> ---
> 
> Note, is there a reason that in ext4_freeze, if journal_flush
> fails, we skip the ext4_commit_super call?  I didn't change that
> here, but it seems odd.
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 58987b5..e7b345d 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4833,10 +4833,11 @@ static int ext4_freeze(struct super_block *sb)
>  		error = jbd2_journal_flush(journal);
>  		if (error < 0)
>  			goto out;
> +
> +		/* Journal blocked and flushed, clear needs_recovery flag. */
> +		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  	}
>  
> -	/* Journal blocked and flushed, clear needs_recovery flag. */
> -	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  	error = ext4_commit_super(sb, 1);
>  out:
>  	if (journal)
> @@ -4854,8 +4855,11 @@ static int ext4_unfreeze(struct super_block *sb)
>  	if (sb->s_flags & MS_RDONLY)
>  		return 0;
>  
> -	/* Reset the needs_recovery flag before the fs is unlocked. */
> -	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> +	if (EXT4_SB(sb)->s_journal) {
> +		/* Reset the needs_recovery flag before the fs is unlocked. */
> +		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
> +	}
> +
>  	ext4_commit_super(sb, 1);
>  	return 0;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
