From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/8] ext3: drop lock/unlock super
Date: Thu, 30 Aug 2012 17:12:24 +0200
Message-ID: <20120830151224.GA13055@quack.suse.cz>
References: <503F7F31.10708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2H3PM1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2012 11:12:27 -0400
Content-Disposition: inline
In-Reply-To: <503F7F31.10708@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 30-08-12 16:56:49, Marco Stornelli wrote:
> Removed lock/unlock super.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
  You can add: Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext3/super.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 8c892e9..9b3d498 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2571,11 +2571,9 @@ out:
>  static int ext3_unfreeze(struct super_block *sb)
>  {
>  	if (!(sb->s_flags & MS_RDONLY)) {
> -		lock_super(sb);
>  		/* Reser the needs_recovery flag before the fs is unlocked. */
>  		EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
>  		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
> -		unlock_super(sb);
>  		journal_unlock_updates(EXT3_SB(sb)->s_journal);
>  	}
>  	return 0;
> @@ -2595,7 +2593,6 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
>  #endif
>  
>  	/* Store the original options */
> -	lock_super(sb);
>  	old_sb_flags = sb->s_flags;
>  	old_opts.s_mount_opt = sbi->s_mount_opt;
>  	old_opts.s_resuid = sbi->s_resuid;
> @@ -2701,8 +2698,6 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
>  		    old_opts.s_qf_names[i] != sbi->s_qf_names[i])
>  			kfree(old_opts.s_qf_names[i]);
>  #endif
> -	unlock_super(sb);
> -
>  	if (enable_quota)
>  		dquot_resume(sb, -1);
>  	return 0;
> @@ -2721,7 +2716,6 @@ restore_opts:
>  		sbi->s_qf_names[i] = old_opts.s_qf_names[i];
>  	}
>  #endif
> -	unlock_super(sb);
>  	return err;
>  }
>  
> -- 
> 1.7.3.4
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
