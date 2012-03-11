From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] e2fsck: Do not forget to discard last block group
Date: Sun, 11 Mar 2012 15:18:36 -0400
Message-ID: <20120311191836.GD1048@thunk.org>
References: <1330933776-2696-1-git-send-email-lczerner@redhat.com>
 <1330933776-2696-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49788 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2CKTSk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Mar 2012 15:18:40 -0400
Content-Disposition: inline
In-Reply-To: <1330933776-2696-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 08:49:34AM +0100, Lukas Czerner wrote:
> Previously when running e2fsck with '-E discard' argument the end of
> the last group has not been discarded. This patch fixes it so we
> always discard the end of the last group if needed.
> 
> This commit also removes unneeded argument from the
> e2fsck_discard_blocks(). Simultaneously the commit causes the block
> groups with BLOCK_UNINIT flag not to be discarded, which makes
> sense because we do not need to reclaim the space since so far
> there has not been written anything.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I split this into 3 patches, just to make it easier to reivew, and to
demonstrate the patch granularity I prefer.  The code paths in
check_block_bitmaps() and check_inode_bitmaps() *are* somewhat hard to
understand, partially because they are performance-critical.  So it's
especially important to separate out clean up patches from things that
actually change things.

>  		if ((blocks == fs->super->s_clusters_per_group) ||
>  		    (EXT2FS_B2C(fs, i) ==
>  		     EXT2FS_B2C(fs, ext2fs_blocks_count(fs->super)-1))) {
> +			/*
> +			 * If the last block of this group is free, then we can
> +			 * discard it as well.
> +			 */
> +			if (i >= first_free)
> +				e2fsck_discard_blocks(ctx, first_free,
> +						      (i - first_free) + 1);

This is buggy, because you're assuming the last block in the group is
free.  It might not be so, and if so, we would end up discarding valid
data.  The conditional needs to read:

			if (!bitmap && i >= first_free)
> +				e2fsck_discard_blocks(ctx, first_free,
> +						      (i - first_free) + 1);

In the case where bitmap is set, then any discards (if necessary) will
have been done already.

> +			first_free = ext2fs_blocks_count(fs->super);

I don't believe this is necessary, since we're not going to refer to
first_free again, are we?

			   	       	 - Ted
