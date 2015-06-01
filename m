From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: misc: Remove broken whole device check
Date: Mon, 1 Jun 2015 16:56:45 -0600
Message-ID: <74D84728-EFE7-4FF0-A99C-20F1F18EF8DF@dilger.ca>
References: <1433198362-86983-1-git-send-email-ryao@gentoo.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Richard Yao <richard.yao@clusterhq.com>
To: Richard Yao <ryao@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34655 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbbFAW4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Jun 2015 18:56:48 -0400
Received: by payr10 with SMTP id r10so36458828pay.1
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2015 15:56:48 -0700 (PDT)
In-Reply-To: <1433198362-86983-1-git-send-email-ryao@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 1, 2015, at 4:39 PM, Richard Yao <ryao@gentoo.org> wrote:
> 
> From: Richard Yao <richard.yao@clusterhq.com>
> 
> Modern Linux major/minor numbering on block devices no longer conform to
> the divisible by 64 rule for minor numbering. On my development system,
> the correct number is 16. Consequently, this applies only to every 4th
> drive on a modern system, which is inconsistent. That caused the
> following bug to be filed against Flocker:
> 
> https://clusterhq.atlassian.net/browse/FLOC-2041
> 
> We could unconditionally pass -F to override this check whenever it
> triggers, but that it would also override the libblkid check that
> determines whether there are existing partitions, logical volumes or
> filesystems on the disk, which seems unwise.
> 
> I propose that this check be removed because passing a whole disk to
> mke2fs is a valid use case and given how long this has been broken,
> users are already accustomed to the behavior where -F is not necessary
> to format a whole disk as ext4.

I totally agree - we've been overriding this check for years, and
I'm glad to see it go.  We have other mechanisms today to avoid
users accidentally formatting the wrong device (O_EXCL, check for
existing filesystems in interactive mode, etc.)

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Signed-off-by: Richard Yao <ryao@gentoo.org>
> ---
> misc/plausible.c | 32 --------------------------------
> 1 file changed, 32 deletions(-)
> 
> diff --git a/misc/plausible.c b/misc/plausible.c
> index 1848a26..97492b9 100644
> --- a/misc/plausible.c
> +++ b/misc/plausible.c
> @@ -18,9 +18,6 @@
> #include "config.h"
> #include <fcntl.h>
> #include <time.h>
> -#ifdef HAVE_LINUX_MAJOR_H
> -#include <linux/major.h>
> -#endif
> #include <sys/types.h>
> #ifdef HAVE_SYS_STAT_H
> #include <sys/stat.h>
> @@ -265,35 +262,6 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
> 	if (ret >= 0)
> 		return ret;
> 
> -#ifdef HAVE_LINUX_MAJOR_H
> -#ifndef MAJOR
> -#define MAJOR(dev)	((dev)>>8)
> -#define MINOR(dev)	((dev) & 0xff)
> -#endif
> -#ifndef SCSI_BLK_MAJOR
> -#ifdef SCSI_DISK0_MAJOR
> -#ifdef SCSI_DISK8_MAJOR
> -#define SCSI_DISK_MAJOR(M) ((M) == SCSI_DISK0_MAJOR || \
> -	((M) >= SCSI_DISK1_MAJOR && (M) <= SCSI_DISK7_MAJOR) || \
> -	((M) >= SCSI_DISK8_MAJOR && (M) <= SCSI_DISK15_MAJOR))
> -#else
> -#define SCSI_DISK_MAJOR(M) ((M) == SCSI_DISK0_MAJOR || \
> -	((M) >= SCSI_DISK1_MAJOR && (M) <= SCSI_DISK7_MAJOR))
> -#endif /* defined(SCSI_DISK8_MAJOR) */
> -#define SCSI_BLK_MAJOR(M) (SCSI_DISK_MAJOR((M)) || (M) == SCSI_CDROM_MAJOR)
> -#else
> -#define SCSI_BLK_MAJOR(M)  ((M) == SCSI_DISK_MAJOR || (M) == SCSI_CDROM_MAJOR)
> -#endif /* defined(SCSI_DISK0_MAJOR) */
> -#endif /* defined(SCSI_BLK_MAJOR) */
> -	if (((MAJOR(s.st_rdev) == HD_MAJOR &&
> -	      MINOR(s.st_rdev)%64 == 0) ||
> -	     (SCSI_BLK_MAJOR(MAJOR(s.st_rdev)) &&
> -	      MINOR(s.st_rdev)%16 == 0))) {
> -		printf(_("%s is entire device, not just one partition!\n"),
> -		       device);
> -		return 0;
> -	}
> -#endif
> 	return 1;
> }
> 
> -- 
> 2.3.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





