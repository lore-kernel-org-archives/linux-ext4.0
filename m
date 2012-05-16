From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] block: add BH_Meta flag
Date: Wed, 16 May 2012 15:32:39 +0300
Message-ID: <4FB39E67.80109@panasas.com>
References: <1336748577-9258-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<tytso@mit.edu>, <adilger@whamcloud.com>, <hch@infradead.org>,
	<arnd.bergmann@linaro.org>, <venkat@linaro.org>,
	Saugata Das <saugata.das@linaro.org>
To: Saugata Das <saugata.das@stericsson.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:43306 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab2EPMdF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 May 2012 08:33:05 -0400
In-Reply-To: <1336748577-9258-1-git-send-email-saugata.das@stericsson.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/11/2012 06:02 PM, Saugata Das wrote:

> From: Saugata Das <saugata.das@linaro.org>
> 
> Today, storage devices like eMMC has special features like data tagging
> (introduced in MMC-4.5 version) in order to improve performance of some
> specific writes. On MMC stack, data tagging is used for all writes which
> has REQ_META flag set. This patch adds the capability to add REQ_META flag
> during meta data write.
> 
> Signed-off-by: Saugata Das <saugata.das@linaro.org>
> ---
>  fs/buffer.c                 |   10 ++++++++--
>  include/linux/buffer_head.h |    2 ++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 36d6665..688b38b 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1685,7 +1685,10 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  	do {
>  		struct buffer_head *next = bh->b_this_page;
>  		if (buffer_async_write(bh)) {
> -			submit_bh(write_op, bh);
> +			if (buffer_meta(bh))
> +				submit_bh(write_op | REQ_META, bh);
> +			else
> +				submit_bh(write_op, bh);


Its not nice to duplicate a call site for the parameter difference
it's better to change the parameter and call the function in one
place. (an assembler call site can get big)

You can do:
+				submit_bh(write_op | (buffer_meta(bh) << __REQ_META), bh);

And also avoid a conditional inside a loop.


>  			nr_underway++;
>  		}
>  		bh = next;
> @@ -1739,7 +1742,10 @@ recover:
>  		struct buffer_head *next = bh->b_this_page;
>  		if (buffer_async_write(bh)) {
>  			clear_buffer_dirty(bh);
> -			submit_bh(write_op, bh);
> +			if (buffer_meta(bh))
> +				submit_bh(write_op | REQ_META, bh);
> +			else
> +				submit_bh(write_op, bh);


Here too

Boaz

>  			nr_underway++;
>  		}
>  		bh = next;
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index ef26043..0776564 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -34,6 +34,7 @@ enum bh_state_bits {
>  	BH_Write_EIO,	/* I/O error on write */
>  	BH_Unwritten,	/* Buffer is allocated on disk but not written */
>  	BH_Quiet,	/* Buffer Error Prinks to be quiet */
> +	BH_Meta,	/* Is meta */
>  
>  	BH_PrivateStart,/* not a state bit, but the first bit available
>  			 * for private allocation by other entities
> @@ -126,6 +127,7 @@ BUFFER_FNS(Delay, delay)
>  BUFFER_FNS(Boundary, boundary)
>  BUFFER_FNS(Write_EIO, write_io_error)
>  BUFFER_FNS(Unwritten, unwritten)
> +BUFFER_FNS(Meta, meta)
>  
>  #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
>  #define touch_buffer(bh)	mark_page_accessed(bh->b_page)


