From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH,RFC] ext4: add lazytime mount option
Date: Thu, 13 Nov 2014 11:35:11 -0500
Message-ID: <20141113163511.GA15585@thunk.org>
References: <1415765227-9561-1-git-send-email-tytso@mit.edu>
 <20141113064150.GI28565@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141113064150.GI28565@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 13, 2014 at 05:41:50PM +1100, Dave Chinner wrote:
> 
> I think this needs to a VFS level inode timestamp update option.
> The games ext4 is playing with reference counts inside .drop_inode are
> pretty nasty and could be avoided if this is implemented at the VFs
> level..

I'm happy to implement this at the VFS level, assuming that there are
no objections from other file system developers.  I do need to note
that one potential downside of this feature is that if an inode stays
in the inode cache for potentially a long, long time, and the file is
a preallocated file which is updated using random DIO or AIO writes
(for example, enterprise database files on a long-running server), and
the system crashes, the mtime in memory could potentially out of synch
for days, weeks, months, etc.  I'm personally not bothered by this,
but I could imagine that some other folks might.

One other thing we could do at the VFS layer is to change the default
from relatime (which is not POSIX compliant) to enabling atime update
plus lazytime enabled (which is POSIX compliant).  Would there be
consensus in making such a change in the default?

> I think that the "lazy time update" status should really be tracked
> in the inode->i_state field. Something like lazytime updates do not
> call ->update_inode, nor do they mark the inode dirty, but they do
> update the inode->i_[acm]time fields and set a TIMEDIRTY state flag.

It looks like the only file systems that have an update_inode today is
btrfs and xfs, and it looks like this change should be fine for both
of them, so sure, that sounds workable.

						- Ted
