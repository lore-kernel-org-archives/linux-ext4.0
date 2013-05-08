From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 26/29] ext4: Remove i_mutex from ext4_file_sync()
Date: Wed, 8 May 2013 15:41:06 +0800
Message-ID: <20130508074106.GA2274@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-27-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:36192 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3EHHXZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 03:23:25 -0400
Received: by mail-pb0-f50.google.com with SMTP id um15so1020393pbc.37
        for <linux-ext4@vger.kernel.org>; Wed, 08 May 2013 00:23:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-27-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:31PM +0200, Jan Kara wrote:
> After removal of ext4_flush_unwritten_io() call, ext4_file_sync()
> doesn't need i_mutex anymore. Forcing of transaction commits doesn't
> need i_mutex as there's nothing inode specific in that code apart from
> grabbing transaction ids from the inode. So remove the lock.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Due to the comment in patch 25/29, here we need to change that statement
back again.

                ret = generic_file_fsync(file, start, end, datasync);
                if (!ret && !hlist_empty(&inode->i_dentry))
                        ret = ext4_sync_parent(inode);
-               goto out_trace;
+               goto out;
        }
 
        ret = filemap_write_and_wait_range(inode->i_mapping, start, end);

Otherwise the patch looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng

> ---
>  fs/ext4/fsync.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 1c08780..9040faa 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -99,7 +99,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	trace_ext4_sync_file_enter(file, datasync);
>  
>  	if (inode->i_sb->s_flags & MS_RDONLY)
> -		goto out_trace;
> +		goto out;
>  
>  	if (!journal) {
>  		ret = generic_file_fsync(file, start, end, datasync);
> @@ -111,8 +111,6 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
>  	if (ret)
>  		return ret;
> -	mutex_lock(&inode->i_mutex);
> -
>  	/*
>  	 * data=writeback,ordered:
>  	 *  The caller's filemap_fdatawrite()/wait will sync the data.
> @@ -144,8 +142,6 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  			ret = err;
>  	}
>  out:
> -	mutex_unlock(&inode->i_mutex);
> -out_trace:
>  	trace_ext4_sync_file_exit(inode, ret);
>  	return ret;
>  }
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
