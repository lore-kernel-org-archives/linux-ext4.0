From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add largedir feature
Date: Mon, 20 Mar 2017 07:42:01 -0400
Message-ID: <20170320114201.icgvngqty52q6wf3@thunk.org>
References: <20170319133425.gxeg3mba3brvztjf@thunk.org>
 <2F91584E-6351-4523-9821-54AD6A7CD889@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56954 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754556AbdCTLmK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 20 Mar 2017 07:42:10 -0400
Content-Disposition: inline
In-Reply-To: <2F91584E-6351-4523-9821-54AD6A7CD889@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 19, 2017 at 07:54:40PM -0400, Andreas Dilger wrote:
> 
> No, the directory tree for the Lustre MDS is just a regular directory
> tree (under "ROOT/" so we can have other files outside the visible
> namespace) with regular filenames as with local ext4.  The one difference
> is that there are also 128-bit FIDs stored in the dirents to allow readdir
> to work efficiently, but the majority of the other Lustre attributes
> are stored in xattrs on the inode.

OK, so let's summarize.

1.  This is only going to be an issue for Lustre users that are
creating a truly insanely large directories, and who aren't willing to
use a multi-level directories (e.g., users/t/y/tytso) for whatever reason.

2.  Currently the proposal is to upstream largedir, and not
necessarily the other file system features that are Lustre MDS
specific.

3.  I can therefore assume that Artem is interested in getting
largedir upstream for use cases and users that go beyond Lustre ---
and these users will probably be using non-zero length inodes, in
which case my observations about the fact that the slow down caused by
the fact that you have to spread out the inodes to place them close to
the data blocks will be applicable.

4.  Alexey's concerns, which seem to be based around Lustre users for
which (1) are true, could potentially be addressed by further,
additional file system changes, which could either continue to be
Lustre MDS specific and not upstreamed, or could be upstreamed at some
future point --- but which are fairly orthogonal to this discussion.

Does that seem fair?

					- Ted

P.S.  I could imagine some changes that involve using 64-bit inode
numbers where the low log2(inode_size) bits are used for the location
of the inode in the block, and the rest of the inode number is used to
identify the block number where the inode can be found --- and
abandoning the use of an "inode table" completely.  The inode
allocation bitmap block could be used instead to tell us which blocks
in the block group contain inodes for e2fsck pass 1 scanning.  Things
get a bit more complicated in e2fsck if it turns out that bitmap block
is corrupt, but that's a subject for another day, and I suspct it's
something that would only make sense if the Lustre community is
willing to put in the investment to work on it.
