From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 18:11:37 +1000
Message-ID: <20061025081137.GB8394166@melbourne.sgi.com>
References: <20061025011853.GQ8394166@melbourne.sgi.com> <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com> <20061025044844.GB32486@havoc.gtf.org> <20061025053823.GX8394166@melbourne.sgi.com> <20061025060142.GD32486@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>,
	Barry Naujok <bnaujok@melbourne.sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>,
	"'Alex Tomas'" <alex@clusterfs.com>,
	"'Theodore Tso'" <tytso@mit.edu>, "'Jan Kara'" <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:49343 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1423104AbWJYIQD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Oct 2006 04:16:03 -0400
To: Jeff Garzik <jeff@garzik.org>
Content-Disposition: inline
In-Reply-To: <20061025060142.GD32486@havoc.gtf.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 02:01:42AM -0400, Jeff Garzik wrote:
> On Wed, Oct 25, 2006 at 03:38:23PM +1000, David Chinner wrote:
> > On Wed, Oct 25, 2006 at 12:48:44AM -0400, Jeff Garzik wrote:
> > So why are you arguing that an interface is no good because it
> > is fundamentally racy? ;)
> 
> My point was that it is silly to introduce obviously racy code into the
> kernel, when -- inside the kernel -- it could be handled race-free.

So how do you then get the generic interface to allocate blocks
specified by userspace race free?

> > > Every major filesystem has a libfoofs library that makes it trivial to
> > > read the metadata, so all you need to do is use an existing lib.
> > 
> > IOWs, you are advocating that any application that wants to use this
> > special allocation technique needs to link against every different
> > filesystem library and it then needs to implement filesystem
> > specific searches through their metadata?  Nobody in their right
> > mind would ever want to use an interface like this.
> 
> Online defrag is OBVIOUSLY highly filesystem specific. 

Parts of it are, but data movement and allocation hints need to be
provided by every filesystem that wants to implement this
efficiently. These features are also useful outside of defrag as
well - I can think of several applications that would benefit from
being able to direct where in the filesystem they want data to
reside. 

If userspace directed allocation requires deep knowledge of the
filesystem metadata (this is what you are saying they need to do,
right?), then these applications will never, ever make use of this
interface and we'll continue to have problems with them.

I guess my point is that we are going to implement features like
this in XFS and if other filesystems are going to be doing the same
thing then we should try to come up with generic solutions rather
than reinvent the wheel over an over again.

> Further, in the case being discussed in this thread, ext2meta has
> already been proven a workable solution.

Sure, but that's not a generic solution to a problem common to
all filesystems....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
