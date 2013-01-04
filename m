From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 5/5] ext4: Remove unnecessary wait for extent conversion
 in ext4_fallocate()
Date: Fri, 4 Jan 2013 15:26:52 +0800
Message-ID: <20130104072652.GE31130@gmail.com>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
 <1357148744-4895-6-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47365 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3ADHNM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 02:13:12 -0500
Received: by mail-pa0-f41.google.com with SMTP id bj3so9149814pad.0
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jan 2013 23:13:11 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1357148744-4895-6-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 02, 2013 at 06:45:44PM +0100, Jan Kara wrote:
> Now that we don't merge uninitialized extents anymore, ext4_fallocate()
> is free to operate on the inode while there are still some extent
> conversions pending - it won't disturb them in any way.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/ext4/extents.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f1ce33a..5c7a46a 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4406,8 +4406,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (len <= EXT_UNINIT_MAX_LEN << blkbits)
>  		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
>  
> -	/* Prevent race condition between unwritten */
> -	ext4_flush_unwritten_io(inode);
>  retry:
>  	while (ret >= 0 && ret < max_blocks) {
>  		map.m_lblk = map.m_lblk + ret;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
