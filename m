From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: optimize ext3_force_commit
Date: Tue, 2 Apr 2013 15:20:22 +0200
Message-ID: <20130402132022.GA7999@quack.suse.cz>
References: <1364807037-21664-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761913Ab3DCJc3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 05:32:29 -0400
Content-Disposition: inline
In-Reply-To: <1364807037-21664-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 01-04-13 13:03:56, Dmitry Monakhov wrote:
> We do not have to use journal_force_commit() because it explicitly
> start and stop SYNC transaction. This is very suboptimal because the only
> users of ext3_force_commit() are ext3_sync_file and ext3_write_inode().
> Both functions just want to commit and wait any uncommitted transaction
> similar to ext3_sync_fs().
  As Ted mentioned, you can also remove ext3_journal_force_commit(). Also
I'm somewhat curious whether you spotted some particular performance issue
with this call or whether it just seemed better to you this way. Note that
I believe your change isn't going to be worse than what we had but OTOH we
have sync transaction batching code in journal_stop() so there might be
some changes in timings.

								Honza

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext3/super.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index fb5120a..1853031 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2507,15 +2507,14 @@ static void ext3_clear_journal_err(struct super_block *sb,
>   */
>  int ext3_force_commit(struct super_block *sb)
>  {
> -	journal_t *journal;
> -	int ret;
> +	tid_t target;
>  
>  	if (sb->s_flags & MS_RDONLY)
>  		return 0;
>  
> -	journal = EXT3_SB(sb)->s_journal;
> -	ret = ext3_journal_force_commit(journal);
> -	return ret;
> +	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target))
> +		return log_wait_commit(EXT3_SB(sb)->s_journal, target);
> +	return 0;
>  }
>  
>  static int ext3_sync_fs(struct super_block *sb, int wait)
> @@ -2530,7 +2529,7 @@ static int ext3_sync_fs(struct super_block *sb, int wait)
>  	dquot_writeback_dquots(sb, -1);
>  	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
>  		if (wait)
> -			log_wait_commit(EXT3_SB(sb)->s_journal, target);
> +			return log_wait_commit(EXT3_SB(sb)->s_journal, target);
>  	}
>  	return 0;
>  }
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
