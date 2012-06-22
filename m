From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] Add additional owner identifier
Date: Fri, 22 Jun 2012 02:03:53 +0200
Message-ID: <20120622000353.GF11645@quack.suse.cz>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
 <1340269733-25922-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760697Ab2FVADz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2012 20:03:55 -0400
Content-Disposition: inline
In-Reply-To: <1340269733-25922-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 21-06-12 13:08:49, Dmitry Monakhov wrote:
> This patch add project inode identifier. Project ID may be used as
> auxiliary owner specifier in addition to standard uid/gid.
  I would just join patches 1 and 2. One without the other looks a bit
dumb... Otherwise I'm OK with the changes. I can take these two patches
through my tree when filesystem maintainers agree they want this feature and
are going to merge corresponding fs patches...
  

								Honza

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/Kconfig            |    7 +++++++
>  include/linux/fs.h    |    1 +
>  include/linux/xattr.h |    3 +++
>  3 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index c8554b5..1932458 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -60,6 +60,13 @@ config FILE_LOCKING
>  	  This option enables standard file locking support, required
>            for filesystems like NFS and for the flock() system
>            call. Disabling this option saves about 11k.
> +config PROJECT_ID
> +	bool "Enable project inode identifier"
> +	default y
> +	help
> +	  This option enables project inode identifier. Project ID
> +	  may be used as auxiliary owner specifier in addition to
> +	  standard uid/gid.
>  
>  source "fs/notify/Kconfig"
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b0a6d44..6779fc2 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1739,6 +1739,7 @@ struct super_operations {
>  	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
>  	int (*nr_cached_objects)(struct super_block *);
>  	void (*free_cached_objects)(struct super_block *, int);
> +	u32 (*get_prjid)(const struct inode *inode);
>  };
>  
>  /*
> diff --git a/include/linux/xattr.h b/include/linux/xattr.h
> index e5d1220..f8a83c3 100644
> --- a/include/linux/xattr.h
> +++ b/include/linux/xattr.h
> @@ -61,6 +61,9 @@
>  
>  #include <linux/types.h>
>  
> +#define XATTR_PRJID "system.project_id"
> +#define XATTR_PRJID_LEN (sizeof (XATTR_PRJID))
> +
>  struct inode;
>  struct dentry;
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
