From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RESEND e2progs] get_backup_sb: Consider block size when searching for backups
Date: Tue, 29 May 2007 17:06:39 -0600
Message-ID: <20070529230639.GF5181@schatzie.adilger.int>
References: <20070529212644.B2DE27B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Daniel Drake <ddrake@brontes3d.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:50456 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbXE2XGm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 19:06:42 -0400
Content-Disposition: inline
In-Reply-To: <20070529212644.B2DE27B409F@zog.reactivated.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 29, 2007  22:26 +0100, Daniel Drake wrote:
> The partition in question has a block size of 4096, and mke2fs reports that
> backup superblocks were created on blocks 32768, 98304, 163840, ...
> 
> When running e2fsck, get_backup_sb starts by guessing a block size of 1024
> and backup superblock at block 8193. I'm not sure why, but it actually finds
> a superblock at this location, so returns a context with superblock 8193,
> blocksize 1024. 

This might be due to the superblock being in the journal at that location...
This would fit right in the 32MB = 8192 block * 4kB block journal default.

I wonder if e2fsck should start by guessing the default blocksize based on
the size of the device, as we might otherwise find old superblocks from
previous fdisk/mke2fs incarnations.

> The following patch solves the problem by discounting superblocks which do
> not meet the currently-sought block size.
> As a result, block 32768 (blocksize=4096) is now used to restore the backup,
> which agrees with the first location that mke2fs listed.

Looks reasonable.

> @@ -453,7 +453,8 @@ blk_t get_backup_sb(e2fsck_t ctx, ext2_f
>  		if (sb->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
>  			ext2fs_swap_super(sb);
>  #endif
> -		if (sb->s_magic == EXT2_SUPER_MAGIC) {
> +		if (sb->s_magic == EXT2_SUPER_MAGIC &&
> +		    EXT2_BLOCK_SIZE(sb) == blocksize) {
>  			ret_sb = superblock;
>  			if (ctx) {
>  				ctx->superblock = superblock;

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
