From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsck: ignore differing NEEDS_RECOVERY flag on backup	sbs
Date: Sat, 22 Nov 2008 11:36:54 -0600
Message-ID: <20081122173654.GE3186@webber.adilger.int>
References: <49281F18.7080404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54456 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177AbYKVRhB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Nov 2008 12:37:01 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAMHav2Q011742
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 09:36:57 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAQ00101WQXMP00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 22 Nov 2008 09:36:57 -0800 (PST)
In-reply-to: <49281F18.7080404@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 22, 2008  09:02 -0600, Eric Sandeen wrote:
> This is for RH bugzilla 471925 -  Complete scan of filesystems expanded online
> 
> When we resize online, the primary superblock gets copied to all
> the backups, and of course since we're mounted the NEEDS_RECOVERY
> flag is set.  A subsequent fsck will find the backups have the
> NEEDS_RECOVERY flag set while the primary does not, and this
> forces a full fsck pass.
> 
> I think this flag can be safely ignored in the flag comparisons.

Should we also mask out this flag from the backup superblock copies
when they are made, or is there an equal chance that the superblock
has NEEDS_RECOVERY and the backups do not?

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Index: e2fsprogs/e2fsck/super.c
> ===================================================================
> --- e2fsprogs.orig/e2fsck/super.c	2008-11-22 07:54:47.000000000 -0600
> +++ e2fsprogs/e2fsck/super.c	2008-11-22 08:59:45.953060973 -0600
> @@ -860,7 +860,8 @@ void check_super_block(e2fsck_t ctx)
>   * try to discourage it in the future.  In particular, for the newer
>   * ext4 files, especially EXT4_FEATURE_RO_COMPAT_DIR_NLINK and
>   * EXT3_FEATURE_INCOMPAT_EXTENTS.  So some of these may go away in the
> - * future.
> + * future.  EXT3_FEATURE_INCOMPAT_RECOVER may also get set when
> + * copying the primary superblock during online resize.
>   *
>   * The kernel will set EXT2_FEATURE_COMPAT_EXT_ATTR, but
>   * unfortunately, we shouldn't ignore it since if it's not set in the
> @@ -869,7 +870,8 @@ void check_super_block(e2fsck_t ctx)
>   */
>  #define FEATURE_RO_COMPAT_IGNORE	(EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
>  					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK)
> -#define FEATURE_INCOMPAT_IGNORE		(EXT3_FEATURE_INCOMPAT_EXTENTS)
> +#define FEATURE_INCOMPAT_IGNORE		(EXT3_FEATURE_INCOMPAT_EXTENTS| \
> +					 EXT3_FEATURE_INCOMPAT_RECOVER)
>  
>  int check_backup_super_block(e2fsck_t ctx)
>  {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

