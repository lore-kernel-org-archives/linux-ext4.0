From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 4/4] EXT2: add 'notify' mount option
Date: Wed, 10 Jun 2009 23:03:13 +0200
Message-ID: <20090610210313.GD1381@ucw.cz>
References: <e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com> <60607de38c1ebbd1ba1cb33d85f1dcdec77f3c61.1244049681.git.ext-denis.2.karpov@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, akpm@linux-foundation.org,
	hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	adrian.hunter@nokia.com, artem.bityutskiy@nokia.com, tytso@mit.edu
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46352 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859AbZFJVDV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2009 17:03:21 -0400
Content-Disposition: inline
In-Reply-To: <60607de38c1ebbd1ba1cb33d85f1dcdec77f3c61.1244049681.git.ext-denis.2.karpov@nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 2009-06-03 18:05:18, Denis Karpov wrote:
> Implement EXT2 fs mount option 'notify'. The effect of this option
> is that a notification is sent to userspace on errors that indicate
> filesystem damage/inconsistency. Generic filesystem corruption
> notification mechnism is used.

By the time you start checking volume, you may have already damaged
data, right?

(Imagine two inodes pointing to same block, lets say /etc/shadow and
/tmp/foo. Writes to /tmp/foo will now kill your passwords. fsck would
duplicate the blocks, but I do not think internal checking in ext2
would catch it soon enough).

> Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
> ---
>  fs/ext2/super.c         |   15 ++++++++++++++-
>  include/linux/ext2_fs.h |    2 +-
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 5c4afe6..04802cd 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -32,6 +32,7 @@
>  #include <linux/mount.h>
>  #include <linux/log2.h>
>  #include <linux/quotaops.h>
> +#include <linux/genhd.h>
>  #include <asm/uaccess.h>
>  #include "ext2.h"
>  #include "xattr.h"
> @@ -68,6 +69,8 @@ void ext2_error (struct super_block * sb, const char * function,
>  		printk("Remounting filesystem read-only\n");
>  		sb->s_flags |= MS_RDONLY;
>  	}
> +	if (test_opt(sb, ERR_NOTIFY))
> +		notify_part_fs_unclean(part_to_dev(sb->s_bdev->bd_part), 1);
>  }
>  
>  void ext2_warning (struct super_block * sb, const char * function,
> @@ -81,6 +84,8 @@ void ext2_warning (struct super_block * sb, const char * function,
>  	vprintk(fmt, args);
>  	printk("\n");
>  	va_end(args);
> +	if (test_opt(sb, ERR_NOTIFY))
> +		notify_part_fs_unclean(part_to_dev(sb->s_bdev->bd_part), 1);
>  }
>  
>  void ext2_update_dynamic_rev(struct super_block *sb)
> @@ -289,6 +294,9 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  	if (!test_opt(sb, RESERVATION))
>  		seq_puts(seq, ",noreservation");
>  
> +	if (!test_opt(sb, ERR_NOTIFY))
> +		seq_puts(seq, ",notify");
> +
>  	return 0;
>  }
>  
> @@ -391,7 +399,8 @@ enum {
>  	Opt_err_ro, Opt_nouid32, Opt_nocheck, Opt_debug,
>  	Opt_oldalloc, Opt_orlov, Opt_nobh, Opt_user_xattr, Opt_nouser_xattr,
>  	Opt_acl, Opt_noacl, Opt_xip, Opt_ignore, Opt_err, Opt_quota,
> -	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
> +	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation,
> +	Opt_err_notify,
>  };
>  
>  static const match_table_t tokens = {
> @@ -425,6 +434,7 @@ static const match_table_t tokens = {
>  	{Opt_usrquota, "usrquota"},
>  	{Opt_reservation, "reservation"},
>  	{Opt_noreservation, "noreservation"},
> +	{Opt_err_notify, "notify"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -565,6 +575,9 @@ static int parse_options (char * options,
>  			clear_opt(sbi->s_mount_opt, RESERVATION);
>  			printk("reservations OFF\n");
>  			break;
> +		case Opt_err_notify:
> +			set_opt(sbi->s_mount_opt, ERR_NOTIFY);
> +			break;
>  		case Opt_ignore:
>  			break;
>  		default:
> diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
> index 121720d..ecec20b 100644
> --- a/include/linux/ext2_fs.h
> +++ b/include/linux/ext2_fs.h
> @@ -347,7 +347,7 @@ struct ext2_inode {
>  #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
>  #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
>  #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
> -
> +#define EXT2_MOUNT_ERR_NOTIFY		0x100000  /* Error notifications */
>  
>  #define clear_opt(o, opt)		o &= ~EXT2_MOUNT_##opt
>  #define set_opt(o, opt)			o |= EXT2_MOUNT_##opt

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
