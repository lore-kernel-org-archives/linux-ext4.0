From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/4][e2fsprogs] Relax group descriptor checking.
Date: Sat, 3 Nov 2007 19:36:09 -0400
Message-ID: <20071103233609.GA30710@thunk.org>
References: <20070814043245.32206.34785.stgit@gara> <20070814043303.32206.10239.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49271 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbXKDNh2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Nov 2007 08:37:28 -0500
Content-Disposition: inline
In-Reply-To: <20070814043303.32206.10239.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 13, 2007 at 11:33:03PM -0500, Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Relax group descriptor checking.

This patch should really be before patch #2 in the series (add the
ability to handle the new feature before adding the ability to add in
mke2fs).  (Actually, I would have split up #2 into one patch which
added the libe2p handling for the feature, then added the change to
e2fsck, and then added the mke2fs changes, but that's just me
quibbling.)

> @@ -578,8 +580,16 @@ void check_super_block(e2fsck_t ctx)
>  	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
>  		pctx.group = i;
>  
> -		first_block = ext2fs_group_first_block(fs, i);
> -		last_block = ext2fs_group_last_block(fs, i);
> +		if (EXT2_HAS_INCOMPAT_FEATURE (fs->super,
> +					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> +			meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
> +			start_group = (i / meta_bg_size) * meta_bg_size;
> +			first_block = ext2fs_group_first_block(fs, start_group);
> +			last_block = ext2fs_group_first_block(fs, start_group + meta_bg_size);

This patch requires that the metadata be in located in the metablock
group descriptor, instead of anywhere in the filesystem, which is what
we ultimately ended up checking into the kernel.  Being more flexible
is good (even if that's not the layout we use by default).  I'll fix
this up using git rebase --interactive and republish the patch in the
next branch.

						- Ted
