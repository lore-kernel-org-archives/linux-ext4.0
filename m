From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
Date: Mon, 03 Aug 2009 13:00:15 -0500
Message-ID: <4A7725AF.6090106@redhat.com>
References: <4A74584D.2010300@rtr.ca> <4A7722DF.80704@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
	Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbZHCSA4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Aug 2009 14:00:56 -0400
In-Reply-To: <4A7722DF.80704@rtr.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mark Lord wrote:
> (resending, no ack from anyone first time around).

I had previously sent a fix for this to the ext4 list as well, although
w/o the added case for compat_ioctl or the extra #include.

Because this ioctl should be 100% compat everywhere, I don't -think-
it's needed, and

http://marc.info/?l=linux-ext4&m=124872536713005&w=2

suffices....

But if not, minor nitpick, you should move the COMPAT_IOCTL under the
"little f" comment.

-Eric


> Add support for the FIEMAP ioctl for 32-bit user on 64-bit kernel.
> 
> When using a 32-bit runtime on top of a 64-bit kernel,
> programs like "filefrag" and "hdparm --fibmap" do not work correctly.
> 
> This is because there's no compat ioctl entry for the FIEMAP call.
> FIEMAP returns file extent info, similar to FIBMAP (but better).
> 
> Since FIBMAP itself is b0rked on ext4, this leaves no way for a 32-bit
> program to reliably get detailed block information for a file
> when run on top of a 64-bit kernel.  This patch addresses the issue.
> 
> Once upstream, this patch could also be a candidate for -stable.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> 
> Add support for the FIEMAP ioctl for 32-bit user on 64-bit kernel.
> 
> When using a 32-bit runtime on top of a 64-bit kernel,
> programs like "filefrag" and "hdparm --fibmap" do not work correctly.
> 
> This is because there's no compat ioctl entry for the FIEMAP call.
> FIEMAP returns file extent info, similar to FIBMAP (but better).
> 
> Since FIBMAP itself is b0rked on ext4, this leaves no way for a 32-bit
> program to reliably get detailed block information for a file
> when run on top of a 64-bit kernel.  This patch addresses the issue.
> 
> Once upstream, this patch could also be a candidate for -stable.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com> 
> 
> --- old/fs/compat_ioctl.c	2009-08-01 10:47:16.601066905 -0400
> +++ linux/fs/compat_ioctl.c	2009-08-01 10:49:23.054387926 -0400
> @@ -35,6 +35,7 @@
>  #include <linux/falloc.h>
>  #include <linux/fs.h>
>  #include <linux/file.h>
> +#include <linux/fiemap.h>
>  #include <linux/ppp_defs.h>
>  #include <linux/if_ppp.h>
>  #include <linux/if_pppox.h>
> @@ -1907,6 +1908,7 @@
>  COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
>  /* 0x00 */
>  COMPATIBLE_IOCTL(FIBMAP)
> +COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
>  COMPATIBLE_IOCTL(FIGETBSZ)
>  /* 'X' - originally XFS but some now in the VFS */
>  COMPATIBLE_IOCTL(FIFREEZE)
> @@ -2805,6 +2807,7 @@
>  		goto out_fput;
>  #endif
>  
> +	case FS_IOC_FIEMAP:
>  	case FIBMAP:
>  	case FIGETBSZ:
>  	case FIONREAD:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

