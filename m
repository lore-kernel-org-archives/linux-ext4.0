From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH RESEND] Ext4: No need to add inode to orphan list during
 hole punch
Date: Mon, 30 Jul 2012 10:19:27 +0800
Message-ID: <20120730021927.GC21674@gmail.com>
References: <1343226214-2068-1-git-send-email-ashish.sangwan2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, lczerner@redhat.com,
	a.sangwan@samsung.com, namjae.jeon@samsung.com,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2G3CKn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Jul 2012 22:10:43 -0400
Content-Disposition: inline
In-Reply-To: <1343226214-2068-1-git-send-email-ashish.sangwan2@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 25, 2012 at 07:53:34PM +0530, Ashish Sangwan wrote:
> While performing punch hole for an inode, i_disksize is not changed.
> So, there is no need to add the inode to orphan list.
> 
> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>

Acked-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
Zheng

> ---
>  fs/ext4/extents.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91341ec..3e902f9 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4801,9 +4801,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  
> -	err = ext4_orphan_add(handle, inode);
> -	if (err)
> -		goto out;
>  
>  	/*
>  	 * Now we need to zero out the non-page-aligned data in the
> @@ -4889,7 +4886,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	up_write(&EXT4_I(inode)->i_data_sem);
>  
>  out:
> -	ext4_orphan_del(handle, inode);
>  	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>  	ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
