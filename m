From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][10/28] e2fsprogs-uninit.patch
Date: Mon, 17 Mar 2008 08:33:45 -0400
Message-ID: <20080317123345.GA7555@mit.edu>
References: <20080202075943.GB23836@webber.adilger.int> <20080202083444.GK31694@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55488 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752395AbYCQMdv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 08:33:51 -0400
Content-Disposition: inline
In-Reply-To: <20080202083444.GK31694@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 02, 2008 at 01:34:44AM -0700, Andreas Dilger wrote:
> Index: e2fsprogs-1.40.5/e2fsck/super.c
> ===================================================================
> @@ -626,6 +631,50 @@ void check_super_block(e2fsck_t ctx)
	...
> +		if (!ext2fs_group_desc_csum_verify(sb, i, gd)) {
> +			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
> +				gd->bg_flags &=	~(EXT2_BG_BLOCK_UNINIT |
> +				                  EXT2_BG_INODE_UNINIT);
> +				gd->bg_itable_unused = 0;
> +			}
> +			ext2fs_unmark_valid(fs);
> +		}
> +
	...
> +
> +		gd->bg_checksum = ext2fs_group_desc_csum(fs->super, i, gd);

This last looks horribly wrong.  check_super_block() is merely
supposed to check to see if the superblock and block gorup descriptos
looks OK, and to mark the filesystem as invalid if anything looks
insane.  It should *not* modifying the block group descriptor, and it
certainly should not be doing so without first checking to see if the
filesystem has been opened read/only or calling
ext2fs_mark_super_dirty(fs) after making a change (that it shouldn't
do).

In fact there already is a check to see if the checksum has verified
correctly (see the first part of the patch which I quoted), so I think
the best thing to do is to remove that last bit.  I'm not sure why
it's there at all, in fact....

       	       	    	     	      	   - Ted
