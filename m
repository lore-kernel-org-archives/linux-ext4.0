From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/6] ext3: Fix fsync error handling after filesystem
 abort.
Date: Tue, 28 May 2013 23:33:57 +0200
Message-ID: <20130528213357.GD16408@quack.suse.cz>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
 <1369732741-26070-7-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018Ab3E1Vd7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 17:33:59 -0400
Content-Disposition: inline
In-Reply-To: <1369732741-26070-7-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 28-05-13 13:19:01, Dmitry Monakhov wrote:
> If filesystem was aborted we will return success
> due to (sb->s_flags & MS_RDONLY) which is incorrect and
> results in data loss.
> In order to handle fs abort correctly we have to check
> fs state once we discover that it is in MS_RDONLY state
> 
> Test case: http://patchwork.ozlabs.org/patch/244297/
> Changes from V1:
>  - fix spelling
>  - fix smp_rmb()/debug order
  I've taken this patch to my tree with some minor spelling fixes.

								Honza
  
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext3/fsync.c |    8 ++++++--
>  fs/ext3/super.c |   13 ++++++++++++-
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
> index b31dbd4..5412916 100644
> --- a/fs/ext3/fsync.c
> +++ b/fs/ext3/fsync.c
> @@ -48,9 +48,13 @@ int ext3_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  
>  	trace_ext3_sync_file_enter(file, datasync);
>  
> -	if (inode->i_sb->s_flags & MS_RDONLY)
> +	if (inode->i_sb->s_flags & MS_RDONLY) {
> +		/* Make shure that we read updated state */
> +		smp_rmb();
> +		if (EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS)
> +			return -EROFS;
>  		return 0;
> -
> +	}
>  	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
>  	if (ret)
>  		goto out;
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index c8a4e17..b788bae 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -174,6 +174,11 @@ static void ext3_handle_error(struct super_block *sb)
>  	if (test_opt (sb, ERRORS_RO)) {
>  		ext3_msg(sb, KERN_CRIT,
>  			"error: remounting filesystem read-only");
> +		/*
> +		 * Make shure updated value of ->s_mount_state will be visiable
> +		 * before ->s_flags update.
> +		 */
> +		smp_wmb();
>  		sb->s_flags |= MS_RDONLY;
>  	}
>  	ext3_commit_super(sb, es, 1);
> @@ -291,8 +296,14 @@ void ext3_abort(struct super_block *sb, const char *function,
>  	ext3_msg(sb, KERN_CRIT,
>  		"error: remounting filesystem read-only");
>  	EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
> -	sb->s_flags |= MS_RDONLY;
>  	set_opt(EXT3_SB(sb)->s_mount_opt, ABORT);
> +	/*
> +	 * Make shure updated value of ->s_mount_state will be visiable
> +	 * before ->s_flags update.
> +	 */
> +	smp_wmb();
> +	sb->s_flags |= MS_RDONLY;
> +
>  	if (EXT3_SB(sb)->s_journal)
>  		journal_abort(EXT3_SB(sb)->s_journal, -EIO);
>  }
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
