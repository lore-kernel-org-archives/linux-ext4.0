From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 3/5] ext4: Remove bogus wait for unwritten extents in
 ext4_ind_direct_IO
Date: Fri, 4 Jan 2013 15:24:37 +0800
Message-ID: <20130104072437.GC31130@gmail.com>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
 <1357148744-4895-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:50095 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3ADHK5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 02:10:57 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so7347539dak.34
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jan 2013 23:10:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1357148744-4895-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 02, 2013 at 06:45:42PM +0100, Jan Kara wrote:
> When using indirect blocks there is no possibility to have any unwritten
> extents. So wait for them in ext4_ind_direct_IO() is just bogus.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Hi Jan,

Just for the note, this patch conflicts with my patch set of extent
status tree.  I guess your patch series will be applied before my patch
set.  So I will rebase my patch set against the latest kernel. :-)

Otherwise, the patch looks good to me.  You can add:
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng

> ---
>  fs/ext4/indirect.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 20862f9..993247c 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -807,11 +807,6 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  
>  retry:
>  	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> -		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
> -			mutex_lock(&inode->i_mutex);
> -			ext4_flush_unwritten_io(inode);
> -			mutex_unlock(&inode->i_mutex);
> -		}
>  		/*
>  		 * Nolock dioread optimization may be dynamically disabled
>  		 * via ext4_inode_block_unlocked_dio(). Check inode's state
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
