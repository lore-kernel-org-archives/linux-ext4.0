From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Thu, 26 Oct 2006 11:40:20 +1000
Message-ID: <20061026014020.GC8394166@melbourne.sgi.com>
References: <20061025011853.GQ8394166@melbourne.sgi.com> <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com> <20061025044844.GB32486@havoc.gtf.org> <20061025053823.GX8394166@melbourne.sgi.com> <20061025060142.GD32486@havoc.gtf.org> <20061025081137.GB8394166@melbourne.sgi.com> <20061025170052.GA19513@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>,
	Barry Naujok <bnaujok@melbourne.sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>,
	"'Alex Tomas'" <alex@clusterfs.com>,
	"'Theodore Tso'" <tytso@mit.edu>, "'Jan Kara'" <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:33683 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1422640AbWJZBlj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Oct 2006 21:41:39 -0400
To: Jeff Garzik <jeff@garzik.org>
Content-Disposition: inline
In-Reply-To: <20061025170052.GA19513@havoc.gtf.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 01:00:52PM -0400, Jeff Garzik wrote:
> On Wed, Oct 25, 2006 at 06:11:37PM +1000, David Chinner wrote:
> > On Wed, Oct 25, 2006 at 02:01:42AM -0400, Jeff Garzik wrote:
> > > On Wed, Oct 25, 2006 at 03:38:23PM +1000, David Chinner wrote:
> > > > On Wed, Oct 25, 2006 at 12:48:44AM -0400, Jeff Garzik wrote:
> > > > So why are you arguing that an interface is no good because it
> > > > is fundamentally racy? ;)
> > > 
> > > My point was that it is silly to introduce obviously racy code into the
> > > kernel, when -- inside the kernel -- it could be handled race-free.
> > 
> > So how do you then get the generic interface to allocate blocks
> > specified by userspace race free?
> 
> As has been repeatedly stated, there is no "generic".  There MUST be
> filesystem-specific knowledge during these operations.

What information? All we need to know is where the free disk space
is, and have a method to attempt to allocate from it. That's _easy_
to abstract into a common interface via the VFS....

> > > Further, in the case being discussed in this thread, ext2meta has
> > > already been proven a workable solution.
> > 
> > Sure, but that's not a generic solution to a problem common to
> > all filesystems....
> 
> You clearly don't know what I'm talking about.  ext2meta is an example
> of a filesystem-specific metadata access method, applicable to tasks
> such as online optimization.

I know exactly what ext2meta is. I said it's not a generic solution
and you say its a filesystem specific solution.  I think we're
agreeing here. ;)

We don't need to expose anything filesystem specific to userspace to
implement this.  Online data movement (i.e. the defrag mechanism)
becomes something like:

	do {
		get_free_list(dst_fd, location, len, list)
		/* select extent to use */
		alloc_from_list(dst_fd, list[X], off, len)
	} while (ENOALLOC)
	move_data(src_fd, dst_fd, off, len);

And this would work on any filesystem type that implemented these
interfaces. Hence tools like a startup file optimiser would
only need to be written once, rather than needing a different
tool for every different filesystem type.....

Remember, I'm not just talking about defrag - I'm talking about
an interface that is actually useful to apps that might care
about how data is laid out on disk but the applications writers
don't know anyhting about how filesystem X or Y or Z is
implemented. Putting the burden of learning about fileystem
internals on application developers is not the correct solution.

I see substantial benefit moving forward from having filesystem
independent interfaces. Many features that  filesystems implement
are common, and as time goes on the common feature set of the
different filesystems gets larger. So why shouldn't we be
trying to make common operations generic so that every filesystem
can benefit from the latest and greatest tool?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
