Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49172 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbeKHA4k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 19:56:40 -0500
Date: Wed, 7 Nov 2018 10:25:49 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] ext4: lost brelse in __ext4_read_dirblock()
Message-ID: <20181107152549.GB9919@thunk.org>
References: <cover.1541011937.git.vvs@virtuozzo.com>
 <60f19df8-1e65-99a0-cb6b-696d1b530fd4@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60f19df8-1e65-99a0-cb6b-696d1b530fd4@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 10:12:18PM +0300, Vasily Averin wrote:
> Fixes dc6982ff4db1 ("ext4: refactor code to read directory blocks ...") # 3.9
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  fs/ext4/namei.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index d388cce72db2..1a21e59ede72 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -111,6 +111,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
>  	if (!bh) {
>  		ext4_error_inode(inode, func, line, block,
>  				 "Directory hole found");
> +		brelse(bh);
>  		return ERR_PTR(-EFSCORRUPTED);
>  	}
>  	dirent = (struct ext4_dir_entry *) bh->b_data;

Inside the conditional, bh == NULL, so the brelse isn't needed.

Cheers,

						- Ted
