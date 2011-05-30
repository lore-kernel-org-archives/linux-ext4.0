From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] jbd: fix a bug of leaking jh->b_jcount
Date: Mon, 30 May 2011 12:32:01 +0200
Message-ID: <20110530103201.GB4075@quack.suse.cz>
References: <1306376941-13349-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48677 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab1E3KcE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 May 2011 06:32:04 -0400
Content-Disposition: inline
In-Reply-To: <1306376941-13349-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 26-05-11 10:29:01, Ding Dinghua wrote:
> journal_get_create_access should drop jh->b_jcount in error handling path
> 
> Signed-off-by: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
  Thanks. Merged into my tree.


								Honza
> ---
>  fs/jbd/transaction.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index f7ee81a..3b3b01f 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -844,8 +844,8 @@ int journal_get_create_access(handle_t *handle, struct buffer_head *bh)
>  	 */
>  	JBUFFER_TRACE(jh, "cancelling revoke");
>  	journal_cancel_revoke(handle, jh);
> -	journal_put_journal_head(jh);
>  out:
> +	journal_put_journal_head(jh);
>  	return err;
>  }
>  
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
