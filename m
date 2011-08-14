From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Mon, 15 Aug 2011 00:57:12 +0400
Message-ID: <4E4836A8.3080709@msgid.tls.msk.ru>
References: <4E456436.8070107@msgid.tls.msk.ru> <1313251371-3672-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:55712 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1HNU5O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Aug 2011 16:57:14 -0400
In-Reply-To: <1313251371-3672-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

13.08.2011 20:02, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Hi Michael,
> 	could you please check whether this patch work for you?

With this patch applied to 3.0.1 I can't trigger the issue anymore,
after several attempts -- the system just works as it shold be.
I'm not sure this is the right fix or it's just my testcase isn't
as good as it can be... ;)

> Subject: [PATCH] ext4: Set unwritten flag and increase i_aiodio_unwritten simultaneously.
> From 4f1d797973da8b5cf79f58cc1e4d22efb9d46d19 Mon Sep 17 00:00:00 2001
> From: Tao Ma <boyu.mt@taobao.com>
> Date: Sat, 13 Aug 2011 23:50:28 +0800
> Subject: [PATCH] ext4: Set unwritten flag and increase i_aiodio_unwritten simultaneously.
> 
> EXT4_IO_END_UNWRITTEN flag set and the increase of i_aiodio_unwritten should
> be done simultaneously since ext4_end_io_nolock always clear the flag and
> decrease the counter in the same time.
> 
> We don't increase i_aiodio_unwritten when setting EXT4_IO_END_UNWRITTEN so
> it will go nagative and causes some process to wait forever.
> 
> Part of the patch came from Eric in his e-mail.
> http://marc.info/?l=linux-ext4&m=131316851417460&w=2
> 
> Reported-by: Michael Tokarev<mjt@tls.msk.ru>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

You can add my Tested-By too ;)

Thank you!

And please excuse me for so long delay replying - I was AFK whole weekend.

/mjt

>  fs/ext4/inode.c   |    9 ++++++++-
>  fs/ext4/page-io.c |    6 ++++--
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d47264c..40c0b10 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2668,8 +2668,15 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
>  		goto out;
>  	}
>  
> -	io_end->flag = EXT4_IO_END_UNWRITTEN;
> +	/*
> +	 * It may be over-defensive here to check EXT4_IO_END_UNWRITTEN now,
> +	 * but being more careful is always safe for the future change.
> +	 */
>  	inode = io_end->inode;
> +	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
> +		io_end->flag |= EXT4_IO_END_UNWRITTEN;
> +		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> +	}
>  
>  	/* Add the io_end to per-inode completed io list*/
>  	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 430c401..78839af 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -334,8 +334,10 @@ submit_and_retry:
>  	if ((io_end->num_io_pages >= MAX_IO_PAGES) &&
>  	    (io_end->pages[io_end->num_io_pages-1] != io_page))
>  		goto submit_and_retry;
> -	if (buffer_uninit(bh))
> -		io->io_end->flag |= EXT4_IO_END_UNWRITTEN;
> +	if (buffer_uninit(bh) && !(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
> +		io_end->flag |= EXT4_IO_END_UNWRITTEN;
> +		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> +	}
>  	io->io_end->size += bh->b_size;
>  	io->io_next_block++;
>  	ret = bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));

