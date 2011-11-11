From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH v2 1/8] vfs: Add a new flag and related functions in
 buffer to count io types
Date: Fri, 11 Nov 2011 10:48:33 +0000
Message-ID: <1321008513.2710.33.camel@menhir>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
	 <1320921294-30321-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab1KKKq6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Nov 2011 05:46:58 -0500
In-Reply-To: <1320921294-30321-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, 2011-11-10 at 18:34 +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> 'Issue' flag is added into buffer_head to indicate that a request is issued
> to the disk. When an io doesn't hit page cache, 'Issue' flag will be set in
> submit_bh(). Filesystem can understand request is sent to the disk according
> to whether or not this flag is set. This flag will be cleared after filesystem
> tests it. If filesystem doesn't want to count the io type, it can ignore this
> flag.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> ---
>  fs/buffer.c                 |    3 +++
>  include/linux/buffer_head.h |    5 +++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 70a1974..f681caa 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2920,6 +2920,9 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	BUG_ON(buffer_delay(bh));
>  	BUG_ON(buffer_unwritten(bh));
>  
> +	/* set issue flag for indicating a request is issued to the disk */
> +	set_buffer_issue(bh);
> +
>  	/*
>  	 * Only clear out a write error when rewriting
>  	 */
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 458f497..2bccdb4 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -38,6 +38,10 @@ enum bh_state_bits {
>  	BH_PrivateStart,/* not a state bit, but the first bit available
>  			 * for private allocation by other entities
>  			 */
> +
> +	BH_Issue,	/* Issue a request to the disk when this request
> +			 * doesn't hit cache
> +			 */
>  };
This looks like it will collide with any fs using more than one private
flag, for example, ext4.


Steve.



>  
>  #define MAX_BUF_PER_PAGE (PAGE_CACHE_SIZE / 512)
> @@ -124,6 +128,7 @@ BUFFER_FNS(Delay, delay)
>  BUFFER_FNS(Boundary, boundary)
>  BUFFER_FNS(Write_EIO, write_io_error)
>  BUFFER_FNS(Unwritten, unwritten)
> +BUFFER_FNS(Issue, issue)
>  
>  #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
>  #define touch_buffer(bh)	mark_page_accessed(bh->b_page)


