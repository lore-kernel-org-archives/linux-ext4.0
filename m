From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/6] ext3: fix data integrity for ext4_sync_fs
Date: Tue, 28 May 2013 23:40:03 +0200
Message-ID: <20130528214003.GE16408@quack.suse.cz>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
 <1369732741-26070-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645Ab3E1VkE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 17:40:04 -0400
Content-Disposition: inline
In-Reply-To: <1369732741-26070-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 28-05-13 13:18:59, Dmitry Monakhov wrote:
> Inode's data or non journaled quota may be written w/o jounral so we must
> send a barrier at the end of ext3_sync_fs. But it can be skipped if journal
> commit will do it for us.
> 
> changes from v1:
>  skip barrier for async mode
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext3/super.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index fb5120a..c8a4e17 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2521,6 +2521,7 @@ int ext3_force_commit(struct super_block *sb)
>  static int ext3_sync_fs(struct super_block *sb, int wait)
>  {
>  	tid_t target;
> +	int ret = 0;
>  
>  	trace_ext3_sync_fs(sb, wait);
>  	/*
> @@ -2528,11 +2529,14 @@ static int ext3_sync_fs(struct super_block *sb, int wait)
>  	 * no dirty dquots
>  	 */
>  	dquot_writeback_dquots(sb, -1);
> -	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
> -		if (wait)
> -			log_wait_commit(EXT3_SB(sb)->s_journal, target);
> +	if (wait) {
> +		if (journal_start_commit(EXT3_SB(sb)->s_journal, &target))
> +			ret = log_wait_commit(EXT3_SB(sb)->s_journal, target);
> +		else
> +			ret = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
>  	}
> -	return 0;
> +
> +	return ret;
>  }
  This will issue a flush even if the filesystem is mounted with barrier=0.
That's not good. Also journal_start_commit() was deliberately called even
if wait == 0. This is so that journal commit is started and in a not so
rare case where second sync pass doesn't find anything to write, we can
just wait for an already running commit...

Finally I think it may be actually worth it and do a similar thing as you
did for ext4/jbd2 with the latest transaction in the journal. It's not very
intrusive change.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
