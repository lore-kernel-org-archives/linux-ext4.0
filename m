From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC] e2fsprogs: Speed up ext2fs_new_block2
Date: Fri, 20 Feb 2015 19:24:34 -0800
Message-ID: <20150221032434.GA2762@birch.djwong.org>
References: <54E7C642.3020003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	richard.purdie@linuxfoundation.org, liezhi.yang@windriver.com
To: Darren Hart <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18120 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbbBUDYs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Feb 2015 22:24:48 -0500
Content-Disposition: inline
In-Reply-To: <54E7C642.3020003@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 20, 2015 at 03:41:54PM -0800, Darren Hart wrote:
> Ted and Darrick,
> 
> We're back with a Yocto Project use case. We use mkfs.ext4 to create our
> root filesystems. For one of our larger images including an X desktop
> and an SDK (toolchain, etc.), it took over 8 minutes to complete.
> Richard Purdie noticed most of this time was in ext2fs_new_block2. He
> provided this small hack to test an idea and it has reduced the runtime
> to 35 seconds. The images function as expected.
> 
> Can you have a look and see if there some value in this approach, or if
> perhaps it might lead to a more appropriate/correct solution?
> 
> Thanks!
> 
> Darren
> 
> (What follows is the test patch from Richard for the Yocto Project)
> 
> 
> The comment to this function says:
> 
> """
>   * Stupid algorithm --- we now just search forward starting from the
>   * goal.  Should put in a smarter one someday....
> """
> 
> This adds in a rather hacky algorthim which starts where we finished
> searching previously using a static variable rather than starting
> from scratch if a hint isn't provided.

Not a horrible idea, esp. for laying out files one after the other at mkfs time.

> This was after noticing that mkfs.ext4 -F X -d Y was spending *lots*
> of time in ext2fs_new_block2 called from ext2fs_bmap from
> ext2fs_file_write().

Yeah, it did.

> Numbers wise, this took a core-image-sato-sdk mkfs time from over
> 8 minutes to around 35 seconds.
> 
> Upstream-Status: Pending
> 
> RP 2015/02/20
> 
> Index: e2fsprogs-1.42.9/lib/ext2fs/alloc.c
> ===================================================================
> --- e2fsprogs-1.42.9.orig/lib/ext2fs/alloc.c
> +++ e2fsprogs-1.42.9/lib/ext2fs/alloc.c

1.42.9?  That's pretty old. :)

I've patches in -next sitting that make the allocators a bit less stupid.  One
makes it so that if there's no goal explicitly given, we'll try to start
allocating in the same block group that the inode lives in.  Some time ago Ted
also added a bitmap helper function that really sped up file allocations.

Also, could you have a look at patches 42-46 in:
http://thread.gmane.org/gmane.comp.file-systems.ext4/47584
since they directly touch pieces that your team seems to want?

For more fun, could you take a look at 47-52?  They provide a fallocate()
implementation so that you can preallocate the entire file before writing,
which (if you have big files) avoids having to rewrite the extent tree
with every new FS block.

> @@ -160,6 +160,8 @@ errcode_t ext2fs_new_inode(ext2_filsys f
>  	return 0;
>  }
> 
> +static blk64_t last_goal = 0;
> +
>  /*
>   * Stupid algorithm --- we now just search forward starting from the
>   * goal.  Should put in a smarter one someday....
> @@ -170,6 +172,9 @@ errcode_t ext2fs_new_block2(ext2_filsys
>  	blk64_t	i;
>  	int	c_ratio;
> 
> +        if (!goal)
> +            goal = last_goal;

Offhand this doesn't seem like a bad idea to me.

'last_allocated' might be a better name, and if it's not going to be used
outside the function, it could be a static var inside new_block2().

--D

> +
>  	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> 
>  	if (!map)
> @@ -194,6 +199,7 @@ errcode_t ext2fs_new_block2(ext2_filsys
> 
>  		if (!ext2fs_fast_test_block_bitmap2(map, i)) {
>  			*ret = i;
> +			last_goal = i;
>  			return 0;
>  		}
>  		i = (i + c_ratio) & ~(c_ratio - 1);
> 
> -- 
> Darren Hart
> Intel Open Source Technology Center
