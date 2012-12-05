From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs:ext3: remove lock_buffer in bclean() and
 setup_new_group_blocks
Date: Wed, 5 Dec 2012 15:41:07 +0100
Message-ID: <20121205144107.GE5706@quack.suse.cz>
References: <1354412428-8938-1-git-send-email-dinggnu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Cong Ding <dinggnu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab2LEOlJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 09:41:09 -0500
Content-Disposition: inline
In-Reply-To: <1354412428-8938-1-git-send-email-dinggnu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 02-12-12 01:40:28, Cong Ding wrote:
> it's not necessary to lock the buffers because no one touches them
> beyond the file system.
  Although I agree those locks are not strictly necessary, I prefer to keep
them because the general rula is buffer contents should be changed under
buffer lock unless we have a good reason to do otherwise. And here the cost
of additional lock is really marginal...

								Honza

> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  fs/ext3/resize.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
> index 0f814f3..f76fcd6 100644
> --- a/fs/ext3/resize.c
> +++ b/fs/ext3/resize.c
> @@ -122,10 +122,8 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
>  		brelse(bh);
>  		bh = ERR_PTR(err);
>  	} else {
> -		lock_buffer(bh);
>  		memset(bh->b_data, 0, sb->s_blocksize);
>  		set_buffer_uptodate(bh);
> -		unlock_buffer(bh);
>  	}
>  
>  	return bh;
> @@ -242,10 +240,8 @@ static int setup_new_group_blocks(struct super_block *sb,
>  			brelse(gdb);
>  			goto exit_bh;
>  		}
> -		lock_buffer(gdb);
>  		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, gdb->b_size);
>  		set_buffer_uptodate(gdb);
> -		unlock_buffer(gdb);
>  		err = ext3_journal_dirty_metadata(handle, gdb);
>  		if (err) {
>  			brelse(gdb);
> -- 
> 1.7.4.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
