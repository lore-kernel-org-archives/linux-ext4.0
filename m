From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RESEND] ext4: change return value from int to ssize_t
 in ext4_file_write
Date: Tue, 22 May 2012 14:44:03 -0500
Message-ID: <4FBBEC83.8030604@redhat.com>
References: <20120412202029.GB19808@quack.suse.cz> <1334280157-11630-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, jouni.siren@iki.fi, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757901Ab2EVTok (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 May 2012 15:44:40 -0400
In-Reply-To: <1334280157-11630-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/12/12 8:22 PM, Zheng Liu wrote:
> On 64-platform, when we do a write operation with a huge number of data, it
> will cause that the ret variable overflows.  So it is replaced with ssize_t.
> 
> Reported-by: Jouni Siren <jouni.siren@iki.fi>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Ted, is this one queued anywhere?  Seems lost so far.

Thanks,
-Eric

> ---
> Hi Jan,
> 
> You are right.  I have changed the commit log.  ;-)
> 
> Regards,
> Zheng
> 
>  fs/ext4/file.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index cb70f18..8c7642a 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -95,7 +95,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  {
>  	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
>  	int unaligned_aio = 0;
> -	int ret;
> +	ssize_t ret;
>  
>  	/*
>  	 * If we have encountered a bitmap-format file, the size limit

