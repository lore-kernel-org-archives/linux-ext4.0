From: "Kazuya Mio" <k-mio@sx.jp.nec.com>
Subject: RE: [PATCH V4] mke2fs: disallow creating FS on a loop mounted file with no option
Date: Fri, 29 Nov 2013 15:25:31 +0900
Message-ID: <003901ceeccb$ce268430$6a738c90$@sx.jp.nec.com>
References: <527B309D.4090706@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: "'Andreas Dilger'" <adilger@dilger.ca>, <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:49466 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3K2Gbh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Nov 2013 01:31:37 -0500
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id rAT6VahT022405
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 29 Nov 2013 15:31:36 +0900 (JST)
In-Reply-To: <527B309D.4090706@sx.jp.nec.com>
Content-Language: ja
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ping?
Any comments/suggestions will be welcome.

Regards,
Kazuya Mio

> 2013/11/07 15:18:05, k-mio@sx.jp.nec.com wrote:
> 
> When /etc/mtab is a symlink of /proc/mounts, mke2fs without -FF option
> can create a filesystem on the image file that is mounted.
> According to mke2fs man page, we should specify -FF option in this case.
> 
> This patch protects filesystem from unintended mke2fs caused by human error.
> 
> How to reproduce:
>   # mke2fs -t ext4 -Fq fs.img
>   # mount -o loop fs.img /mnt/mp1
>   # mke2fs -t ext4 -Fq fs.img && echo "mke2fs success"
>   mke2fs success
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---
>  configure.in           |    1 +
>  lib/ext2fs/ismounted.c |   41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
> diff --git a/configure.in b/configure.in
> index 049dc11..fef8d9b 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -920,6 +920,7 @@ AC_CHECK_HEADERS(m4_flatten([
>  	linux/falloc.h
>  	linux/fd.h
>  	linux/major.h
> +	linux/loop.h
>  	net/if_dl.h
>  	netinet/in.h
>  	sys/disklabel.h
> diff --git a/lib/ext2fs/ismounted.c b/lib/ext2fs/ismounted.c
> index 2c1bd75..6c6ecff 100644
> --- a/lib/ext2fs/ismounted.c
> +++ b/lib/ext2fs/ismounted.c
> @@ -21,6 +21,13 @@
>  #ifdef HAVE_LINUX_FD_H
>  #include <linux/fd.h>
>  #endif
> +#ifdef HAVE_LINUX_LOOP_H
> +#include <linux/loop.h>
> +#include <sys/ioctl.h>
> +#ifdef HAVE_LINUX_MAJOR_H
> +#include <linux/major.h>
> +#endif /* HAVE_LINUX_MAJOR_H */
> +#endif /* HAVE_LINUX_LOOP_H */
>  #ifdef HAVE_MNTENT_H
>  #include <mntent.h>
>  #endif
> @@ -35,6 +42,36 @@
>  #include "ext2_fs.h"
>  #include "ext2fs.h"
> 
> +/*
> + * Check to see if a regular file is mounted.
> + * If /etc/mtab/ is a symlink of /proc/mounts, you will need the following check
> + * because the name in /proc/mounts is a loopback device not a regular file.
> + */
> +static int check_loop_mounted(const char *mnt_fsname, dev_t mnt_rdev,
> +				dev_t file_dev, ino_t file_ino)
> +{
> +#if defined(HAVE_LINUX_LOOP_H) && defined(HAVE_LINUX_MAJOR_H)
> +	struct loop_info64 loopinfo;
> +	int loop_fd, ret;
> +
> +	if (major(mnt_rdev) == LOOP_MAJOR) {
> +		loop_fd = open(mnt_fsname, O_RDONLY);
> +		if (loop_fd < 0)
> +			return -1;
> +
> +		ret = ioctl(loop_fd, LOOP_GET_STATUS64, &loopinfo);
> +		close(loop_fd);
> +		if (ret < 0)
> +			return -1;
> +
> +		if (file_dev == loopinfo.lo_device &&
> +				file_ino == loopinfo.lo_inode)
> +			return 1;
> +	}
> +#endif /* defined(HAVE_LINUX_LOOP_H) && defined(HAVE_LINUX_MAJOR_H) */
> +	return 0;
> +}
> +
>  #ifdef HAVE_SETMNTENT
>  /*
>   * Helper function which checks a file in /etc/mtab format to see if a
> @@ -82,6 +119,10 @@ static errcode_t check_mntent_file(const char *mtab_file, const char *file,
>  #ifndef __GNU__
>  				if (file_rdev && (file_rdev == st_buf.st_rdev))
>  					break;
> +				if (check_loop_mounted(mnt->mnt_fsname,
> +						st_buf.st_rdev, file_dev,
> +						file_ino) == 1)
> +					break;
>  #endif	/* __GNU__ */
>  			} else {
>  				if (file_dev && ((file_dev == st_buf.st_dev) &&
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

