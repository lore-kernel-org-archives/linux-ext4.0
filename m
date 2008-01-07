From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Bug 9692] New: journal_data mount option causes filesystem
Date: Mon, 7 Jan 2008 16:14:07 -0700
Message-ID: <20080107231407.GX3351@webber.adilger.int>
References: <478180BD.3050204@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Jayson King <dev@jaysonking.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:51387 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYAGXOK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jan 2008 18:14:10 -0500
Content-Disposition: inline
In-Reply-To: <478180BD.3050204@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 06, 2008  19:30 -0600, Jayson King wrote:
> This looks to be an off-by-one bug with e2fsck in the function
> check_blocks(), and there isn't any actual filesystem corruption
> (e2fsck causes the corruption).

This is actually a problem for cases where blocksize != pagesize.
We have a similar patch in our e2fsprogs, and I thought we sent
an equivalent patch to Ted previously...

-                   (pb.last_block / blkpg * blkpg != pb.last_block ||
+                   ((pb.last_block+1) / blkpg * blkpg != (pb.last_block+1) ||


Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>

> >From 654f24814e7b80d3b16bec2a67c13c43cb20eb2f Mon Sep 17 00:00:00 2001
> From: Jayson R. King <dev@jaysonking.com>
> Date: Sun, 6 Jan 2008 18:14:18 -0600
> Subject: e2fsck: Fix off-by-one error in check_blocks()
> 
> e2fsck allows extra blocks to be allocated to an inode up to the next
> multiple of page size iff the block size is not equal to page size. An
> off-by-one error in checking for this causes e2fsck to wrongly detect
> a bad i_size for such inodes and results in incorrectly adjusting the
> i_size to include those blocks.
> 
> Signed-off-by: Jayson R. King <dev@jaysonking.com>
> ---
>  e2fsck/pass1.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 56218ae..7bf0686 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -1593,7 +1593,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  		if ((pb.last_block >= 0) &&
>  		    /* allow allocated blocks to end of PAGE_SIZE */
>  		    (size < (__u64)pb.last_block * fs->blocksize) &&
> -		    (pb.last_block / blkpg * blkpg != pb.last_block ||
> +		    ((pb.last_block+1) & (blkpg-1) != 0 ||
>  		     size < (__u64)(pb.last_block & ~(blkpg-1)) *fs->blocksize))
>  			bad_size = 3;
>  		else if (size > ext2_max_sizes[fs->super->s_log_block_size])
> -- 
> 1.5.3.3
> 
> 


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
