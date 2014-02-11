From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v5 19/22] ext4: Add XIP functionality
Date: Tue, 11 Feb 2014 16:12:11 -0700 (MST)
Message-ID: <alpine.OSX.2.00.1402111536290.55274@scrumpy>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com> <CF1FF3EB.24114%matthew.r.wilcox@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48333 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaBKXMG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Feb 2014 18:12:06 -0500
In-Reply-To: <CF1FF3EB.24114%matthew.r.wilcox@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 15 Jan 2014, Matthew Wilcox wrote:
> From: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> This is a port of the XIP functionality found in the current version of
> ext2.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
> [heavily tweaked]
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

...

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c767666..8b73d77 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -663,6 +663,18 @@ found:
>  			WARN_ON(1);
>  		}
>  
> +		/* this is probably wrong for ext4.  unlike ext2, ext4 supports
> +		 * uninitialised extents, so we should probably be hooking
> +		 * into the "make it initialised" code instead. */
> +		if (IS_XIP(inode)) {

With the very first version of this patch the above logic seemed to work
correctly, zeroing blocks as we allocated them.  With the current XIP
infrastructure based tightly on direct IO this ends up being wrong because in
some cases we can call ext4_map_blocks() twice for a given block.  

A quick userland test program that creates a new file, truncates it up to 4k
and then does a partial block write will end up giving you a file filled with
all zeros.  This is because we zero the data before the write, do the write,
and then zero again, overwriting the data.  The second call to
ext4_map_blocks() happens via ext4_ext_direct_IO =>
ext4_convert_unwritten_extents() => ext4_map_blocks().

We can know in ext4_map_blocks() that we are being called after a write has
already completed by looking at the flags.  One solution to get around this
double-zeroing would be to change the above test to:

+                 if (IS_XIP(inode) && !(flags & EXT4_GET_BLOCKS_CONVERT)) {

This fixes the tests I've been able to come up with, but I'm not certain it's
the correct fix for the long term.  It seems wasteful to zero the blocks we're
allocating, just to have the zeros overwritten immediately by a write.  Maybe
a cleaner way would be to try and zero the unwritten bits inside of
ext4_convert_unwritten_extents(), or somewhere similar?

It's worth noting that I don't think the direct I/O path has this kind of
logic because they don't allow partial block writes.  The regular I/O path
knows to zero unwritten space based on the BH_New flag, as set via the
set_buffer_new() call in ext4_da_map_blocks().  This is a pretty different I/O
path, though, so I'm not sure how much we can borrow for the XIP code.

Thoughts on the correct fix?

- Ross
