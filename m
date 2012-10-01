From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 08/11] ext4: endless truncate due to nonlocked dio
 readers V2
Date: Mon, 1 Oct 2012 18:41:17 +0200
Message-ID: <20121001164117.GD32092@quack.suse.cz>
References: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org>
 <1348847051-6746-9-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab2JAQlS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2012 12:41:18 -0400
Content-Disposition: inline
In-Reply-To: <1348847051-6746-9-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 28-09-12 19:44:08, Dmitry Monakhov wrote:
> If we have enough aggressive DIO readers, truncate and other dio
> waiters will wait forever inside inode_dio_wait(). It is reasonable
> to disable nonlock DIO read optimization during truncate.
  OK, as per our previous discussion I agree. So you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 583cb3f..c40a98d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4305,9 +4305,14 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	if (attr->ia_valid & ATTR_SIZE) {
>  		if (attr->ia_size != inode->i_size) {
>  			truncate_setsize(inode, attr->ia_size);
> -			/* Inode size will be reduced, wait for dio in flight */
> -			if (orphan)
> +			/* Inode size will be reduced, wait for dio in flight.
> +			 * Temporarily disable dioread_nolock to prevent
> +			 * livelock. */
> +			if (orphan) {
> +				ext4_inode_block_unlocked_dio(inode);
>  				inode_dio_wait(inode);
> +				ext4_inode_resume_unlocked_dio(inode);
> +			}
>  		}
>  		ext4_truncate(inode);
>  	}
> -- 
> 1.7.7.6
> 
