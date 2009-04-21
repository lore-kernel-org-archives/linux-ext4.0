From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [PATCH 2/2][64-BIT] ext2fs_group_first_block2(): 32-bit truncation.
Date: Mon, 20 Apr 2009 20:50:00 -0400
Message-ID: <20090421005000.GB24177@shell>
References: <30396.1240034713@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbZDUAuC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 20:50:02 -0400
Content-Disposition: inline
In-Reply-To: <30396.1240034713@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 18, 2009 at 02:05:13AM -0400, Nick Dokos wrote:
> ext2fs_group_first_block2() returns the product of the group number
> and the number of blocks per group (from the superblock). Unfortunately,
> both of these are 32-bit quantities, so the multiplication result is
> also 32 bits wide. It is then returned as a 64-bit quantity, but by then,
> it's too late.
> 
> Cast one of the operands to blk64_t, so the multiplication will be done
> in 64 bits.
> 
> e2fsck was complaining about a group that was marked BLOCK_UNINIT, but
> had blocks in use (it turned out that a different group had blocks in
> use, but the block numbers of the two different groups differed by
> 2^32, so this bug conflated them). With this change, this complaint
> goes away. In addition, dumpe2fs produces the right blocks for all the
> groups, whereas it was wrapping them at the 32-bit boundary previously.
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

Pulled and pushed.

-VAL

> ---
>  lib/ext2fs/blknum.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
> index b9666fb..fd56d53 100644
> --- a/lib/ext2fs/blknum.c
> +++ b/lib/ext2fs/blknum.c
> @@ -28,7 +28,7 @@ dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t blk)
>  blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group)
>  {
>  	return fs->super->s_first_data_block +
> -		(group * fs->super->s_blocks_per_group);
> +		((blk64_t)group * fs->super->s_blocks_per_group);
>  }
>  
>  /*
> -- 
> 1.6.0.6
> 
