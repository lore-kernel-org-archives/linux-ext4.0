From: Jan Kara <jack@suse.cz>
Subject: Re: [RESEND PATCH 2/2] ext3: flush journal only when journal mode
 is changed from journaled
Date: Tue, 15 Nov 2011 14:33:05 +0100
Message-ID: <20111115133305.GE21732@quack.suse.cz>
References: <1321344289-13125-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511Ab1KONd1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Nov 2011 08:33:27 -0500
Content-Disposition: inline
In-Reply-To: <1321344289-13125-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-11-11 16:04:49, Yongqiang Yang wrote:
> To prevent data from corruption during repaly, we need to flush journal
> before changing journal mode from journaled.  However flushing journal is
> not needed when changing journal to journaled.
  We flush the journal for other reasons as well - switching inodes
->i_aops is rather complex thing so a filesystem should better be in a
quiescent state. You'd definitely at least need to commit the running
transaction otherwise a hell would break loose if you tried to modify a
buffer both as ordered data and as metadata in one transaction.

  So I strongly prefer to keep the code as is unless you can really
convincingly *prove* that nothing breaks and show benefit of such change.

								Honza
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext3/inode.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 04da6ac..5577358 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -3546,7 +3546,6 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
>  		return -EROFS;
>  
>  	journal_lock_updates(journal);
> -	journal_flush(journal);
>  
>  	/*
>  	 * OK, there are no updates running now, and all cached data is
> @@ -3556,10 +3555,12 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
>  	 * the inode's in-core data-journaling state flag now.
>  	 */
>  
> -	if (val)
> +	if (val) {
>  		EXT3_I(inode)->i_flags |= EXT3_JOURNAL_DATA_FL;
> -	else
> +	} else {
> +		journal_flush(journal);
>  		EXT3_I(inode)->i_flags &= ~EXT3_JOURNAL_DATA_FL;
> +	}
>  	ext3_set_aops(inode);
>  
>  	journal_unlock_updates(journal);
> -- 
> 1.7.5.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
