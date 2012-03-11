From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/5] libext2fs: Move a modulo operation out of a hot loop.
Date: Sun, 11 Mar 2012 03:50:59 -0600
Message-ID: <80227B8A-A826-4342-8B6B-2307C906F449@dilger.ca>
References: <20120310213321.GK6961@sli.dy.fi> <20120310213456.GL6961@sli.dy.fi>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:23612 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2CKJus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Mar 2012 05:50:48 -0400
In-Reply-To: <20120310213456.GL6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-10, at 2:34 PM, Sami Liedes wrote:
> From 8d712d4e49cdc8a0b82f27b5b62a7691fafcacbf Mon Sep 17 00:00:00 2001
> From: Sami Liedes <sami.liedes@iki.fi>
> Date: Sat, 10 Mar 2012 22:13:12 +0200
> Subject: [PATCH] libext2fs: Move a modulo operation out of a hot loop.
> 
> Filesystem shrinking in particular is a heavy user of this loop in
> ext2fs_new_inode(). This change makes resize2fs use 24% less CPU time
> for shrinking a 100G filesystem.
> 
> Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
> 
> diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
> index 948a0ec..eb4e0f5 100644
> --- a/lib/ext2fs/alloc.c
> +++ b/lib/ext2fs/alloc.c
> @@ -109,6 +109,7 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
> 	ext2_ino_t	dir_group = 0;
> 	ext2_ino_t	i;
> 	ext2_ino_t	start_inode;
> +	ext2_ino_t	modulo;

Good to see someone working on optimizing this code.  One comment on this patch -
"modulo" isn't a very good name for this variable.  Sure it is a modulus, but it
doesn't really say _what_ it is.  Better would be something like "inode_in_group".

> 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> 
> @@ -126,17 +127,21 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
> 	if (start_inode > fs->super->s_inodes_count)
> 		return EXT2_ET_INODE_ALLOC_FAIL;
> 	i = start_inode;
> +	modulo = (i - 1) % EXT2_INODES_PER_GROUP(fs->super);
> 
> 	do {
> -		if (((i - 1) % EXT2_INODES_PER_GROUP(fs->super)) == 0)
> +		if (modulo == 0)
> 			check_inode_uninit(fs, map, (i - 1) /
> 					   EXT2_INODES_PER_GROUP(fs->super));
> 
> 		if (!ext2fs_fast_test_inode_bitmap2(map, i))
> 			break;
> -		i++;
> -		if (i > fs->super->s_inodes_count)
> +		if (++modulo == EXT2_INODES_PER_GROUP(fs->super))
> +			modulo = 0;
> +		if (++i > fs->super->s_inodes_count) {
> 			i = EXT2_FIRST_INODE(fs->super);
> +			modulo = (i - 1) % EXT2_INODES_PER_GROUP(fs->super);
> +		}
> 	} while (i != start_inode);
> 
> 	if (ext2fs_test_inode_bitmap2(map, i))


Cheers, Andreas





