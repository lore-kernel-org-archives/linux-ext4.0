From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 19:58:51 +0200
Message-ID: <20061025175851.GA9940@atrey.karlin.mff.cuni.cz>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org> <20061024135928.GB11034@melbourne.sgi.com> <20061024194416.GB16087@thunk.org> <20061024230020.GZ3509@schatzie.adilger.int> <20061025145450.GF21082@atrey.karlin.mff.cuni.cz> <20061025170224.GB19513@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@clusterfs.com, Theodore Tso <tytso@mit.edu>,
	David Chinner <dgc@sgi.com>, Alex Tomas <alex@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Content-Disposition: inline
In-Reply-To: <20061025170224.GB19513@havoc.gtf.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, Oct 25, 2006 at 04:54:50PM +0200, Jan Kara wrote:
> >   Yes, this sounds feasible. We could split the defrag ioctl into two
> > pieces (addition of given extent to a file and swapping of extents), which
> > can have generic interface... 
> 
> An ioctl is UGLY.
  Agreed.

> This was discussed years ago.  Google for 'Alexander Viro' and
> 'ext2meta'.  That's a clean, flexible, extensible way to access metadata
> online.  No need for ioctl binary translation across 32bit<->64bit, or
> any other ioctl issue.
  I've briefly looked at this and this kind of interface has some
appeal. On the other hand it's not obvious to me, how to implement in
this interface *atomic* operation "copy data from file F to given set of
blocks and rewrite pointers to original blocks with pointers to new
blocks". Something like this is needed for what we want to do...
Also if we'd like to implement operation like "add this block to file F
at position P" we have to make sure that all the necessary updates
(bitmap updates, inode updates, indirect block updates) go into one
transaction. Which basically mean that either ext3meta has to have a way
how to do this in a single operation, or we have to give userspace a way
to start/stop transaction and that starts to be really a mess because of
various deadlocks and so on.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
