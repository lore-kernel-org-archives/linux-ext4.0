Return-Path: <SRS0=z94b=OO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43400 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbeLEJBN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 5 Dec 2018 04:01:13 -0500
Date: Wed, 5 Dec 2018 10:01:17 +0100
From: Jan Kara <jack@suse.cz>
To: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Cc: Jan Kara <jack@suse.cz>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] inode_has_no_xattr() does not use proper sync
Message-ID: <20181205090117.GA22304@quack2.suse.cz>
References: <ce8c29d7-7f5e-5c78-dbd9-15364a384138@tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce8c29d7-7f5e-5c78-dbd9-15364a384138@tu-dortmund.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 27-11-18 15:54:28, Alexander Lochmann wrote:
> 
> inode.i_flags is modified without any proper
> synchronisation used. inode_set_flags() is now used.
> 
> Found by LockDoc (Alexander Lochmann, Horst Schirmeier and Olaf
> Spinczyk)
> 
> Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
> Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>

Thanks for the patch! Couple notes to this patch:

1) This is a generic VFS helper as such, linux-fsdevel mailing list and VFS
maintainer Al Viro is the right forum to post this patch to. We do have
scripts/get_maintainer.pl script you can use on a patch / file to get idea
who's the best to post the change to. It is not perfect but usually works
fine.

2) It would be good to include stacktrace showing where the unlocked access
happens in the changelog. It is non-trivial to find it by brief inspection
as all standard filesystems call inode_has_no_xattr() under i_rwsem. This
problem is really specific to blkdev_write_iter() AFAICT.

3) Also can you please add comment into inode_has_no_xattr() like:
	/*
	 * blkdev_write_iter() can call this without i_rwsem, need to be
	 * careful with i_flags update.
	 */

								Honza
> ---
>  include/linux/fs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c95c0807471f..54f3a21668a6 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3446,7 +3446,7 @@ static inline int check_sticky(struct inode *dir,
> struct inode *inode)
>  static inline void inode_has_no_xattr(struct inode *inode)
>  {
>  	if (!is_sxid(inode->i_mode) && (inode->i_sb->s_flags & SB_NOSEC))
> -		inode->i_flags |= S_NOSEC;
> +		inode_set_flags(inode, S_NOSEC, S_NOSEC);
>  }
> 
>  static inline bool is_root_inode(struct inode *inode)
> -- 
> 2.19.1
> 



-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
