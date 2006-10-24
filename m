From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Tue, 24 Oct 2006 23:59:28 +1000
Message-ID: <20061024135928.GB11034@melbourne.sgi.com>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:28900 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030315AbWJXOCI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Oct 2006 10:02:08 -0400
To: Jeff Garzik <jeff@garzik.org>
Content-Disposition: inline
In-Reply-To: <20061024041433.GB12506@havoc.gtf.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 24, 2006 at 12:14:33AM -0400, Jeff Garzik wrote:
> On Mon, Oct 23, 2006 at 06:31:40PM +0400, Alex Tomas wrote:
> > isn't that a kernel responsbility to find/allocate target blocks?
> > wouldn't it better to specify desirable target group and minimal
> > acceptable chunk of free blocks?
> 
> The kernel doesn't have enough knowledge to know whether or not the
> defragger prefers one blkdev location over another.
> 
> When you are trying to consolidate blocks, you must specify the
> destination as well as source blocks.
> 
> Certainly, to prevent corruption and other nastiness, you must fail if
> the destination isn't available...

That's the wrong way to look at it. if you want the userspace
process to specify a location, then you should preallocate it first
before doing anything else. There is no need to clutter a simple
data mover interface with all sorts of unnecessary error handling.

Once you've separated the destination allocation from the data
mover, the mover is basically a splice copy from source to
destination, an fsync and then an atomic swap blocks/extents operation.
Most of this code is generic, and a per-fs swap-extents vector
could be easily provided for the one bit that is not....

The allocation interface, OTOH, is anything but simple and is really
a filesystem specific interface. Seems logical to me to separate
the two. 

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
