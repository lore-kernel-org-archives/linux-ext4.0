From: tytso@mit.edu
Subject: Re: inconsistent file placement
Date: Tue, 6 Jul 2010 14:55:48 -0400
Message-ID: <20100706185548.GA26677@thunk.org>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39953 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab0GFSzw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jul 2010 14:55:52 -0400
Content-Disposition: inline
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 05, 2010 at 06:49:34PM -0700, Daniel Taylor wrote:
> I realize that it is enerally not a good idea to tune
> an operating system, or subsystem, for benchmarking, but
> there's something that I don't understand about ext[234]
> that is badly affecting our product.  File placement on
> newly-created file systems is inconsistent.  I can't,
> yet, call it a bug, but I really need to understand what
> is happening, and I cannot find, in the source code, the
> source of the randomization (related to "goal"???).

In ext3, it really is random.  The randomness you're looking for can
be found in fs/ext3/ialloc.c:find_group_orlov(), when it calls
get_random_bytes().  This is responsible for "spreading" directories
so they are spread across the block groups, to try to prevent
fragmented files.  Yes, if all you care about is benchmarks which only
use 10% of the entire file system, and for which the benchmarks don't
adequately simulate file system aging, the algorithms in ext3 will
cause a lot of variability.

Yes, if you use FAT-style algorithms which try to use the first free
inode, and first free block which is available, for the purposes of
competitive benchmarking (especially if the benchmarks are crap), you
can probably win against the competition.  Unfortunately, long-term
your product will probably far more likely to suffer from file system
aging as the blocks at the beginning of the file system are badly
fragmented.  Please don't do that, though (or, if you must, please
have a switch so that users can switch it from "competitive
benchmarking mode" to "friendly to real life users" mode).

Ext4 uses very different algorithms, and it's not strictly speaking
random since it uses a cur-down md4 hash of the directory name to
decide where to place the directory inode (and the location of the
directory inode, affects both the files created in that inode as well
as the blocks allocated to those files, as in ext3).  So as long as
the directory hash seed in the superblock stays constant, and the
directory and file names created stay constant, the inode and block
layout will also be consistent.

All of this having been said, it may very well be possible to improve
on the anti-fragmentation algorithms while still trying to allocate
block groups closer to the beginning of the disk to take advantage of
the inner-diamater/outer-diameter placement effect.  There's probably
room for some research work here.  But please do be careful before
twiddling too much with the allocator algorithms, they are somewhat
subtle....

						- Ted
