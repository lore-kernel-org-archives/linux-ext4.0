From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 6/11][take 2] handling of 64-bit block counts in e2fsprofs
Date: Thu, 21 Jun 2007 14:29:08 -0600
Message-ID: <20070621202908.GZ5181@schatzie.adilger.int>
References: <467A987F.3050802@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:39292 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXFUU3L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 16:29:11 -0400
Content-Disposition: inline
In-Reply-To: <467A987F.3050802@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 21, 2007  17:25 +0200, Valerie Clement wrote:
> @@ -26,8 +26,11 @@ void ext2fs_swap_super(struct ext2_super
>  	sb->s_inodes_count = ext2fs_swab32(sb->s_inodes_count);
>  	sb->s_blocks_count = ext2fs_swab32(sb->s_blocks_count);
> +	sb->s_blocks_count_hi = ext2fs_swab32(sb->s_blocks_count_hi);
>  	sb->s_r_blocks_count = ext2fs_swab32(sb->s_r_blocks_count);
> +	sb->s_r_blocks_count_hi = ext2fs_swab32(sb->s_r_blocks_count_hi);
>  	sb->s_free_blocks_count = ext2fs_swab32(sb->s_free_blocks_count);
> +	sb->s_free_blocks_hi = ext2fs_swab32(sb->s_free_blocks_hi);
>  	sb->s_free_inodes_count = ext2fs_swab32(sb->s_free_inodes_count);
>  	sb->s_first_data_block = ext2fs_swab32(sb->s_first_data_block);
>  	sb->s_log_block_size = ext2fs_swab32(sb->s_log_block_size);

I prefer to keep the swabbing code in the same order as the field
declarations in the struct.  That makes it easier to verify everything
is handled.

> @@ -1492,14 +1495,15 @@ static void PRS(int argc, char *argv[])
>  	 * Calculate number of blocks to reserve
>  	 */
> -	fs_param.s_r_blocks_count = e2p_percent(reserved_ratio, 
> -						fs_param.s_blocks_count);
> +	EXT2_R_BLOCKS_COUNT_SET(
> +		&fs_param, e2p_percent(
> +			reserved_ratio, EXT2_BLOCKS_COUNT(&fs_param)));

This may as well just be on 2 lines.

> --- e2fsprogs-1.39-tyt3-v7.orig/resize/resize2fs.c	2007-06-21 13:12:03.000000000 +0200
> +++ e2fsprogs-1.39-tyt3-v7/resize/resize2fs.c	2007-06-21 13:13:05.000000000 +0200
> @@ -34,6 +34,7 @@
>   */
>  
>  #include "resize2fs.h"
> +#include "e2p/e2p.h"
>  #include <time.h>
>  
>  #ifdef __linux__			/* Kludge for debugging */

This should go in "resize2fs.h", like all of the other e2fsprogs-specific
headers, and probably should be in a separate patch so Ted can incorporate
it immediately.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
