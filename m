From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 4/4] quota: add project quota support
Date: Wed, 10 Sep 2014 22:09:01 +0200
Message-ID: <20140910200901.GD10507@quack.suse.cz>
References: <CAPTn0cBRXu_aHS19Mpn-Mjn6pfghE3aKB6+N86e5pU28+AWByQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cBRXu_aHS19Mpn-Mjn6pfghE3aKB6+N86e5pU28+AWByQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 10-09-14 11:54:54, Li Xi wrote:
> Adds ioctl interface support for ext4 project
> 
> This patch adds ioctl interface for setting/getting project of ext4.
> 
> Signed-off-by: Li Xi <lixi <at> ddn.com>
  Please CC linux-api@vger.kernel.org for this patch so that people caring
about kernel API know about the change.

...
> ---
> Index: linux.git/fs/ext4/ioctl.c
> ===================================================================
> --- linux.git.orig/fs/ext4/ioctl.c
> +++ linux.git/fs/ext4/ioctl.c
> @@ -14,6 +14,8 @@
>  #include <linux/compat.h>
>  #include <linux/mount.h>
>  #include <linux/file.h>
> +#include <linux/quotaops.h>
> +#include <linux/quota.h>
>  #include <asm/uaccess.h>
>  #include "ext4_jbd2.h"
>  #include "ext4.h"
> @@ -611,6 +613,104 @@ resizefs_out:
>      case EXT4_IOC_PRECACHE_EXTENTS:
>          return ext4_ext_precache(inode);
> 
> +    case EXT4_IOC_GETPROJECT:
> +    {
> +#ifdef CONFIG_QUOTA_PROJECT
> +        __u32 projid;
> +
> +        if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +            EXT4_FEATURE_RO_COMPAT_PROJECT)) {
> +            ext4_msg(sb, KERN_ERR,
> +                 "get project not supported without "
> +                 "project feature");
  Please no messages into kernel log for failed ioctl(). Userspace could
easily flood logs with them.

> +            return -ENOTSUPP;
  This should be -EOPNOTSUPP I think.

> +        }
> +
> +        projid = (__u32)from_kprojid(&init_user_ns,
> +                         EXT4_I(inode)->i_projid);
> +        return put_user(projid, (__u32 __user *) arg);
> +#else
> +        ext4_msg(sb, KERN_ERR,
> +             "get project not supported without "
> +             "CONFIG_QUOTA_PROJECT");
> +        return -ENOTSUPP;
> +#endif
> +    }
> +    case EXT4_IOC_SETPROJECT:
> +    {
> +#ifdef CONFIG_QUOTA_PROJECT
> +        __u32 projid;
> +        int err;
> +        handle_t *handle;
> +        kprojid_t kprojid;
> +
> +        struct dquot *transfer_to[MAXQUOTAS] = { };
> +
> +        if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +            EXT4_FEATURE_RO_COMPAT_PROJECT)) {
> +            ext4_msg(sb, KERN_ERR,
> +                 "set project not supported without "
> +                 "project feature");
> +            return -ENOTSUPP;
  Same comments as for GETPROJECT apply here...

> +        }
> +
> +        /* Make sure caller can change project. */
> +        if (!capable(CAP_SYS_ADMIN))
> +            return -EACCES;
> +
> +        if (get_user(projid, (__u32 __user *) arg))
> +            return -EFAULT;
> +
> +        kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
> +
> +        if (projid_eq(kprojid, EXT4_I(inode)->i_projid))
> +            return 0;
> +
  You should check whether project id fits into an inode here...

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
