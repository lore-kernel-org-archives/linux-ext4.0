From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1] ext3:Fix credits computing for ordered mode.
Date: Thu, 24 Mar 2011 12:33:10 +0100
Message-ID: <20110324113310.GC27322@quack.suse.cz>
References: <1300927719-27383-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50472 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1CXLdN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Mar 2011 07:33:13 -0400
Content-Disposition: inline
In-Reply-To: <1300927719-27383-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 24-03-11 08:48:39, Yongqiang Yang wrote:
> Orginal computing ignores indirects themselves in ordered mode.
  Thanks. Merged into my tree.

								Honza
> 
> Signed-off-by:Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext3/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index ae94f6d..7f5db46 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -3294,7 +3294,7 @@ static int ext3_writepage_trans_blocks(struct inode *inode)
>  	if (ext3_should_journal_data(inode))
>  		ret = 3 * (bpp + indirects) + 2;
>  	else
> -		ret = 2 * (bpp + indirects) + 2;
> +		ret = 2 * (bpp + indirects) + indirects + 2;
>  
>  #ifdef CONFIG_QUOTA
>  	/* We know that structure was already allocated during dquot_initialize so
> -- 
> 1.7.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
