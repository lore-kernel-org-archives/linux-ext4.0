From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] lock block groups when initializing
Date: Sun, 20 Jul 2008 23:11:45 -0600
Message-ID: <20080721051145.GK3370@webber.adilger.int>
References: <4880F5D3.8080805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:40341 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747AbYGUFLr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 01:11:47 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6L5BlU3012399
	for <linux-ext4@vger.kernel.org>; Sun, 20 Jul 2008 22:11:47 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4C00F01BRE0L00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 20 Jul 2008 22:11:47 -0700 (PDT)
In-reply-to: <4880F5D3.8080805@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 18, 2008  14:58 -0500, Eric Sandeen wrote:
> I noticed when filling a 1T filesystem with 4 threads using the 
> fs_mark benchmark that I occasionally got checksum mismatch errors:
> 
> It appears that the problem is likely a race to init the bg's
> when the uninit_bg feature is enabled.
> 
> With the patch below, which adds sb_bgl_locking around initialization,
> I was able to complete several runs with no errors or warnings.

Thanks for finding this.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

You can add Acked-by: Andreas Dilger <adilger@sun.com>

> @@ -321,12 +321,15 @@ ext4_read_block_bitmap(struct super_bloc
>  	if (bh_uptodate_or_lock(bh))
>  		return bh;
>  
> +	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
>  	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
>  		ext4_init_block_bitmap(sb, bh, block_group, desc);
>  		set_buffer_uptodate(bh);
>  		unlock_buffer(bh);
> +		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
>  		return bh;
>  	}

Since this flag will only ever change from set to unset, and will in
many cases not be set, we should first check if it is set without the
spin_lock(), and then if set re-check under the lock.  This avoids putting
an extra lock in this path.  While it may seem that we are already locking
and slow because of the locked buffer_head, the sb_bgl_lock() is hashed
so many groups will share the same lock and we may cause contention on
other CPUs accessing other groups needlessly.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

