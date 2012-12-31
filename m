From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH 3/9 v1] ext4: add physical block and status member
 into extent status tree
Date: Mon, 31 Dec 2012 22:49:52 +0100
Message-ID: <20121231214952.GL7564@quack.suse.cz>
References: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
 <1356335742-11793-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab2LaVtz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Dec 2012 16:49:55 -0500
Content-Disposition: inline
In-Reply-To: <1356335742-11793-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-12-12 15:55:36, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> es_pblk is used to record physical block that maps to the disk.  es_status is
> used to record the status of the extent.  Three status are defined, which are
> written, unwritten and delayed.
  So this means one extent is 48 bytes on 64-bit architectures. If I'm a
nasty user and create artificially fragmented file (by allocating every
second block), extent tree takes 6 MB per GB of file. That's quite a bit
and I think you need to provide a way for kernel to reclaim extent
structures...

								Honza
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/extents_status.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> index 81e9339..85115bb 100644
> --- a/fs/ext4/extents_status.h
> +++ b/fs/ext4/extents_status.h
> @@ -20,10 +20,18 @@
>  #define es_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
>  #endif
>  
> +enum {
> +	EXTENT_STATUS_WRITTEN = 0,	/* written extent */
> +	EXTENT_STATUS_UNWRITTEN = 1,	/* unwritten extent */
> +	EXTENT_STATUS_DELAYED = 2,	/* delayed extent */
> +};
> +
>  struct extent_status {
>  	struct rb_node rb_node;
>  	ext4_lblk_t es_lblk;	/* first logical block extent covers */
>  	ext4_lblk_t es_len;	/* length of extent in block */
> +	ext4_fsblk_t es_pblk;	/* first physical block */
> +	int es_status;		/* record the status of extent */
>  };
>  
>  struct ext4_es_tree {
> -- 
> 1.7.12.rc2.18.g61b472e
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
