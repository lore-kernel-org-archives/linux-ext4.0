From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 6/7] ext4: endless truncate due to nonlocked dio readers
 V2
Date: Thu, 13 Sep 2012 18:41:36 +0800
Message-ID: <20120913104136.GB11330@gmail.com>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-7-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63639 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab2IMKbN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 06:31:13 -0400
Received: by pbbrr13 with SMTP id rr13so3736399pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 03:31:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1347211634-11509-7-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmitry,

Could you please provide more detailed workload to convince me?  I
am thinking about whether we really need to disable dioread_nolock
feature in here.  In our benchmarks, we don't see this problem.

Regards,
Zheng

On Sun, Sep 09, 2012 at 09:27:13PM +0400, Dmitry Monakhov wrote:
> If we have enough aggressive DIO readers, truncate and other dio
> waiters will wait forever inside inode_dio_wait(). It is reasonable
> to disable nonlock DIO read optimization during truncate.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |    2 +-
>  fs/ext4/fsync.c   |    2 +-
>  fs/ext4/inode.c   |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 8252651..b5b801f 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4853,7 +4853,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	}
>  
>  	/* finish any pending end_io work */
> -	inode_dio_wait(inode);
> +	ext4_inode_dio_wait(inode, 1);
>  	ext4_flush_completed_IO(inode);
>  
>  	credits = ext4_writepage_trans_blocks(inode);
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 290c5cf..bdf6bfd 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -204,7 +204,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	if (inode->i_sb->s_flags & MS_RDONLY)
>  		goto out;
>  
> -	inode_dio_wait(inode);
> +	ext4_inode_dio_wait(inode, 1);
>  	ret = ext4_flush_completed_IO(inode);
>  	if (ret < 0)
>  		goto out;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 93e6b09..a850026 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4335,7 +4335,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  			truncate_setsize(inode, attr->ia_size);
>  			/* Inode size will be reduced, wait for dio in flight */
>  			if (orphan)
> -				inode_dio_wait(inode);
> +				ext4_inode_dio_wait(inode, 1);
>  		}
>  		ext4_truncate(inode);
>  	}
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
