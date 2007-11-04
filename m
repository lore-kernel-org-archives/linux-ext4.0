From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/4][e2fsprogs] New bitmap and inode table allocation
	for FLEX_BG
Date: Sat, 3 Nov 2007 20:52:08 -0400
Message-ID: <20071104005208.GA6455@thunk.org>
References: <20070814043245.32206.34785.stgit@gara> <20070814043314.32206.28698.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49275 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbXKDNh2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Nov 2007 08:37:28 -0500
Content-Disposition: inline
In-Reply-To: <20070814043314.32206.28698.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 13, 2007 at 11:33:14PM -0500, Jose R. Santos wrote:
> +	if (EXT2_HAS_INCOMPAT_FEATURE (fs->super, 
> +				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) 
> +		ext2fs_allocate_flex_groups(fs);
> +	
> +	else {
> +		for (i = 0; i < fs->group_desc_count; i++) {
> +			retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
> +			if (retval)
> +				return retval;
> +		}

The code to handle flex groups needs to be moved into
ext2fs_allocate_group_table(), and not put in
ext2fs_allocate_tables(), since resize2fs calls
ext2fs_allocate_group_table(), and we want resize2fs to do the right
thing for filesystems that have both the FLEX_BG and META_BG flags
set.  Speaking of which, we need to fix the kernel on-line resizing
code to allocate new blocks for filesystem metadata blocks using the
new placement algorithm for FLEX_BG && META_BG filesystems.

I'll fix this up for the 'pu' branch of e2fsprogs, as well as making
ext2fs_allocate_flex_groups static, but I'm not going to graduate this
to the 'next' branch just yet, since it needs a bit more testing,
specifically with resize2fs.

						- Ted
