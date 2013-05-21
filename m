From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/4] jbd2: make shure that we do not miss aborted state
Date: Tue, 21 May 2013 18:21:14 +0200
Message-ID: <20130521162114.GF11616@quack.suse.cz>
References: <1368707290-26185-1-git-send-email-dmonakhov@openvz.org>
 <1368707290-26185-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab3EUQVP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 May 2013 12:21:15 -0400
Content-Disposition: inline
In-Reply-To: <1368707290-26185-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 16-05-13 16:28:09, Dmitry Monakhov wrote:
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Can you elaborate a bit more on how the aborted state could be missed so
that it would cause any problems?

								Honza
> ---
>  fs/jbd2/journal.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 886ec2f..57b9120 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -700,12 +700,11 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
>  				!tid_gt(tid, journal->j_commit_sequence));
>  		read_lock(&journal->j_state_lock);
>  	}
> -	read_unlock(&journal->j_state_lock);
> -
>  	if (unlikely(is_journal_aborted(journal))) {
>  		printk(KERN_EMERG "journal commit I/O error\n");
>  		err = -EIO;
>  	}
> +	read_unlock(&journal->j_state_lock);
>  	return err;
>  }
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
