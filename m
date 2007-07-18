From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH] Endianness bugs in e2fsck
Date: Wed, 18 Jul 2007 12:34:12 +0530
Message-ID: <1184742252.4009.7.camel@garfield.linsyssoft.com>
References: <1182331988.9772.7.camel@garfield> <469D3271.8050908@redhat.com>
	 <469D6F89.9090500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:36019 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbXGRHDI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jul 2007 03:03:08 -0400
In-Reply-To: <469D6F89.9090500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-17 at 20:40 -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> ---------
> 
> set t->i_file_acl before we test it in 
> ext2fs_inode_data_blocks
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Index: e2fsprogs-1.40.2/lib/ext2fs/swapfs.c
> ===================================================================
> --- e2fsprogs-1.40.2.orig/lib/ext2fs/swapfs.c
> +++ e2fsprogs-1.40.2/lib/ext2fs/swapfs.c
> @@ -150,6 +150,7 @@ void ext2fs_swap_inode_full(ext2_filsys 
>  	t->i_dtime = ext2fs_swab32(f->i_dtime);
>  	t->i_gid = ext2fs_swab16(f->i_gid);
>  	t->i_links_count = ext2fs_swab16(f->i_links_count);
> +	t->i_file_acl = ext2fs_swab32(f->i_file_acl);
>  	if (hostorder)
>  		has_data_blocks = ext2fs_inode_data_blocks(fs, 
>  					   (struct ext2_inode *) f);
> @@ -158,7 +159,6 @@ void ext2fs_swap_inode_full(ext2_filsys 
>  		has_data_blocks = ext2fs_inode_data_blocks(fs, 
>  					   (struct ext2_inode *) t);
>  	t->i_flags = ext2fs_swab32(f->i_flags);
> -	t->i_file_acl = ext2fs_swab32(f->i_file_acl);
>  	t->i_dir_acl = ext2fs_swab32(f->i_dir_acl);
>  	if (!islnk || has_data_blocks ) {
> 
> 
>  		for (i = 0; i < EXT2_N_BLOCKS; i++)

This means that on big-endian machines, t->i_file_acl was uninitialized
when it was being accessed here. This certainly seems to be the correct
fix for this.

Thanks,
Kalpak.
