From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [patch] 48bit extents in e2fsprogs
Date: Fri, 15 Sep 2006 10:57:43 -0600
Message-ID: <20060915165743.GH6441@schatzie.adilger.int>
References: <20060915120540.GA23824@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:31661 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1750900AbWIOQ6K
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Sep 2006 12:58:10 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060915120540.GA23824@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 15, 2006  14:05 +0200, Alexandre Ratchov wrote:
> here is a patch that fixes 48bit extents in e2fsprogs. Basically, it wraps
> acces to 48bit filds of extent indexes and leaves in macros, so 32bit fields
> are no more (mis)used, see EXT3_EE_START and EXT3_EI_LEAF macros definitions.

This looks mostly good...  Some minor comments.
- please wrap lines at 80 columns
- the check for ee_start_hi and ei_leaf_hi fields (PR_1_EXTENT_HI) needs to
  be fixed (I don't see it changed here) so that it considers that an error
  only if INCOMPAT_64BIT flag is set and the filesystem is > 2^32 blocks.
  That is in e2fsck_ext_block_verify()
- (FYI) In my definition of PR_1_EXTENT_HI I recently added the PR_PREEN_NOMSG
  flag because users were confused about the "High 16 bits of extent/index
  block set" message even though it is harmless for 32-bit filesystems.
- In my patch (due to Ted's upstream repository changes) I've renamed
  everything to be ext4_* and EXT4_*.  Ted renamed EXT3_EXTENTS_FL to be
  EXT4_EXTENTS_FL, and I'm guessing he'll do the same with the rest...

>  	if (ix) {
> -		/* FIXME: 48-bit support */
>  		if (ex->ee_block < ix->ei_block)

My bad...

> @@ -298,15 +294,16 @@ int block_iterate_extents(struct ext3_ex
>  			}
> -			ctx->errcode = ext2fs_read_ext_block(ctx->fs,
> -							     ix->ei_leaf,
> -							     block_buf);
> +			ctx->errcode = ext2fs_read_ext_block(
> +				ctx->fs, EXT3_EI_LEAF(ix), block_buf);

I think the original code is more consistent with the e2fsprogs coding style.

As always, many thanks for he good work.


Can you also please change your patch series NOT to add s_*_count_hi in
the wrong place in 16-blk-64bit, and then change it back in 64bit-fixsb?
That is very dangerous if the patch series is partially used and just
adds confusion when reviewing the patches.

Also, the same 16-blk-64bit patch uses EXT2_FEATURE_RO_COMPAT_64BIT, but
later this is changed in 20-blk-64bit-compat to be INCOMPAT_64BIT.  I
suspect Ted will want to call this EXT4_FEATURE_INCOMPAT_64BIT in the end
(maybe he can comment on what the preferred names are for all the new flags).

Can you please fix this in the original patches instead of adding a later
patch that fixes the previous patches?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

