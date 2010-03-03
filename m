From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: add writepage sanity checks
Date: Wed, 3 Mar 2010 09:01:15 +0100
Message-ID: <20100303080115.GB6290@quack.suse.cz>
References: <1267534262-13196-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53016 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab0CCIBG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Mar 2010 03:01:06 -0500
Content-Disposition: inline
In-Reply-To: <1267534262-13196-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-03-10 15:51:02, Dmitry Monakhov wrote:
> - There is theoretical possibility to perform writepage on
>    RO superblock. Add explicit check for what case.
> - Page must being locked before writepage.
  Thanks. Merged into my tree.

								Honza
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext3/inode.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 8ac4acf..14d40a4 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1528,6 +1528,7 @@ static int ext3_ordered_writepage(struct page *page,
>  	int err;
>  
>  	J_ASSERT(PageLocked(page));
> +	WARN_ON_ONCE(IS_RDONLY(inode));
>  
>  	/*
>  	 * We give up here if we're reentered, because it might be for a
> @@ -1600,6 +1601,9 @@ static int ext3_writeback_writepage(struct page *page,
>  	int ret = 0;
>  	int err;
>  
> +	J_ASSERT(PageLocked(page));
> +	WARN_ON_ONCE(IS_RDONLY(inode));
> +
>  	if (ext3_journal_current_handle())
>  		goto out_fail;
>  
> @@ -1642,6 +1646,9 @@ static int ext3_journalled_writepage(struct page *page,
>  	int ret = 0;
>  	int err;
>  
> +	J_ASSERT(PageLocked(page));
> +	WARN_ON_ONCE(IS_RDONLY(inode));
> +
>  	if (ext3_journal_current_handle())
>  		goto no_write;
>  
> -- 
> 1.6.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
