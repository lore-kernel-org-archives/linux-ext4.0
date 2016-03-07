From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] libext2fs: return errno on failure in
 ext2fs_sync_device()
Date: Mon, 7 Mar 2016 11:31:37 +0800
Message-ID: <20160307033137.GC4672@eguan.usersys.redhat.com>
References: <1452443341-1851-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:36748 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbcCGDbq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Mar 2016 22:31:46 -0500
Received: by mail-qg0-f50.google.com with SMTP id u110so87217210qge.3
        for <linux-ext4@vger.kernel.org>; Sun, 06 Mar 2016 19:31:46 -0800 (PST)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s75sm7225551qge.17.2016.03.06.19.31.43
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Mar 2016 19:31:45 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1452443341-1851-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 11, 2016 at 12:29:01AM +0800, Eryu Guan wrote:
> ext2fs_sync_device() returns -1 on ioctl error, which is the return
> value from ioctl, but the callers expect the return value to be an errno
> on failure.
> 
> Seen this while flushing in e2fsck on a file:
> 
> [root@localhost e2fsprogs]# e2fsck -Ff ~/ext4.img
> ext2fs_sync_device: Unknown code ____ 255 while trying to flush /root/ext4.img
> 
> After fixing, correct error message is printed:
> 
> [root@localhost e2fsprogs]# e2fsck -Ff ~/ext4.img
> ext2fs_sync_device: Inappropriate ioctl for device while trying to flush /root/ext4.img
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

ping on this one :)

Eryu

> ---
>  lib/ext2fs/flushb.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/ext2fs/flushb.c b/lib/ext2fs/flushb.c
> index 98821fc..c62b659 100644
> --- a/lib/ext2fs/flushb.c
> +++ b/lib/ext2fs/flushb.c
> @@ -52,6 +52,7 @@
>   */
>  errcode_t ext2fs_sync_device(int fd, int flushb)
>  {
> +	int ret = 0;
>  	/*
>  	 * We always sync the device in case we're running on old
>  	 * kernels for which we can lose data if we don't.  (There
> @@ -66,14 +67,18 @@ errcode_t ext2fs_sync_device(int fd, int flushb)
>  #ifdef BLKFLSBUF
>  		if (ioctl (fd, BLKFLSBUF, 0) == 0)
>  			return 0;
> +		ret = errno;
>  #elif defined(__linux__)
>  #warning BLKFLSBUF not defined
>  #endif
>  #ifdef FDFLUSH
> -		return ioctl(fd, FDFLUSH, 0);   /* In case this is a floppy */
> +		/* In case this is a floppy */
> +		if (ioctl(fd, FDFLUSH, 0) == 0)
> +			return 0;
> +		ret = errno;
>  #elif defined(__linux__)
>  #warning FDFLUSH not defined
>  #endif
>  	}
> -	return 0;
> +	return ret;
>  }
> -- 
> 1.8.3.1
> 
