From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs - pass1c terminates early if hard links
Date: Wed, 11 Apr 2007 06:42:31 -0400
Message-ID: <20070411104230.GA19237@thunk.org>
References: <Pine.LNX.4.61.0704101344050.29750@webb> <20070411034019.GA25231@thunk.org> <20070411042220.GP5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Garlick <garlick@llnl.gov>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40374 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXDKKmf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2007 06:42:35 -0400
Content-Disposition: inline
In-Reply-To: <20070411042220.GP5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 10, 2007 at 10:22:20PM -0600, Andreas Dilger wrote:
> On Apr 10, 2007  23:40 -0400, Theodore Tso wrote:
> > Also note that providing a
> > script which generates the test filesystem is now preferred to
> > including an image.gz file; it avoids the need for binary patches, and
> > it makes it clearer how the test filesystem is constructed.
> 
> Agreed, though in some cases it is considerably easier to produce the
> corruption via binary editing than debugfs commands unless there are
> now facilities to copy blocks/bytes around within the filesystem?

Yes, there are still some facilities that could be added to make life
more convenient.  We don't currently have a way to modify indirect blocks
directly (although I may create that soon or patches would be
greatfully accepted :-), and of course there is a similar issue with
extents and extended attributes blocks.

A facility to set a specific range of bytes, or copy a range of bytes
from one block/offset to another (to simulate a disk controller
hiccup) is definitely not a bad idea.  Maybe something like this?

write_data_bytes <block>/<offset>  <hex string> 
write_data_ascii <block>/<offset>  <ascii string> 
copy_data_bytes <block/offset> <block/offset> <count>

> > +set_inode_field /dir/foo block[0] 30
> > +set_inode_field /dir2/bar block[0] 30
> > +set_inode_field /dir3/baz block[0] 30
> > +set_inode_field /dir/fee block[0] 34
> > +set_inode_field /dir2/fie block[0] 34
> > +set_inode_field /dir3/foe block[0] 34
> 
> Also, items such as these presuppose that the directory has specific
> blocks allocated to it, which need the test case to be constructed in
> multiple passes (to extract these numbers) and could break at some time 
> in the future.

At the moment I'm assuming that e2fsprogs block allocation algorithms
(which are not as sophisticated as what's in the kernel) aren't going
to be changing.  If they change, you're right, they could break the
test.  At the minimum I should document where the numbers are coming
from in the test.

I could imagine a debugfs extension where we could do things like:

set_var $shared_blk /dir4/quux block[0]
set_inode_field /dir/foo block[0] $shared_blk
set_inode_field /dir2/bar block[0] $shared_blk
set_inode_field /dir3/baz block[0] $shared_blk

Of course the temptation then would be to start adding conditions,
functions, maybe an entire tcl interpreter....   :-)

						- Ted
