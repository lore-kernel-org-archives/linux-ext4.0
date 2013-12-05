From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mke2fs: Fix block bitmaps initalization with -O
 ^resize_inode
Date: Wed, 4 Dec 2013 21:00:58 -0800
Message-ID: <20131205050058.GE10150@birch.djwong.org>
References: <52662BBA.70503@rs.jp.nec.com>
 <20131123013336.GD10269@birch.djwong.org>
 <20131126012706.GF10269@birch.djwong.org>
 <003101ceea7f$08d3fda0$1a7bf8e0$@rs.jp.nec.com>
 <20131127005505.GG10269@birch.djwong.org>
 <00d301ceec16$de11fec0$9a35fc40$@rs.jp.nec.com>
 <20131130200624.GA9541@birch.djwong.org>
 <20131204234435.GF19914@thunk.org>
 <20131205012210.GC10150@birch.djwong.org>
 <20131205020939.GB8404@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	"'ext4 development'" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44447 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab3LEFBH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Dec 2013 00:01:07 -0500
Content-Disposition: inline
In-Reply-To: <20131205020939.GB8404@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 04, 2013 at 09:09:40PM -0500, Theodore Ts'o wrote:
> On Wed, Dec 04, 2013 at 05:22:10PM -0800, Darrick J. Wong wrote:
> > Right now, e2fsck and resize2fs take care of (B) on their own.
> > 
> > One of my patches fixes everything else (debugfs, dumpe2fs, fuse2fs, tune2fs)
> > to take care of (B) by doing it in the library.  I can't think of a scenario
> > where it'd be useful to run around with something like this:
> > 
> > # mke2fs -t ext4 /dev/vda -O ^resize_inode,meta_bg
> > # dumpe2fs /dev/vda
> > <snip>
> > Group 1: (Blocks 32768-65535) [INODE_UNINIT, BLOCK_UNINIT]
> >   Checksum 0xa85c, unused inodes 8192
> >   Backup superblock at 32768, Group descriptor at 32769
> >                        ^^^^^                      ^^^^^
> >   Block bitmap at 3 (bg #0 + 3), Inode bitmap at 19 (bg #0 + 19)
> >   Inode table at 546-1057 (bg #0 + 546)
> >   32766 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
> >   Free blocks: 32768-65535
> >                ^^^^^ <------------------ HEY!
> >   Free inodes: 8193-16384
> >
> > <snip>
> > # debugfs /dev/vda -R 'testb 32768'
> > Block 32768 not in use
> 
> I'm not that concerned about dumpe2fs and debugfs, since that's just a
> display issue.  What's more important is that lib/ext2fs/alloc.c

I disagree that testb returning wrong results is a merely display issue.  I
wasn't expecting to ffb a block I know is free and have other blocks suddenly
"become" in use:

debugfs:  testb 32768
Block 32768 not in use
debugfs:  ffb 1 65500
Free blocks found: 65500 
debugfs:  testb 32768
Block 32768 marked in use
debugfs:  q
ext2fs_write_block_bitmap: Attempt to write to filesystem opened read-only 
ext2fs_close: Attempt to write to filesystem opened read-only 

I shouldn't have to make debugfs modify the fs just to have testb return
correct results.  I don't think this qualifies as "least surprise".

Anyway, I'll send the patch along and see what everyone thinks of it.

> correctly handles allocations --- see check_block_uninit() and
> check_inode_uninit() in lib/ext2fs/alloc.c.  We do take care of
> initializing the portion of the allocation bitmap.
>
> This is good, because it means that e2tools will do the right thing
> when it writes files to an ext4 file system that has BLOCK_UNINIT set
> in a block group.

I agree that doing the initialization late is better than not doing it at all,
so at least we're surprising and not broken. :)

--D
