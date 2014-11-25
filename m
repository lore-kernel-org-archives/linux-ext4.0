From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
 day stale
Date: Wed, 26 Nov 2014 10:48:51 +1100
Message-ID: <20141125234851.GB9561@dastard>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-4-git-send-email-tytso@mit.edu>
 <20141125015332.GE27262@dastard>
 <20141125044508.GG31339@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141125044508.GG31339@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 24, 2014 at 11:45:08PM -0500, Theodore Ts'o wrote:
> On Tue, Nov 25, 2014 at 12:53:32PM +1100, Dave Chinner wrote:
> > On Fri, Nov 21, 2014 at 02:59:23PM -0500, Theodore Ts'o wrote:
> > > Guarantee that the on-disk timestamps will be no more than 24 hours
> > > stale.
> > > 
> > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > 
> > If we put these inodes on the dirty inode list with at writeback
> > time of 24 hours, this is completely unnecessary.
> 
> What do you mean by "a writeback time of 24 hours"?  Do you mean
> creating a new field in the inode which specifies when the writeback
> should happen? 

No.

> I still worry about the dirty inode list getting
> somewhat long large in the strictatime && lazytime case, and the inode
> bloat nazi's coming after us for adding a new field to struct inode
> structure.

Use another pure inode time dirty list, and move the inode to the
existing dirty list when it gets marked I_DIRTY.

> Or do you mean trying to abuse the dirtied_when field in some way?

No abuse necessary at all. Just a different inode_dirtied_after()
check is requires if the inode is on the time dirty list in
move_expired_inodes().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
