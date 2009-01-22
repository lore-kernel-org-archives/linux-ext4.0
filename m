From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck faults with corrupted images
Date: Thu, 22 Jan 2009 16:12:25 -0500
Message-ID: <20090122211224.GJ14966@mit.edu>
References: <20090122085609.GA29546@alice> <20090122111201.GA32200@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pavel@suse.cz, linux-ext4@vger.kernel.org
To: Eric Sesterhenn <snakebyte@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51019 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbZAVVMa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jan 2009 16:12:30 -0500
Content-Disposition: inline
In-Reply-To: <20090122111201.GA32200@alice>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 22, 2009 at 12:12:01PM +0100, Eric Sesterhenn wrote:
> * Eric Sesterhenn (snakebyte@gmx.de) wrote:
> > As suggested by pavel i tested how e2fsck handles corrupted images,
> > I used the fuzzer bunny (http://code.google.com/p/bunny-the-fuzzer/)
> > At http://www.cccmz.de/~snakebyte/e2fsck_err.tar.bz2 you
> > can find a bunch of images crashing e2fsck or keeping it in an endless
> > loop. I tested with e2fsck 1.41.0 which was the one i had at hand.
> > 
> > The crashes are either in ext2fs_inode_alloc_stats2() or
> > ext2fs_read_inode_full(), looks like those are always the same
> > faults.

Thanks, they were all traced to the superblock parameter s_first_ino
being extremely large --- much larger than s_inodes_count.  I've
committed the following patches to address the problem at multiple
levels.

							- Ted
