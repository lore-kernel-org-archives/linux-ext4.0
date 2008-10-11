From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][5/15] e2fsprogs-uninit-fixes.patch
Date: Sat, 11 Oct 2008 09:43:03 -0400
Message-ID: <20081011134302.GC12662@mit.edu>
References: <1223289070.4007.85.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Kalpak Shah <Kalpak.Shah@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50278 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752942AbYJKNnG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 09:43:06 -0400
Content-Disposition: inline
In-Reply-To: <1223289070.4007.85.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 04:01:10PM +0530, Kalpak Shah wrote:
> Bug fixes for uninit_bg feature:
> - display correct inode number during BG_INO_UNINIT and INOREF_IN_USED
> errors
> - restart e2fsck only once in case of above errors
> - initialize bitmaps properly considering whether block group is uninit
> or not (needed for e2freefrag)
> 
> Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

> Bug fixes for uninit_bg feature:
> - display correct inode number during BG_INO_UNINIT and INOREF_IN_USED errors
> - restart e2fsck only once in case of above errors
> - initialize bitmaps properly considering uninit or not (needed for e2freefrag)
> 

Note: While I really do very much appreciate your diffs against the
luster e2fsprogs tree, in the future, it would be *really* helpful if
you could separate out patches so that each patch does only one thing.
It makes it much easier to audit patches, and then if I end up taking
some parts of a patch, but not all of it, it becomes easier on your
end to match up what I've taken from what I haven't taken.  There are
some hunks of this patch I which I will probably never take, such as
the debugfs/set_fields.c patch, which as far as I can tell serves no
purpose, and the addition of ext2fs_super_and_bgd_loc2() in
lib/ext2fs/closefs.c (which as near as I can tell was taken from an
earlier version of jose's 64-bit patches):

> + * XXX: Remove this when we upgrade our e2fsprogs patches. Also blk64_t has been
> + * changed to blk_t here since this version does not have 64-bit support.
> + */
> +errcode_t ext2fs_super_and_bgd_loc2(ext2_filsys fs,


If this had been separated into a second patch, it becomes easier to
drop that one patch hunk from the patch.

Anyway, just a suggestion....

I will be trying to separate out a few of the bug fixes for the maint
branch for an e2fsprogs 1.41.3 release, but most of this is going to
be reserved for later in the master branch, after quite a bit of
refinement.

						- Ted
