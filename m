From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: explicitly remove inode from orphan list after
 failed direct io
Date: Mon, 17 Mar 2014 20:22:51 +0100
Message-ID: <20140317192251.GB11233@quack.suse.cz>
References: <5327493C.7060801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaCQTWz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2014 15:22:55 -0400
Content-Disposition: inline
In-Reply-To: <5327493C.7060801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 17-03-14 14:13:00, Eric Sandeen wrote:
> Otherwise non-empty orphan list will be triggered on umount.
> 
> This is just an application of commit da1daf by Dmitry Monakhov
> to the same code in ext3.
  Thanks, I've merged the patch.

							Honza
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 384b6eb..caf4c4a 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1925,6 +1925,8 @@ retry:
>  			 * and pretend the write failed... */
>  			ext3_truncate_failed_direct_write(inode);
>  			ret = PTR_ERR(handle);
> +			if (inode->i_nlink)
> +				ext3_orphan_del(NULL, inode);
>  			goto out;
>  		}
>  		if (inode->i_nlink)
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
