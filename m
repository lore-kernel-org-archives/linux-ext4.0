From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH -v3] ext4: delete unnecessary C statements
Date: Mon, 24 Jun 2013 21:52:07 +0800
Message-ID: <20130624135207.GC7709@gmail.com>
References: <1371739943-31176-1-git-send-email-tytso@mit.edu>
 <1371757548-30605-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jon ernst <jonernst07@gmx.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51951 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3FXNds (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jun 2013 09:33:48 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so10895050pad.23
        for <linux-ext4@vger.kernel.org>; Mon, 24 Jun 2013 06:33:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1371757548-30605-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 20, 2013 at 03:45:48PM -0400, Theodore Ts'o wrote:
> From: jon ernst <jonernst07@gmx.com>
> 
> Comparing unsigned variable with 0 always returns false.
> err = 0 is duplicated and unnecessary.
> 
> [ tytso: Also cleaned up error handling in ext4_block_zero_page_range() ]
> 
> Signed-off-by: "Jon Ernst" <jonernst07@gmx.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  fs/ext4/inode.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 78cf398..67963cf 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1100,8 +1100,6 @@ static int ext4_write_end(struct file *file,
>  	if (i_size_changed)
>  		ext4_mark_inode_dirty(handle, inode);
>  
> -	if (copied < 0)
> -		ret = copied;
>  	if (pos + len > inode->i_size && ext4_can_truncate(inode))
>  		/* if we have allocated more blocks and copied
>  		 * less. We will have blocks allocated outside
> @@ -3366,13 +3364,10 @@ int ext4_block_zero_page_range(handle_t *handle,
>  		iblock++;
>  		pos += blocksize;
>  	}
> -
> -	err = 0;
>  	if (buffer_freed(bh)) {
>  		BUFFER_TRACE(bh, "freed: skip");
>  		goto unlock;
>  	}
> -
>  	if (!buffer_mapped(bh)) {
>  		BUFFER_TRACE(bh, "unmapped");
>  		ext4_get_block(inode, iblock, bh, 0);
> @@ -3395,22 +3390,19 @@ int ext4_block_zero_page_range(handle_t *handle,
>  		if (!buffer_uptodate(bh))
>  			goto unlock;
>  	}
> -
>  	if (ext4_should_journal_data(inode)) {
>  		BUFFER_TRACE(bh, "get write access");
>  		err = ext4_journal_get_write_access(handle, bh);
>  		if (err)
>  			goto unlock;
>  	}
> -
>  	zero_user(page, offset, length);
> -
>  	BUFFER_TRACE(bh, "zeroed end of block");
>  
> -	err = 0;
>  	if (ext4_should_journal_data(inode)) {
>  		err = ext4_handle_dirty_metadata(handle, inode, bh);
>  	} else {
> +		err = 0;
>  		mark_buffer_dirty(bh);
>  		if (ext4_test_inode_state(inode, EXT4_STATE_ORDERED_MODE))
>  			err = ext4_jbd2_file_inode(handle, inode);
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
