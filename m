From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Fix counting routines in blknum.c to take/return __u32
	counts.
Date: Sun, 6 Sep 2009 12:37:04 -0400
Message-ID: <20090906163704.GK3055@mit.edu>
References: <4A9D9574.3010606@redhat.com> <20090902055953.GF4197@webber.adilger.int> <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com> <4A9EA09E.10509@redhat.com> <13135.1251925342@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42092 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbZIFQhI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Sep 2009 12:37:08 -0400
Content-Disposition: inline
In-Reply-To: <13135.1251925342@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 02, 2009 at 05:02:22PM -0400, Nick Dokos wrote:
> From e8c790ab8a0f06b4c89a5b6ddba2a36f033c742c Mon Sep 17 00:00:00 2001
> From: Nick Dokos <nicholas.dokos@hp.com>
> Date: Wed, 2 Sep 2009 16:52:09 -0400
> Subject: [PATCH] Fix counting routines in blknum.c to take/return __u32 counts.
> 
> Several routines in lib/ext2fs/blknum.c:
> 
>         ext2fs_bg_free_blocks_count()
>         ext2fs_bg_free_inodes_count()
>         ext2fs_bg_used_dirs_count()
>         ext2fs_bg_itable_unused()
> 
> and their _set() counterparts, operate as if they are dealing with
> blk64_t quantities, but they should be dealing with __u32 counts
> instead.
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>

Added to the e2fsprogs pu branch / 64-bit patch set.

BTW, note that this patch by itself caused the regression test suite
to explode spectactularly, since there was a number of printf-style
format statements that had to be changed so that dumpe2fs, debugfs
et. al, would work correctly after changing the above-mentioned
routines to return 32-bit values instead of 64-bit values.

I've fixed this before adding it to the e2fsprogs patch set.

Even though we do need to add more 64-bit tests, I do appreciate it if
people could test their patches using "make check" before sending
patches them to the ext4 list.

	    	   	  	 	    - Ted
