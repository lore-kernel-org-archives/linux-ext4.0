From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 03/29] ext4: Clear buffer_uninit flag when submitting IO
Date: Thu, 11 Apr 2013 22:08:50 +0800
Message-ID: <20130411140850.GD3448@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44120 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3DKNvx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2013 09:51:53 -0400
Received: by mail-pa0-f52.google.com with SMTP id fb10so917915pad.11
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2013 06:51:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:08PM +0200, Jan Kara wrote:
> Currently noone cleared buffer_uninit flag. This results in writeback
> needlessly marking io_end as needing extent conversion scanning extent
> tree for extents to convert. So clear the buffer_uninit flag once the
> buffer is submitted for IO and the flag is transformed into
> EXT4_IO_END_UNWRITTEN flag.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/ext4/page-io.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index da8bddf..efdf0a5 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -377,7 +377,7 @@ submit_and_retry:
>  	if (ret != bh->b_size)
>  		goto submit_and_retry;
>  	io_end = io->io_end;
> -	if (buffer_uninit(bh))
> +	if (test_clear_buffer_uninit(bh))
>  		ext4_set_io_unwritten_flag(inode, io_end);
>  	io_end->size += bh->b_size;
>  	io->io_next_block++;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
