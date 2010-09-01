From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: Broken e2fsck i_blocks repair
Date: Wed, 1 Sep 2010 16:49:59 -0700
Message-ID: <3B2F6F16-EAC2-435B-89C9-BDB9931541DF@dilger.ca>
References: <AANLkTinT3O20u-iE4Mu2ikSPa4bdhVsM+a82p6Hoeu8K@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:38586 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab0IAXtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Sep 2010 19:49:51 -0400
In-Reply-To: <AANLkTinT3O20u-iE4Mu2ikSPa4bdhVsM+a82p6Hoeu8K@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-09-01, at 16:01, Justin Maggard wrote:
> I've mentioned this before on here, but I never verified whether or
> not it was actually broken.  I have done so today.  I manually
> modified the block count of a 3TB file using debugfs, then ran e2fsck
> on it.  e2fsck claimed to repair it, but would throw an error on every
> subsequent e2fsck run for the same issue.  The reason is
> inode->osd2.linux2.l_i_blocks_hi is always set to 0 if e2fsck is told
> to fix it.  This is an issue in both stable 1.41.12, and in master.
> This patch fixes it for me, but is there anything else that needs to
> get checked here?

It probably makes sense to audit all uses of "i_blocks" to see if they behave similarly badly w.r.t. l_i_blocks_hi.  A casual glance indicates that there are a number of places that are similarly broken.

I see there is a helper function e2fsck/blknum.c:ext2fs_inode_i_blocks() that should be used for most i_blocks accesses (excluding those places in e2fsck that check for l_i_blocks_hi being non-zero without the appropriate feature flag being set).  It might make sense to rename this function ext2fs_inode_i_blocks_get() and add similar ext2fs_inode_i_blocks_set() routine to set it correctly.

> diff -urp e2fsprogs-1.41.12/e2fsck/pass1.c e2fsprogs-1.41.12-jm/e2fsck/pass1.c
> --- e2fsprogs-1.41.12/e2fsck/pass1.c	2010-05-14 14:51:21.000000000 -0700
> +++ e2fsprogs-1.41.12-jm/e2fsck/pass1.c	2010-09-01 15:54:42.000000000 -0700
> @@ -2044,7 +2044,7 @@ static void check_blocks(e2fsck_t ctx, s
> 		pctx->num = pb.num_blocks;
> 		if (fix_problem(ctx, PR_1_BAD_I_BLOCKS, pctx)) {
> 			inode->i_blocks = pb.num_blocks;
> -			inode->osd2.linux2.l_i_blocks_hi = 0;
> +			inode->osd2.linux2.l_i_blocks_hi = (pb.num_blocks >> 32);
> 			dirty_inode++;
> 		}
> 		pctx->num = 0;
> 
> -Justin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





