From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Wed, 21 Mar 2012 23:23:57 +0100
Message-ID: <20120321222357.GB24330@quack.suse.cz>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org, tytso@mit.edu
To: Thierry Reding <thierry.reding@avionic-design.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 21-03-12 22:50:07, Thierry Reding wrote:
> Using the exported linux/ext2_fs.h header from user space is broken
> since commit 0583fcc because the umode_t type is no longer exported.
> This happens for example when compiling busybox' tune2fs applet. The
> e2fsprogs package does not have this problem because it ships with
> its own header and doesn't use the one exported by the Linux kernel.
> 
> However, since busybox doesn't use the ext2_mask_flags() function the
> easiest fix is to just not export it and as a result the umode_t type
> definition is longer needed.
  Frankly, anybody seriously wanting to do anything with ext[2-4]
filesystems should use header files as provided by libext2fs. So I wonder
if just unexporting the whole file wouldn't be the best solution going
forward. Ted, do you have opinion?

								Honza


> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-ext4@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  include/linux/ext2_fs.h |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
> index 091ab48..20f8f33 100644
> --- a/include/linux/ext2_fs.h
> +++ b/include/linux/ext2_fs.h
> @@ -209,10 +209,7 @@ struct ext2_group_desc
>  #define EXT2_OTHER_FLMASK (EXT2_NODUMP_FL | EXT2_NOATIME_FL)
>  
>  /* Mask out flags that are inappropriate for the given type of inode. */
> -#ifndef __KERNEL__
> -typedef unsigned short umode_t;
> -#endif
> -
> +#ifdef __KERNEL__
>  static inline __u32 ext2_mask_flags(umode_t mode, __u32 flags)
>  {
>  	if (S_ISDIR(mode))
> @@ -222,6 +219,7 @@ static inline __u32 ext2_mask_flags(umode_t mode, __u32 flags)
>  	else
>  		return flags & EXT2_OTHER_FLMASK;
>  }
> +#endif
>  
>  /*
>   * ioctl commands
> -- 
> 1.7.9.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
