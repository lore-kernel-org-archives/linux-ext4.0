From: Chris Mason <chris.mason@oracle.com>
Subject: Re: ext4 writepages is making tiny bios?
Date: Tue, 1 Sep 2009 20:17:30 -0400
Message-ID: <20090902001730.GF7885@think>
References: <20090901184450.GB7885@think>
 <20090901205744.GE6996@mit.edu>
 <20090901212740.GA9930@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:64081 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZIBARn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2009 20:17:43 -0400
Content-Disposition: inline
In-Reply-To: <20090901212740.GA9930@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 01, 2009 at 05:27:40PM -0400, Christoph Hellwig wrote:
> On Tue, Sep 01, 2009 at 04:57:44PM -0400, Theodore Tso wrote:
> > > This graph shows the difference:
> > > 
> > > http://oss.oracle.com/~mason/seekwatcher/trace-buffered.png
> > 
> > Wow, I'm surprised how seeky XFS was in these graphs compared to ext4
> > and btrfs.  I wonder what was going on.
> 
> XFS did the mistake of trusting the VM, while everyone more or less
> overrode it.  Removing all those checks and writing out much larger
> data fixes it with a relatively small patch:
> 
> 	http://verein.lst.de/~hch/xfs/xfs-writeback-scaling
> 
> when that code was last benchamrked extensively (on SLES9) it
> worked nicely to saturate extremly large machines using buffered
> I/O, since then VM tuning basically destroyed it.
> 

I sent Christoph other versions of the graphs and tried a few fixes.
With patches they are down to almost 0 seeks/sec.

For the Ext4 bio size, this array is just a few sata drives and is
very tolerant.  Real raid or cciss controllers will benefit much more
from bigger bios.

And most importantly, seekwatcher wouldn't take as long to make the
graphs ;)

-chris

