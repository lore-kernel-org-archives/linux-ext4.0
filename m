From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 02:01:42 -0400
Message-ID: <20061025060142.GD32486@havoc.gtf.org>
References: <20061025011853.GQ8394166@melbourne.sgi.com> <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com> <20061025044844.GB32486@havoc.gtf.org> <20061025053823.GX8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Barry Naujok <bnaujok@melbourne.sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>,
	"'Alex Tomas'" <alex@clusterfs.com>,
	"'Theodore Tso'" <tytso@mit.edu>, "'Jan Kara'" <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:35815 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1423039AbWJYGBo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Oct 2006 02:01:44 -0400
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061025053823.GX8394166@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 03:38:23PM +1000, David Chinner wrote:
> On Wed, Oct 25, 2006 at 12:48:44AM -0400, Jeff Garzik wrote:
> > On Wed, Oct 25, 2006 at 02:27:53PM +1000, David Chinner wrote:
> > > But it a race that is _easily_ handled, and applications only need to
> > > implement one interface, not a different method for every
> > > filesystem that requires deeep filesystem knowledge.
> > > 
> > > Besides, you still have to handle the case where the block you want
> > > has already been allocated because reading the metadata from
> > > userspace doesn't prevent the kernel from allocating the block you
> > > want before you ask for it...
> > 
> > The race is easily handled either way, by having the block move fail
> > when you tell the kernel the destination blocks.
> 
> So why are you arguing that an interface is no good because it
> is fundamentally racy? ;)

My point was that it is silly to introduce obviously racy code into the
kernel, when -- inside the kernel -- it could be handled race-free.

If you accept a racy solution, you might as well do it outside the
kernel, where you get the same results, but without adding silliness and
bloat to the kernel.


> > Every major filesystem has a libfoofs library that makes it trivial to
> > read the metadata, so all you need to do is use an existing lib.
> 
> IOWs, you are advocating that any application that wants to use this
> special allocation technique needs to link against every different
> filesystem library and it then needs to implement filesystem
> specific searches through their metadata?  Nobody in their right
> mind would ever want to use an interface like this.

Online defrag is OBVIOUSLY highly filesystem specific.  You have to link
against filesystem specific code somewhere, whether its inside the
kernel or outside the kernel.

Further, in the case being discussed in this thread, ext2meta has
already been proven a workable solution.

	Jeff
