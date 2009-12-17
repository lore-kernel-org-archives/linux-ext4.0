From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] quota: manage reserved space even when quota is not
 active
Date: Thu, 17 Dec 2009 15:28:08 +0100
Message-ID: <20091217142807.GA3544@quack.suse.cz>
References: <1261010125-14248-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764790AbZLQO2Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Dec 2009 09:28:16 -0500
Content-Disposition: inline
In-Reply-To: <1261010125-14248-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 17-12-09 03:35:25, Dmitry Monakhov wrote:
> Hi, Jan.
> I've prepared additional patch for quota reserved space management.
> Initially I've overlooked case when quota is not active, but in fact
> it seems reasonable to generalize reservation to that case as we do
> for i_block/i_bytes reservation.
> Possibly it should be folded in to c35fc5af93955aa22efc6568e5ae5b2cadbc086f
> 
> CHANGE_LOG:
> quota: manage reserved space even when quota is not active
> Since we implemented generic reserved space management interface,
> then it is possible to account reserved space even quota when quota
> is not active (similar to i_blocks/i_bytes).
  Yes, that's reasonable. I'll fold the patch into your
"quota: decouple fs reserved space from quota reservation" but please fix
things I write below.

> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index dea86ab..de7e7de 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1351,15 +1351,14 @@ static qsize_t *inode_reserved_space(struct inode * inode)
>  	return inode->i_sb->dq_op->get_reserved_space(inode);
>  }
>  
> -static void inode_add_rsv_space(struct inode *inode, qsize_t number)
> +void inode_add_rsv_space(struct inode *inode, qsize_t number)
>  {
>  	spin_lock(&inode->i_lock);
>  	*inode_reserved_space(inode) += number;
>  	spin_unlock(&inode->i_lock);
>  }
>  
> -
> -static void inode_claim_rsv_space(struct inode *inode, qsize_t number)
> +void inode_claim_rsv_space(struct inode *inode, qsize_t number)
>  {
>  	spin_lock(&inode->i_lock);
>  	*inode_reserved_space(inode) -= number;
> @@ -1367,14 +1366,14 @@ static void inode_claim_rsv_space(struct inode *inode, qsize_t number)
>  	spin_unlock(&inode->i_lock);
>  }
>  
> -static void inode_sub_rsv_space(struct inode *inode, qsize_t number)
> +void inode_sub_rsv_space(struct inode *inode, qsize_t number)
>  {
>  	spin_lock(&inode->i_lock);
>  	*inode_reserved_space(inode) -= number;
>  	spin_unlock(&inode->i_lock);
>  }
  The above three functions need to be exported (needed when ext4 is a
module).

> -static qsize_t inode_get_rsv_space(struct inode *inode)
> +qsize_t inode_get_rsv_space(struct inode *inode)
  I think this does not need to be visible outside.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
