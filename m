From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: trivial fix to comment for ext2_free_blocks
Date: Fri, 18 May 2012 15:25:24 +0200
Message-ID: <20120518132524.GB5589@quack.suse.cz>
References: <4FB5F48D.1090902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933711Ab2ERNZp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 May 2012 09:25:45 -0400
Content-Disposition: inline
In-Reply-To: <4FB5F48D.1090902@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 18-05-12 15:04:45, Wang Sheng-Hui wrote:
> The function is ext2_free_blocks(), not ext2_free_blocks_sb().
  Thanks. Merged.

								Honza
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/ext2/balloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index a8cbe1b..1a6bf5e 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -479,7 +479,7 @@ void ext2_discard_reservation(struct inode *inode)
>  }
>  
>  /**
> - * ext2_free_blocks_sb() -- Free given blocks and update quota and i_blocks
> + * ext2_free_blocks() -- Free given blocks and update quota and i_blocks
>   * @inode:		inode
>   * @block:		start physcial block to free
>   * @count:		number of blocks to free
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
