From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: add make_hugefile feature
Date: Tue, 21 Jan 2014 18:41:41 -0500
Message-ID: <20140121234141.GI31769@thunk.org>
References: <1390285023-23133-1-git-send-email-tytso@mit.edu>
 <24F1EAE7-6E6D-4411-9092-D159E0BE3A9C@dilger.ca>
 <20140121192356.GQ9229@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50569 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaAUXlp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jan 2014 18:41:45 -0500
Content-Disposition: inline
In-Reply-To: <20140121192356.GQ9229@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 21, 2014 at 11:23:56AM -0800, Darrick J. Wong wrote:
> 
> I'd adapt fuse2fs to use a ext2fs_fallocate function, if one existed.  That
> said, it would have to be more general than this, handling the case where there
> might be blocks mapped.
> 
> Hey Ted, if I wrote an ext2fs_fallocate, would you adapt this for it?

Sure, if there was an ext2fs_fallocate() which is as CPU efficient as
what I currently have, and which produces an extent tree which is as
efficient, I'd certainly use it.  

% /usr/bin/time ./mke2fs -F -q  -T hugefile /tmp/foo.img 4T
0.09user 0.28system 0:00.37elapsed 99%CPU (0avgtext+0avgdata 2160maxresident)k
0inputs+0outputs (0major+592minor)pagefaults 0swaps

% debugfs -R "stat /database/storage" /tmp/foo.img | head -10
debugfs 1.42.9 (28-Dec-2013)
Inode: 13   Type: regular    Mode:  0600   Flags: 0x80000
Generation: 0    Version: 0x00000000
User:   120   Group:    50   Size: 4397641728000
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 8589145544
     ...

So I can currently do the equivalent of fallocating close to 4TB in
less than a half a second.  This includes searching for free blocks
from the allocation bitmap, and setting up the extent tree, and making
sure all of the block group checksums are correct.  (And oh yes, that
includes making the file system and setting up all of the block group
descriptors as well.)

Try doing this via the existing interfaces, and see what you get.
It's not pretty.  :-)

The one area where we still have some improvements to do after all of
my changes to libext2fs is that ext2fs_extent_node_split() needs to be
taught that if the current location of the extent handle is at the
very end of the file, then when instead of splitting the last leaf
block 50/50, we should split the node unevenly, by creating a new leaf
block that has only a single entry in it --- the last extent of the
file.  That we can use close to 100% of the extent block's space,
instead of currently where we averaging around 170 extents per 4k
block, instead of 340.

Cheers,

						- Ted
