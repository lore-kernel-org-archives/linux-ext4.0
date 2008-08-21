From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Date: Thu, 21 Aug 2008 12:58:41 -0700
Message-ID: <20080821125841.a04a706f.akpm@linux-foundation.org>
References: <20080818212819t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, hch@infradead.org, axboe@kernel.dk,
	mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbYHUT7v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Aug 2008 15:59:51 -0400
In-Reply-To: <20080818212819t-sato@mail.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 18 Aug 2008 21:28:19 +0900
Takashi Sato <t-sato@yk.jp.nec.com> wrote:

> The ioctls for the generic freeze feature are below.
> o Freeze the filesystem
>   int ioctl(int fd, int FIFREEZE, arg)
>     fd: The file descriptor of the mountpoint
>     FIFREEZE: request code for the freeze
>     arg: Ignored
>     Return value: 0 if the operation succeeds. Otherwise, -1
> 
> o Unfreeze the filesystem
>   int ioctl(int fd, int FITHAW, arg)
>     fd: The file descriptor of the mountpoint
>     FITHAW: request code for unfreeze
>     arg: Ignored
>     Return value: 0 if the operation succeeds. Otherwise, -1
> 
>
> ...
>
> --- linux-2.6.27-rc2.org/include/linux/fs.h	2008-08-06 13:49:54.000000000 +0900
> +++ linux-2.6.27-rc2-freeze/include/linux/fs.h	2008-08-07 08:59:54.000000000 +0900
> @@ -226,6 +226,8 @@ extern int dir_notify_enable;
>  #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
>  #define FIBMAP	   _IO(0x00,1)	/* bmap access */
>  #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
> +#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
> +#define FITHAW		_IOWR('X', 120, int)	/* Thaw */

FIFREEZE is 119, but a few lines above we have

#define BLKDISCARD _IO(0x12,119)

Should we be using 120 and 121 here?

>  #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
>  #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
> @@ -574,6 +576,10 @@ struct block_device {
>  	 * care to not mess up bd_private for that case.
>  	 */
>  	unsigned long		bd_private;
> +	/* The counter of freeze processes */
> +	int			bd_freeze_count;
> +	/* Semaphore for freeze */
> +	struct semaphore	bd_freeze_sem;

"freeze" is not an adequate description of what this protects.  I think
it's only the modification and testing of bd_freeze_count, isn't it?

If so, all this could be done more neatly by removing the lock,
switching to atomic_t and using our (rich) atomic_t operations.

otoh, perhaps it protects more than this, in which case the lock
can/should be switched to a `struct mutex'?


