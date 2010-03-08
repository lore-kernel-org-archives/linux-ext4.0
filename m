From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat
 mode
Date: Sun, 07 Mar 2010 23:47:40 -0600
Message-ID: <4B948F7C.6010109@redhat.com>
References: <201003072132.10579.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0CHFrv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Mar 2010 00:47:51 -0500
In-Reply-To: <201003072132.10579.borntraeger@de.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christian Borntraeger wrote:
> I have an x86_64 kernel with i386 userspace. e4defrag fails on the
> EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
> case. It seems that struct move_extent is compat save, only types
> with fixed widths are used:

and they're well-aligned.

> {
>         __u32 reserved;         /* should be zero */
>         __u32 donor_fd;         /* donor file descriptor */
>         __u64 orig_start;       /* logical start offset in block for orig */
>         __u64 donor_start;      /* logical start offset in block for donor */
>         __u64 len;              /* block length to be moved */
>         __u64 moved_len;        /* moved block length */
> };
> 
> Lets just wire up EXT4_IOC_MOVE_EXT for the compat case.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> CCed: Akira Fujita <a-fujita@rs.jp.nec.com> 

Looks fine to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/ioctl.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -375,6 +375,8 @@ long ext4_compat_ioctl(struct file *file
>  		break;
>  	case EXT4_IOC_GROUP_ADD:
>  		break;
> +	case EXT4_IOC_MOVE_EXT:
> +		break;
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

