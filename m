From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC 1/2] ext4 resize: Mark the added group with
	EXT4_BG_INODE_ZEROED flag
Date: Mon, 24 Nov 2008 16:25:48 -0700
Message-ID: <20081124232548.GG3186@webber.adilger.int>
References: <20081121102309.182113793@bull.net>
 <20081121102309.507553245@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49999 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYKXX0E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 18:26:04 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAONPp2k014721
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 15:26:02 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAV00B0122B9F00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 24 Nov 2008 15:25:51 -0800 (PST)
In-reply-to: <20081121102309.507553245@bull.net>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 21, 2008  11:23 +0100, Solofo.Ramangalahy@bull.net wrote:
> The inode table has been zeroed in setup_new_group_blocks().
> Mark it as such in ext4_group_add().
> 
> As a side note, online resize and inode zeroing are "dual".
> 
> In order to obtain a filesystem with faster formating times one can
> do:
> . either format a smaller fs and then resize it,
> . or format the fs with lazy_itable_init

As discussed on the concall, it probably makes more sense to have the
resize code work by marking the inode tables UNINIT (if GDT_CSUM feature
is enabled) and then start the "itable zeroing" thread, if it isn't
already running, to do the zeroing of the itable.

If GDT_CSUM isn't set then the below fix is the right solution.

> Index: linux-2.6.28-rc4-itable_init/fs/ext4/resize.c
> ===================================================================
> --- linux-2.6.28-rc4-itable_init.orig/fs/ext4/resize.c
> +++ linux-2.6.28-rc4-itable_init/fs/ext4/resize.c
> @@ -865,7 +865,7 @@ int ext4_group_add(struct super_block *s
>  	gdp->bg_free_blocks_count = cpu_to_le16(input->free_blocks_count);
>  	gdp->bg_free_inodes_count = cpu_to_le16(EXT4_INODES_PER_GROUP(sb));
>  	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
> -
> +	gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_ZEROED);
>  	/*
>  	 * We can allocate memory for mb_alloc based on the new group
>  	 * descriptor

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

