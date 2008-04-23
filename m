From: Andreas Dilger <adilger@sun.com>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation	for
 FLEX_BG
Date: Wed, 23 Apr 2008 14:39:55 -0600
Message-ID: <20080423203955.GH2775@webber.adilger.int>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
 <1208868379-17580-2-git-send-email-tytso@mit.edu>
 <1208868379-17580-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>,
	Valerie Clement <valerie.clement@bull.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54487 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYDWUkI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 16:40:08 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3NKe6d8010765
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 13:40:06 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZS00601OXM3600@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 23 Apr 2008 13:40:06 -0700 (PDT)
In-reply-to: <1208868379-17580-3-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 22, 2008  08:46 -0400, Theodore Ts'o wrote:
> Change the way we allocate bitmaps and inode tables if the FLEX_BG
> feature is used at mke2fs time.  It places calculates a new offset for
> bitmaps and inode table base on the number of groups that the user
> wishes to pack together using the new "-G" option.  Creating a
> filesystem with 64 block groups in a flex group can be done by:
> 
> mke2fs -j -I 256 -O flex_bg -G 32 /dev/sdX

Presumably you mean "-G 64" based on your description of 64 groups/flex_bg?

> @@ -66,6 +137,22 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
> +		if (flexbg_size) {
> +			dgrp_t gr = ext2fs_group_of_blk(fs, new_blk);
> +			fs->group_desc[gr].bg_free_blocks_count--;
> +			fs->super->s_free_blocks_count--;
> +			fs->group_desc[gr].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
> +			ext2fs_group_desc_csum_set(fs, gr);
> +		}

It makes total sense to me that the BG_BLOCK_UNINIT flag would not be set
on a group that does not have the default bitmap layouts, so I agree with
this change.  I might suggest that we add a new flag BG_BLOCK_EMPTY or
similar (which is really part of the FLEXBG feature so it doesn't affect
the existing uninit_groups code) that indicates that the block bitmap
contains NO allocated blocks, so that the kernel can know immediately
when reconstructing the bitmap that there are no bitmaps or itable in
that group (i.e. the bitmap is all zero).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

