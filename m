From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/5] ext4: Use redirty_page_for_writepage() in
 ext4_bio_write_page()
Date: Fri, 4 Jan 2013 15:20:33 +0800
Message-ID: <20130104072033.GB31130@gmail.com>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
 <1357148744-4895-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49117 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3ADHGy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 02:06:54 -0500
Received: by mail-pa0-f53.google.com with SMTP id hz1so9087143pad.26
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jan 2013 23:06:53 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1357148744-4895-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 02, 2013 at 06:45:41PM +0100, Jan Kara wrote:
> When we cannot write a page we should use redirty_page_for_writepage()
> instead of plain set_page_dirty(). That tells writeback code we have
> problems, redirties only the page (redirtying buffers is not needed),
> and updates mm accounting of failed page writes.
> 
> Also move clearing of buffer dirty flag after io_submit_add_bh(). At that
> moment we are sure buffer will be going to disk.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/ext4/page-io.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 0016fbc..8e5722a 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -23,6 +23,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
> +#include <linux/mm.h>
>  
>  #include "ext4_jbd2.h"
>  #include "xattr.h"
> @@ -436,7 +437,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>  
>  	io_page = kmem_cache_alloc(io_page_cachep, GFP_NOFS);
>  	if (!io_page) {
> -		set_page_dirty(page);
> +		redirty_page_for_writepage(wbc, page);
>  		unlock_page(page);
>  		return -ENOMEM;
>  	}
> @@ -468,7 +469,6 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>  			set_buffer_uptodate(bh);
>  			continue;
>  		}
> -		clear_buffer_dirty(bh);
>  		ret = io_submit_add_bh(io, io_page, inode, wbc, bh);
>  		if (ret) {
>  			/*
> @@ -476,9 +476,10 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>  			 * we can do but mark the page as dirty, and
>  			 * better luck next time.
>  			 */
> -			set_page_dirty(page);
> +			redirty_page_for_writepage(wbc, page);
>  			break;
>  		}
> +		clear_buffer_dirty(bh);
>  	}
>  	unlock_page(page);
>  	/*
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
