From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: Fix WARN_ON from ext4_releasepage()
Date: Fri, 8 Mar 2013 20:45:21 +0800
Message-ID: <20130308124521.GA18949@gmail.com>
References: <1362667969-19818-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52002 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab3CHMaI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Mar 2013 07:30:08 -0500
Received: by mail-pa0-f48.google.com with SMTP id hz10so1268160pad.7
        for <linux-ext4@vger.kernel.org>; Fri, 08 Mar 2013 04:30:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1362667969-19818-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 07, 2013 at 03:52:49PM +0100, Jan Kara wrote:
> ext4_releasepage() warns when it is passed a page with PageChecked set.
> However this can correctly happen when invalidate_inode_pages2_range()
> invalidates pages - and we should fail the release in that case. Since
> the page was dirty anyway, it won't be discarded and no harm has
> happened but it's good to be safe. Also remove bogus page_has_buffers()
> check - we are guaranteed page has buffers in this function.
> 
> Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
Thanks for fixing it.  I can confirm that the warning disappears.
Tested-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng
> ---
>  fs/ext4/inode.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9c4f4b1..34cc72d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2912,8 +2912,8 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
>  
>  	trace_ext4_releasepage(page);
>  
> -	WARN_ON(PageChecked(page));
> -	if (!page_has_buffers(page))
> +	/* Page has dirty journalled data -> cannot release */
> +	if (PageChecked(page))
>  		return 0;
>  	if (journal)
>  		return jbd2_journal_try_to_free_buffers(journal, page, wait);
> -- 
> 1.7.1
> 
