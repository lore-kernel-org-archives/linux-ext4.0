From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: Fix memory leak when truncate races ext2_get_blocks
Date: Thu, 13 Jul 2017 13:46:31 +0200
Message-ID: <20170713114631.GB5884@quack2.suse.cz>
References: <20170624003719.GA5670@debian.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: jack@suse.com, linux-ext4@vger.kernel.org
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751050AbdGMLqj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Jul 2017 07:46:39 -0400
Content-Disposition: inline
In-Reply-To: <20170624003719.GA5670@debian.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 23-06-17 21:37:21, Ernesto A. Fernández wrote:
> Buffer heads referencing indirect blocks may not be released if the file
> is truncated at the right time. This happens because ext2_get_branch()
> returns NULL when it finds the whole chain of indirect blocks already
> set, and when truncate alters the chain this value of NULL is
> treated as the address of the last head to be released. Handle this in the
> same way as it's done after the got_it label.
> 
> Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
> ---
> Despite trying I haven't actually managed to trigger this race. I tested
> the patch by inducing regular failures in verify_chain().

Thanks! I've merged the patch to my tree.

								Honza

> 
>  fs/ext2/inode.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 2dcbd56..30163d0 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -659,6 +659,7 @@ static int ext2_get_blocks(struct inode *inode,
>  				 */
>  				err = -EAGAIN;
>  				count = 0;
> +				partial = chain + depth - 1;
>  				break;
>  			}
>  			blk = le32_to_cpu(*(chain[depth-1].p + count));
> -- 
> 2.1.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
