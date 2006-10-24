From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] Ext3 online defrag
Date: Tue, 24 Oct 2006 15:44:16 -0400
Message-ID: <20061024194416.GB16087@thunk.org>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org> <20061024135928.GB11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061024135928.GB11034@melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 24, 2006 at 11:59:28PM +1000, David Chinner wrote:
> That's the wrong way to look at it. if you want the userspace
> process to specify a location, then you should preallocate it first
> before doing anything else. There is no need to clutter a simple
> data mover interface with all sorts of unnecessary error handling.

This is doable, but it adds a huge amount of complexity before we
could implement on-line defragmentation.

First of all, we would need a way of allowing userpsace to specify
which blocks should be used in the preallocation.

Secondly, we would need a way of marking blocks as "preallocated but
not pre-zeroed"; otherwise we would have to zero out all of the blocks
in order to assure security (don't want userspace programs seeing the
previous contents of the data blocks), only to do the copy and the
extents vector swap.

That's a huge amount of work, and while the above two features can be
useful for other things, it's not clear it's worth it to require this
as the only way to implement on-line defragging.  You're right that
it's a way of making things be more generic, but it means that each
filesystem needs to have a huge amount of additional complexity and
potential filesystem format changes before they could take advantage
of this general framework.  

(For example, you'd never be able to do this with the FAT filesystem,
or the ext2 or ext3 filesystems; it would work for ext4 only *after*
we implement the above mentioned new features and the associated
filesystem format changes.)

Regards,

					- Ted
