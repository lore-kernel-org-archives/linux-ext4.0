From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 04/29] jbd2: Reduce journal_head size
Date: Thu, 11 Apr 2013 22:10:26 +0800
Message-ID: <20130411141026.GE3448@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:43963 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3DKNx2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2013 09:53:28 -0400
Received: by mail-pb0-f43.google.com with SMTP id md4so874358pbc.30
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2013 06:53:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:09PM +0200, Jan Kara wrote:
> Remove unused t_cow_tid field (ext4 copy-on-write support doesn't seem
> to be happening) and change b_modified and b_jlist to bitfields thus
> saving 8 bytes in the structure.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng
> ---
>  include/linux/journal-head.h |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
> index c18b46f..13a3da2 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -31,21 +31,14 @@ struct journal_head {
>  	/*
>  	 * Journalling list for this buffer [jbd_lock_bh_state()]
>  	 */
> -	unsigned b_jlist;
> +	unsigned b_jlist:4;
>  
>  	/*
>  	 * This flag signals the buffer has been modified by
>  	 * the currently running transaction
>  	 * [jbd_lock_bh_state()]
>  	 */
> -	unsigned b_modified;
> -
> -	/*
> -	 * This feild tracks the last transaction id in which this buffer
> -	 * has been cowed
> -	 * [jbd_lock_bh_state()]
> -	 */
> -	tid_t b_cow_tid;
> +	unsigned b_modified:1;
>  
>  	/*
>  	 * Copy of the buffer data frozen for writing to the log.
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
