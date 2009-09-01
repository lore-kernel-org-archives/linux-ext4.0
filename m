From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ext4 writepages is making tiny bios?
Date: Tue, 1 Sep 2009 17:27:40 -0400
Message-ID: <20090901212740.GA9930@infradead.org>
References: <20090901184450.GB7885@think> <20090901205744.GE6996@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbZIAV1i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2009 17:27:38 -0400
Content-Disposition: inline
In-Reply-To: <20090901205744.GE6996@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 01, 2009 at 04:57:44PM -0400, Theodore Tso wrote:
> > This graph shows the difference:
> > 
> > http://oss.oracle.com/~mason/seekwatcher/trace-buffered.png
> 
> Wow, I'm surprised how seeky XFS was in these graphs compared to ext4
> and btrfs.  I wonder what was going on.

XFS did the mistake of trusting the VM, while everyone more or less
overrode it.  Removing all those checks and writing out much larger
data fixes it with a relatively small patch:

	http://verein.lst.de/~hch/xfs/xfs-writeback-scaling

when that code was last benchamrked extensively (on SLES9) it
worked nicely to saturate extremly large machines using buffered
I/O, since then VM tuning basically destroyed it.

