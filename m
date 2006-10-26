From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Thu, 26 Oct 2006 16:36:48 +1000
Message-ID: <20061026063648.GE8394166@melbourne.sgi.com>
References: <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com> <20061025044844.GB32486@havoc.gtf.org> <20061025053823.GX8394166@melbourne.sgi.com> <20061025060142.GD32486@havoc.gtf.org> <20061025081137.GB8394166@melbourne.sgi.com> <20061025170052.GA19513@havoc.gtf.org> <20061026014020.GC8394166@melbourne.sgi.com> <20061026033316.GC27858@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
	Barry Naujok <bnaujok@melbourne.sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>,
	"'Alex Tomas'" <alex@clusterfs.com>, "'Jan Kara'" <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:52387 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1423443AbWJZGh4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Oct 2006 02:37:56 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061026033316.GC27858@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 11:33:16PM -0400, Theodore Tso wrote:
> On Thu, Oct 26, 2006 at 11:40:20AM +1000, David Chinner wrote:
> > We don't need to expose anything filesystem specific to userspace to
> > implement this.  Online data movement (i.e. the defrag mechanism)
> > becomes something like:
> > 
> > 	do {
> > 		get_free_list(dst_fd, location, len, list)
> > 		/* select extent to use */
> > 		alloc_from_list(dst_fd, list[X], off, len)
> > 	} while (ENOALLOC)
> > 	move_data(src_fd, dst_fd, off, len);
> > 
> > And this would work on any filesystem type that implemented these
> > interfaces. Hence tools like a startup file optimiser would
> > only need to be written once, rather than needing a different
> > tool for every different filesystem type.....
> 
> Yeah, but that's simply not enough. 

Not enough for what?

> A good defragger needs to know

Oh, we're back to defrag again. :/

> about a filesystem's allocation policies, and move files so they are
> optimally located, given the filesystem layout.  For example, in
> ext2/3/4 we will want to move blocks so they in the same block group
> as the inode.  That's filesystem specific information; other
> filesystems will require different policies.

Of which a good chunk of policies will be common. the above policy
has been around for many, many years and is implemented in many, many
filesystems (even XFS).

> > 		get_free_list(dst_fd, location, len, list)

location == allocation policy. e.g: give me a list of free blocks:

	- anywhere (default filesystem policy applies)
	- near block number X
	- at block X
	- in block/allocation group Y
	- of the largest contiguous regions in (one of the above)
	- at least N blocks in length
	- near inode src_fd
	- in storage tier 3
	
then you select one of the regions that was returned at attempt
to allocate that.

You can put whatever filesystems specific stuff you need around this
to arrive at the decision of where to put the file, but you've got
to allocate the new blocks, move the data to them, and swap them
over. Every defragger needs to do this, regardless of the filesystem
type. So why not provide a framework for it, especially as the
framework is useful for far more than just as the data movement part
of a defrag application.

> > Remember, I'm not just talking about defrag - I'm talking about
> > an interface that is actually useful to apps that might care
> > about how data is laid out on disk but the applications writers
> > don't know anyhting about how filesystem X or Y or Z is
> > implemented. Putting the burden of learning about fileystem
> > internals on application developers is not the correct solution.
> 
> Unfortunately, if you want to do a good job, a defragger *has* to know
> about some very low-level filesystem specific information, if it wants
> to do a good job.

Back to defrag. Again. Bigger picture, guys, bigger picture.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
