From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Dump extent/sindices using debugfs
Date: Thu, 12 Jun 2008 09:46:46 -0400
Message-ID: <20080612134646.GC18229@mit.edu>
References: <1213179088.3298.12.camel@alpha.linsyssoft.com> <20080611104351.GA9008@skywalker> <20080612083204.GU3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43752 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754684AbYFLNqz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 09:46:55 -0400
Content-Disposition: inline
In-Reply-To: <20080612083204.GU3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2008 at 02:32:04AM -0600, Andreas Dilger wrote:
> > 
> > lib/ext2fs/tst_extents (I don't know why we don't install this by
> > default) have inode, root and ns/n command which help to iterate the
> > extent format inode

Some of the reasons why tst_extents was created to extend debugfs,
instead of simply adding these commands to debugfs are:

1) To demonstrate the technique for creating programs for doing
per-module testing various new bits of the libext2 library, without
having to replicate a lot of infrastructure already provided by
debugfs.  (Code reuse is good; lots of testing of *any* code before
you submit it, in either e2fsprogs or the ext4 kernel code is a very
good thing; one of the thing that disturbs me a little is when I trip
over bugs that indicate that obviously the code was obviously NOT
tested before submission, such as the on-line resizing code or patches
to the on-line resizing code, when online resizing was clearly and
obviously busted.)

2) The command names, "inode", "root", "next_sibling", etc. are
clearly inappropriate for debugfs. 

> The "tst_*" programs are purely for regression testing.  Having this
> functionality built into a proper tool like debugfs is needed.

Agreed.  That being siad, Girish's patch doesn't apply against the
latest e2fsprogs git repository.  It uses ext2fs_read_ext_block(), and
one of the reasons why I objected to Clusterfs's extent support in
e2fsprogs is that it exposed the low-level extent format to userspace
(and meant that the swapfs.c also needed extreme intimate knowledge of
the extent tree format), and that's a bad idea if we ever want to
change the extent format in the future.  So the extents abstraction in
the latest e2fsprogs git tree does not have ext2fs_read_ext_block().

So to properly add the desired features to debugfs would require
taking some of the code from tst_extents (really, lib/ext2fs/extents.c
in the #ifdef DEBUG section), and moving it into debugfs.

I doubt we would want to move all of the tst_extents functionality
into debugfs, though.  Probably just enough to dump the extent tree
and the set_bmap functionality --- and the latter should be done by
extending debugfs.c:do_bmap() so that it can take an optional 3rd
argument which utilizes ext2fs_bmap() to set a logical block mapping;
that way do_bmap() will work with normal and extent-based files, since
ext2fs_bmap/ext2fs_bmap2 have been wired to use Eric's
ext2fs_extent_set_bmap() function automatically for extents-based
files.

Regards,

						- Ted
