Return-Path: <SRS0=z94b=OO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbeLEAIe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Dec 2018 19:08:34 -0500
Date: Tue, 4 Dec 2018 16:08:32 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-mips@linux-mips.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com,
        corbet@lwn.net, ralf@linux-mips.org, paul.burton@mips.com,
        jhogan@kernel.org, green.hu@gmail.com, deanbo422@gmail.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, richard@nod.at,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH V2 7/7] fsverity: Remove filesystem specific build config
 option
Message-ID: <20181205000831.GI70682@gmail.com>
References: <20181204095650.12562-1-chandan@linux.vnet.ibm.com>
 <20181204095650.12562-8-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204095650.12562-8-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Chandan,

On Tue, Dec 04, 2018 at 03:26:50PM +0530, Chandan Rajendra wrote:
> In order to have a common code base for fsverity "post read" processing
> for all filesystems which support fsverity, this commit removes
> filesystem specific build config option (e.g. CONFIG_EXT4_FS_VERITY)
> and replaces it with a build option (i.e. CONFIG_FS_VERITY) whose
> value affects all the filesystems making use of fsverity.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  Documentation/filesystems/fsverity.rst |  4 ++--
>  fs/ext4/Kconfig                        | 20 --------------------
>  fs/ext4/ext4.h                         |  2 --
>  fs/ext4/readpage.c                     |  4 ++--
>  fs/ext4/super.c                        |  6 +++---
>  fs/ext4/sysfs.c                        |  4 ++--
>  fs/f2fs/Kconfig                        | 20 --------------------
>  fs/f2fs/data.c                         |  2 +-
>  fs/f2fs/f2fs.h                         |  2 --
>  fs/f2fs/super.c                        |  6 +++---
>  fs/f2fs/sysfs.c                        |  4 ++--
>  fs/verity/Kconfig                      |  3 ++-
>  include/linux/fs.h                     |  4 ++--
>  include/linux/fsverity.h               |  3 +--
>  14 files changed, 20 insertions(+), 64 deletions(-)
> 
[...]
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index c30c4f6ed411..f37132c640ee 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -19,8 +19,7 @@ struct fsverity_operations {
>  	int (*get_metadata_end)(struct inode *inode, loff_t *metadata_end_ret);
>  };
>  
> -#if __FS_HAS_VERITY
> -
> +#ifdef CONFIG_FS_VERITY
>  /* ioctl.c */
>  extern int fsverity_ioctl_enable(struct file *filp, const void __user *arg);
>  extern int fsverity_ioctl_measure(struct file *filp, void __user *arg);
> -- 
> 2.19.1
> 

Can you grep for __FS_HAS_VERITY?  It's still mentioned twice in comments for
this #ifdef (these should be changed to CONFIG_FS_VERITY), and it's still
defined in fs/verity/fsverity_private.h (that one should be removed).

Thanks,

- Eric
