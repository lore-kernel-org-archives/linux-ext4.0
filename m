From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize: Do not fail if EXT4_IOC_RESIZE_FS ioctl doesn't
 exist
Date: Fri, 14 Oct 2011 11:11:08 -0500
Message-ID: <4E985F1C.4050504@redhat.com>
References: <1318607374-17246-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, xiaoqiangnk@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab1JNQLN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Oct 2011 12:11:13 -0400
In-Reply-To: <1318607374-17246-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/14/11 10:49 AM, Lukas Czerner wrote:
> Commit 9f6ba888f027ba4daf57ac61a11a6dce98e42347 added support for new
> online resize ioctl EXT4_IOC_RESIZE_FS. It is also trying to avoid
> failure when this ioctl() is not supported by the kernel however
> it is checking wrong error code (EINVAL).
> 
> When the ioctl does not exist, errno is set to ENOTTY, so we should
> check for that, rather than EINVAL which means that ioctl arguments
> are not valid. So change the code to check for ENOTTY and allow
> resize2fs to try to use the old approach. Also add some comments.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Makes sense, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> 
> Btw I can not find the new kernel code anywhere. It is not in Linus tree,
> it also is not in the github ext4 master, nor dev tree. Where it is then ?
> The problem is that the recent released e2fsprogs are broken for all
> kernels. To be more specific, resize2fs is broken for all kernels.
> 
> 
>  resize/online.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/resize/online.c b/resize/online.c
> index 77290c2..1a77839 100644
> --- a/resize/online.c
> +++ b/resize/online.c
> @@ -72,7 +72,12 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
>  	}
>  
>  	if (ioctl(fd, EXT4_IOC_RESIZE_FS, new_size)) {
> -		if (errno != EINVAL) {
> +		/*
> +		 * If kernel does not support EXT4_IOC_RESIZE_FS, use the
> +		 * old online resize. Note that the old approach does not
> +		 * handle >32 bit file systems
> +		 */
> +		if (errno != ENOTTY) {
>  			if (errno == EPERM)
>  				com_err(program_name, 0,
>  				_("Permission denied to resize filesystem"));

