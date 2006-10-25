From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 13:00:52 -0400
Message-ID: <20061025170052.GA19513@havoc.gtf.org>
References: <20061025011853.GQ8394166@melbourne.sgi.com> <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com> <20061025044844.GB32486@havoc.gtf.org> <20061025053823.GX8394166@melbourne.sgi.com> <20061025060142.GD32486@havoc.gtf.org> <20061025081137.GB8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Barry Naujok <bnaujok@melbourne.sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>,
	"'Alex Tomas'" <alex@clusterfs.com>,
	"'Theodore Tso'" <tytso@mit.edu>, "'Jan Kara'" <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:17546 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S965152AbWJYRA6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Oct 2006 13:00:58 -0400
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061025081137.GB8394166@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 06:11:37PM +1000, David Chinner wrote:
> On Wed, Oct 25, 2006 at 02:01:42AM -0400, Jeff Garzik wrote:
> > On Wed, Oct 25, 2006 at 03:38:23PM +1000, David Chinner wrote:
> > > On Wed, Oct 25, 2006 at 12:48:44AM -0400, Jeff Garzik wrote:
> > > So why are you arguing that an interface is no good because it
> > > is fundamentally racy? ;)
> > 
> > My point was that it is silly to introduce obviously racy code into the
> > kernel, when -- inside the kernel -- it could be handled race-free.
> 
> So how do you then get the generic interface to allocate blocks
> specified by userspace race free?

As has been repeatedly stated, there is no "generic".  There MUST be
filesystem-specific knowledge during these operations.


> If userspace directed allocation requires deep knowledge of the
> filesystem metadata (this is what you are saying they need to do,
> right?), then these applications will never, ever make use of this
> interface and we'll continue to have problems with them.

Completely false assumptions.  There is no difference in handling of
knowledge, be it kernel space or userspace.


> > Further, in the case being discussed in this thread, ext2meta has
> > already been proven a workable solution.
> 
> Sure, but that's not a generic solution to a problem common to
> all filesystems....

You clearly don't know what I'm talking about.  ext2meta is an example
of a filesystem-specific metadata access method, applicable to tasks
such as online optimization.

Implement that tiny kernel module for each filesystem, and you have
everything you need, without races.  This was discussed years ago;
review the mailing lists.  Google for 'Alexander Viro' and 'ext2meta'.

	Jeff
