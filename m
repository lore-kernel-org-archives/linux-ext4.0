From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] fs/ext3/inode.c: drop if around WARN_ON
Date: Wed, 7 Nov 2012 00:04:27 +0100
Message-ID: <20121106230427.GB16836@quack.suse.cz>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
 <1351974625-10282-5-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, kernel-janitors@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab2KFXEa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2012 18:04:30 -0500
Content-Disposition: inline
In-Reply-To: <1351974625-10282-5-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 03-11-12 21:30:21, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Just use WARN_ON rather than an if containing only WARN_ON(1).
> 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> - if (e) WARN_ON(1);
> + WARN_ON(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
  Thanks. Added into my tree.

							Honza

> ---
>  fs/ext3/inode.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 7e87e37..b176d42 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1071,8 +1071,7 @@ struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
>  	 * mapped. 0 in case of a HOLE.
>  	 */
>  	if (err > 0) {
> -		if (err > 1)
> -			WARN_ON(1);
> +		WARN_ON(err > 1);
>  		err = 0;
>  	}
>  	*errp = err;
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
