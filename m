From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 15:38:23 +1000
Message-ID: <20061025053823.GX8394166@melbourne.sgi.com>
References: <20061025011853.GQ8394166@melbourne.sgi.com> <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com> <20061025044844.GB32486@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>,
	Barry Naujok <bnaujok@melbourne.sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>,
	"'Alex Tomas'" <alex@clusterfs.com>,
	"'Theodore Tso'" <tytso@mit.edu>, "'Jan Kara'" <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:5815 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1161355AbWJYFju (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Oct 2006 01:39:50 -0400
To: Jeff Garzik <jeff@garzik.org>
Content-Disposition: inline
In-Reply-To: <20061025044844.GB32486@havoc.gtf.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 12:48:44AM -0400, Jeff Garzik wrote:
> On Wed, Oct 25, 2006 at 02:27:53PM +1000, David Chinner wrote:
> > But it a race that is _easily_ handled, and applications only need to
> > implement one interface, not a different method for every
> > filesystem that requires deeep filesystem knowledge.
> > 
> > Besides, you still have to handle the case where the block you want
> > has already been allocated because reading the metadata from
> > userspace doesn't prevent the kernel from allocating the block you
> > want before you ask for it...
> 
> The race is easily handled either way, by having the block move fail
> when you tell the kernel the destination blocks.

So why are you arguing that an interface is no good because it
is fundamentally racy? ;)

> The difference is that you don't unnecessarily bloat the kernel.

By that argument, we should rip out the bmap interface (FIBMAP)
because you can get all that information by reading the metadata
from userspace.....

> Every major filesystem has a libfoofs library that makes it trivial to
> read the metadata, so all you need to do is use an existing lib.

IOWs, you are advocating that any application that wants to use this
special allocation technique needs to link against every different
filesystem library and it then needs to implement filesystem
specific searches through their metadata?  Nobody in their right
mind would ever want to use an interface like this.

Also, this simply doesn't work for XFS because the cached metadata
is in a different address space to the block device. Hence it can be
tens of seconds between the kernel modifying a metadata buffer and
userspace being able to see that modification. You need to freeze
the filesystem for the XFS userspace tools to guarantee a
consistent view of an online filesystem from the block device.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
