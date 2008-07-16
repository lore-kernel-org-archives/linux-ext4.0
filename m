From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] properly lock group descriptors before	initializing
Date: Wed, 16 Jul 2008 03:03:42 -0600
Message-ID: <20080716090342.GQ6239@webber.adilger.int>
References: <487D8671.2080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58143 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002AbYGPJDp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 05:03:45 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6G93ijv004347
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 02:03:45 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4300401D57FQ00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 16 Jul 2008 02:03:44 -0700 (PDT)
In-reply-to: <487D8671.2080307@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 16, 2008  00:26 -0500, Eric Sandeen wrote:
> @@ -105,6 +105,7 @@ read_inode_bitmap(struct super_block *sb
>  	desc = ext4_get_group_desc(sb, block_group, NULL);
>  	if (!desc)
>  		goto error_out;
> +	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
>  	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
>  		bh = sb_getblk(sb, ext4_inode_bitmap(sb, desc));
>  		if (!buffer_uptodate(bh)) {

sb_getblk() calls __getblk(), which is might_sleep() so is a no-no.

> @@ -119,6 +120,7 @@ read_inode_bitmap(struct super_block *sb
>  	} else {
>  		bh = sb_bread(sb, ext4_inode_bitmap(sb, desc));
>  	}
> +	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));

Likewise "sb_bread" is doing disk access.  I guess you don't have
CONFIG_DEBUG_SPINLOCK_SLEEP enabled in your kernel.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

