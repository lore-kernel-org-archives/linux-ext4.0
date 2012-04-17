From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC]jbd2: use GFP_NOFS for blkdev_issue_flush
Date: Tue, 17 Apr 2012 11:58:30 +0200
Message-ID: <20120417095830.GE7198@quack.suse.cz>
References: <4F878F17.2030900@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu
To: Shaohua Li <shli@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab2DQJ6g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Apr 2012 05:58:36 -0400
Content-Disposition: inline
In-Reply-To: <4F878F17.2030900@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 13-04-12 10:27:35, Shaohua Li wrote:
> 
> flush request is issued in transaction commit code path, so looks using
> GFP_KERNEL to allocate memory for flush request bio falls into the classic
> deadlock issue.  I saw btrfs and dm get it right, but ext4, xfs and md are
> using GFP_KERNEL, which makes me confused. Hoping filesystem developers
> clarify.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>
  Yeah, ext4 (jbd2) should use GFP_NOFS since we are in a kjournald and
reclaim could possibly need to start a transaction thus blocking on
kjournald. So you have my:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/jbd2/commit.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/fs/jbd2/commit.c
> ===================================================================
> --- linux.orig/fs/jbd2/commit.c	2012-04-13 09:57:51.785506925 +0800
> +++ linux/fs/jbd2/commit.c	2012-04-13 09:58:29.585498773 +0800
> @@ -723,7 +723,7 @@ start_journal_io:
>  	if (commit_transaction->t_need_data_flush &&
>  	    (journal->j_fs_dev != journal->j_dev) &&
>  	    (journal->j_flags & JBD2_BARRIER))
> -		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
> +		blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS, NULL);
> 
>  	/* Done it all: now write the commit record asynchronously. */
>  	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
> @@ -859,7 +859,7 @@ wait_for_iobuf:
>  	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
>  				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
>  	    journal->j_flags & JBD2_BARRIER) {
> -		blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL);
> +		blkdev_issue_flush(journal->j_dev, GFP_NOFS, NULL);
>  	}
> 
>  	if (err)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
