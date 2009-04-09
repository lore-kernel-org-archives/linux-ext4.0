From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] missing unlock in ext2_quota_write()
Date: Thu, 9 Apr 2009 18:09:58 +0200
Message-ID: <20090409160958.GB26552@atrey.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0904070844220.820@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54632 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZDIQKA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2009 12:10:00 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904070844220.820@bicker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> The inode->i_mutex should be unlocked.
> 
> Found by smatch (http://repo.or.cz/w/smatch.git).  Compile tested.
> 
> regards,
> dan carpenter
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
  Thanks for the fix. Merged into quota tree.

								Honza
> 
> --- orig/fs/ext2/super.c	2009-04-07 08:42:15.000000000 +0300
> +++ devel/fs/ext2/super.c	2009-04-07 08:43:19.000000000 +0300
> @@ -1394,8 +1394,10 @@
>  		blk++;
>  	}
>  out:
> -	if (len == towrite)
> +	if (len == towrite) {
> +		mutex_unlock(&inode->i_mutex);
>  		return err;
> +	}
>  	if (inode->i_size < off+len-towrite)
>  		i_size_write(inode, off+len-towrite);
>  	inode->i_version++;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
