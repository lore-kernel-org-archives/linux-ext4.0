From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Tue, 24 Oct 2006 09:51:41 -0500
Message-ID: <1161701502.20134.17.camel@kleikamp.austin.ibm.com>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz>
	 <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net>
	 <20061024041433.GB12506@havoc.gtf.org>
	 <20061024135928.GB11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:18574 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932426AbWJXOv4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Oct 2006 10:51:56 -0400
To: David Chinner <dgc@sgi.com>
In-Reply-To: <20061024135928.GB11034@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2006-10-24 at 23:59 +1000, David Chinner wrote:
> On Tue, Oct 24, 2006 at 12:14:33AM -0400, Jeff Garzik wrote:
> > On Mon, Oct 23, 2006 at 06:31:40PM +0400, Alex Tomas wrote:
> > > isn't that a kernel responsbility to find/allocate target blocks?
> > > wouldn't it better to specify desirable target group and minimal
> > > acceptable chunk of free blocks?
> > 
> > The kernel doesn't have enough knowledge to know whether or not the
> > defragger prefers one blkdev location over another.
> > 
> > When you are trying to consolidate blocks, you must specify the
> > destination as well as source blocks.
> > 
> > Certainly, to prevent corruption and other nastiness, you must fail if
> > the destination isn't available...
> 
> That's the wrong way to look at it. if you want the userspace
> process to specify a location, then you should preallocate it first
> before doing anything else. There is no need to clutter a simple
> data mover interface with all sorts of unnecessary error handling.

You are implying the the 2-step interface, creating a new inode then
swapping the contents, is the only way to implement this.
> 
> Once you've separated the destination allocation from the data
> mover, the mover is basically a splice copy from source to
> destination, an fsync and then an atomic swap blocks/extents operation.
> Most of this code is generic, and a per-fs swap-extents vector
> could be easily provided for the one bit that is not....

The benefit of having such a simple data mover is negated by moving the
complexity into the allocator.

A single interface that would move a part of a file at a time has the
advantage that a large file which is only fragmented in a few areas does
not need to be completely moved.

> The allocation interface, OTOH, is anything but simple and is really
> a filesystem specific interface. Seems logical to me to separate
> the two. 

So what then is the benefit of having a simple generic data mover if
every file system needs to implement it's own interface to allocate a
copy of the data?

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
