From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 14:53:15 -0400
Message-ID: <1242067995.13509.1.camel@localhost.localdomain>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
	 <20090511081216.GK4694@kernel.dk> <20090511084121.GB29082@mit.edu>
	 <1242062325.9647.4.camel@localhost.localdomain>
	 <20090511184323.GA16885@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:28922 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZEKSyX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 14:54:23 -0400
In-Reply-To: <20090511184323.GA16885@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-05-11 at 11:43 -0700, Matthew Wilcox wrote:
> On Mon, May 11, 2009 at 01:18:45PM -0400, Chris Mason wrote:
> > For both btrfs and lvm, the filesystem is going to maintain free block
> > information based on logical block numbers.  The generic trim layer
> > should probably be based on a logical address that is stored per-bdi.
> > 
> > Then the bdi will need a callback to turn the logical address based trim
> > extent into physical extents on N number of physical device.
> > 
> > The tricky part is how will the FS decide a given block is actually
> > reusable.  We'll need a call back into the FS that indicates trim is
> > complete on a given logical extent.
> 
> Actually, that's the exact opposite of what you want.  You want to try
> to reuse blocks that are scheduled for trimming so that we never have to
> send the command at all.

Regardless of the optimal way to reuse blocks, we need some way of
knowing the discard is done, or at least sent down to the device in such
a way that any writes will happen after the discard and not before.

-chris




