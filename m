From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/54] e2fsck: Verify inode bitmap checksum
Date: Sat, 10 Mar 2012 00:46:57 -0500
Message-ID: <20120310054657.GA1048@thunk.org>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
 <20120306235844.11945.9126.stgit@elm3b70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40827 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab2CJFrG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Mar 2012 00:47:06 -0500
Content-Disposition: inline
In-Reply-To: <20120306235844.11945.9126.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 06, 2012 at 03:58:44PM -0800, Darrick J. Wong wrote:
> Rewrite the block bitmap when the checksum doesn't match.  This is ok since
> e2fsck will have already computed the correct inode bitmap.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

> @@ -74,6 +77,67 @@ void e2fsck_pass5(e2fsck_t ctx)
>  	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
>  }
>  
> +static void check_inode_bitmap_checksum(e2fsck_t ctx)
> +{
> +	struct problem_context	pctx;
> +	struct ext4_group_desc	*gdp;
> +	char		*buf;
> +	dgrp_t		i;
> +	int		nbytes;
> +	ext2_ino_t	ino_itr;
> +	errcode_t	retval;
> +	int		csum_flag = 0;
> +
> +	/* If bitmap is dirty from being fixed, checksum will be corrected */
> +	if (ext2fs_test_ib_dirty(ctx->fs))
> +		return;
> +
> +	nbytes = (size_t)(EXT2_INODES_PER_GROUP(ctx->fs->super) / 8);
> +	retval = ext2fs_get_memalign(ctx->fs->blocksize, ctx->fs->blocksize,
> +				     &buf);
> +	if (retval) {
> +		com_err(ctx->program_name, 0,
> +		    _("check_inode_bitmap_checksum: Memory allocation error"));
> +		fatal_error(ctx, 0);
> +	}
> +
> +	if (EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
> +				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
> +		csum_flag = 1;

This patch just looks wrong.  RO_COMPAT_GDT_CSUM is the old feature,
and doesn't imply that there will be a checksum in the inode bitmap
block.  Shouldn't this be RO_COMPAT_METADATA_CSUM?

By the way, the bugs which I'm finding in this patch series are
seriously degrading my faith about how well both they and the kernel
side patches have been tested.....

At this point I will probably work on other kernel patches, and return
to this later.  

						- Ted

P.S.  Note that if I apply the full patch series, I am still finding
45 (out of 118) test failures from the regression test suite.  While I
was bisecting to find errors, I found this one by quick inspection.
