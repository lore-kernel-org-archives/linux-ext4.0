From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] ext4: convert write_begin methods to
 stable_page_writes semantics
Date: Mon, 15 Apr 2013 14:01:27 +0200
Message-ID: <20130415120127.GE2299@quack.suse.cz>
References: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935785Ab3DPQgY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Apr 2013 12:36:24 -0400
Content-Disposition: inline
In-Reply-To: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 14-04-13 23:01:33, Dmitry Monakhov wrote:
> use wait_for_stable_page() instead of wait_on_page_writeback()
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 62189c8..1be5827 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1028,7 +1028,8 @@ retry_journal:
>  		ext4_journal_stop(handle);
>  		goto retry_grab;
>  	}
> -	wait_on_page_writeback(page);
> +	/* In case writeback began while the page was unlocked */
> +	wait_for_stable_page(page);
>  
>  	if (ext4_should_dioread_nolock(inode))
>  		ret = __block_write_begin(page, pos, len, ext4_get_block_write);
> @@ -2715,7 +2716,7 @@ retry_journal:
>  		goto retry_grab;
>  	}
>  	/* In case writeback began while the page was unlocked */
> -	wait_on_page_writeback(page);
> +	wait_for_stable_page(page);
>  
>  	ret = __block_write_begin(page, pos, len, ext4_da_get_block_prep);
>  	if (ret < 0) {
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
