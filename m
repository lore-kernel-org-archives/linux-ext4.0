From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] fs/ext2/balloc.c: delete useless initialization
Date: Thu, 4 Aug 2011 12:39:54 +0200
Message-ID: <20110804103954.GG17196@quack.suse.cz>
References: <1312453774-23333-1-git-send-email-julia@diku.dk>
 <1312453774-23333-3-git-send-email-julia@diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, kernel-janitors@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab1HDKj4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2011 06:39:56 -0400
Content-Disposition: inline
In-Reply-To: <1312453774-23333-3-git-send-email-julia@diku.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 04-08-11 12:29:32, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Delete nontrivial initialization that is immediately overwritten by the
> result of an allocation function.
  Thanks. Merged.

								Honza
> 
> The semantic match that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> type T;
> identifier i;
> expression e;
> @@
> 
> (
> T i = \(0\|NULL\|ERR_PTR(...)\);
> |
> -T i = e;
> +T i;
> )
> ... when != i
> i = \(kzalloc\|kcalloc\|kmalloc\)(...);
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  fs/ext2/balloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -421,7 +421,7 @@ static inline int rsv_is_empty(struct ex
>  void ext2_init_block_alloc_info(struct inode *inode)
>  {
>  	struct ext2_inode_info *ei = EXT2_I(inode);
> -	struct ext2_block_alloc_info *block_i = ei->i_block_alloc_info;
> +	struct ext2_block_alloc_info *block_i;
>  	struct super_block *sb = inode->i_sb;
>  
>  	block_i = kmalloc(sizeof(*block_i), GFP_NOFS);
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
