From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] e2fsprogs - pass1c terminates early if hard links
Date: Wed, 11 Apr 2007 05:51:47 -0600
Message-ID: <20070411115147.GS5967@schatzie.adilger.int>
References: <Pine.LNX.4.61.0704101344050.29750@webb> <20070411034019.GA25231@thunk.org> <20070411042220.GP5967@schatzie.adilger.int> <20070411104230.GA19237@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Garlick <garlick@llnl.gov>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:36878 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXDKLvu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Apr 2007 07:51:50 -0400
Content-Disposition: inline
In-Reply-To: <20070411104230.GA19237@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 11, 2007  06:42 -0400, Theodore Tso wrote:
> We don't currently have a way to modify indirect blocks
> directly (although I may create that soon or patches would be
> greatfully accepted :-), and of course there is a similar issue with
> extents and extended attributes blocks.

Note that as part of the i_extra_isize e2fsck support we are adding
functions to manage EAs to libext2fs that could be used as the basis
for this.

> At the moment I'm assuming that e2fsprogs block allocation algorithms
> (which are not as sophisticated as what's in the kernel) aren't going
> to be changing.

I thought as much myself.

> If they change, you're right, they could break the test.
> At the minimum I should document where the numbers are coming
> from in the test.

At least the test would break and any change that caused it could be
seen immediately.

> I could imagine a debugfs extension where we could do things like:
> 
> set_var $shared_blk /dir4/quux block[0]
> set_inode_field /dir/foo block[0] $shared_blk
> set_inode_field /dir2/bar block[0] $shared_blk
> set_inode_field /dir3/baz block[0] $shared_blk
> 
> Of course the temptation then would be to start adding conditions,
> functions, maybe an entire tcl interpreter....   :-)

Yes, I thought of this too, and also the "let's build a full interpreted
language into debugfs" conclusion.  It wouldn't be fatal though - in
some cases it would be nice to have debugfs loop over inodes to fix some
unusual corruption.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
