From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Remove misplaced BUFFER_TRACE() in
 ext3_truncate()
Date: Mon, 18 Oct 2010 12:54:23 +0200
Message-ID: <20101018105422.GH3826@quack.suse.cz>
References: <1287140582-5925-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58067 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab0JRKzV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Oct 2010 06:55:21 -0400
Content-Disposition: inline
In-Reply-To: <1287140582-5925-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 15-10-10 20:03:02, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
  Thanks. Merged.

							Honza
> ---
>  fs/ext3/inode.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 5e0faf4..90a9c3d 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -2530,7 +2530,6 @@ void ext3_truncate(struct inode *inode)
>  			 */
>  		} else {
>  			/* Shared branch grows from an indirect block */
> -			BUFFER_TRACE(partial->bh, "get_write_access");
>  			ext3_free_branches(handle, inode, partial->bh,
>  					partial->p,
>  					partial->p+1, (chain+n-1) - partial);
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
