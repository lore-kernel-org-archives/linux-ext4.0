From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fix ext2 parse_options printk
Date: Tue, 8 Dec 2009 11:00:32 +0100
Message-ID: <20091208100032.GA4095@quack.suse.de>
References: <1260194461-8937-1-git-send-email-jeremy.cochoy@gmail.com>
 <1260194461-8937-2-git-send-email-jeremy.cochoy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Manish Katiyar <mkatiyar@gmail.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Corentin Chary <corentin.chary@gmail.com>
To: root <jeremy.cochoy@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753294AbZLHKAf@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1260194461-8937-2-git-send-email-jeremy.cochoy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 07-12-09 15:01:01, root wrote:
> From: Jeremy Cochoy <jeremy.cochoy@gmail.com>
> 
> Signed-off-by: Jeremy Cochoy <jeremy.cochoy@gmail.com>
  Thanks for the patch but it's actually already fixed in my tree due to
ext2 message unification patches. So should get into 2.6.33-rc1.

									Honza
> ---
>  fs/ext2/super.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 1a9ffee..f28618f 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -505,7 +505,7 @@ static int parse_options (char * options,
>  #else
>  		case Opt_user_xattr:
>  		case Opt_nouser_xattr:
> -			printk("EXT2 (no)user_xattr options not supported\n");
> +			printk(KERN_NOTICE "EXT2 (no)user_xattr options not supported\n");
>  			break;
>  #endif
>  #ifdef CONFIG_EXT2_FS_POSIX_ACL
> @@ -518,14 +518,14 @@ static int parse_options (char * options,
>  #else
>  		case Opt_acl:
>  		case Opt_noacl:
> -			printk("EXT2 (no)acl options not supported\n");
> +			printk(KERN_NOTICE "EXT2 (no)acl options not supported\n");
>  			break;
>  #endif
>  		case Opt_xip:
>  #ifdef CONFIG_EXT2_FS_XIP
>  			set_opt (sbi->s_mount_opt, XIP);
>  #else
> -			printk("EXT2 xip option not supported\n");
> +			printk(KERN_NOTICE "EXT2 xip option not supported\n");
>  #endif
>  			break;
>  
> @@ -550,11 +550,11 @@ static int parse_options (char * options,
>  
>  		case Opt_reservation:
>  			set_opt(sbi->s_mount_opt, RESERVATION);
> -			printk("reservations ON\n");
> +			printk(KERN_INFO "reservations ON\n");
>  			break;
>  		case Opt_noreservation:
>  			clear_opt(sbi->s_mount_opt, RESERVATION);
> -			printk("reservations OFF\n");
> +			printk(KERN_INFO "reservations OFF\n");
>  			break;
>  		case Opt_ignore:
>  			break;
> -- 
> 1.5.6.5
> 
