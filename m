From: Chris Mason <chris.mason@oracle.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 14 Mar 2012 15:17:39 -0400
Message-ID: <20120314191739.GA19217@shiny>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
 <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
 <20120310044804.GB5652@thunk.org>
 <4F5F9A97.5060404@ubuntu.com>
 <20120313195339.GA24124@thunk.org>
 <4F5FAC9C.9070607@gmail.com>
 <20120313213304.GB11969@thunk.org>
 <alpine.LFD.2.00.1203140825090.5379@dhcp-27-109.brq.redhat.com>
 <20120314125002.GH15379@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Phillip Susi <phillsusi@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:42014 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2CNTRq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Mar 2012 15:17:46 -0400
Content-Disposition: inline
In-Reply-To: <20120314125002.GH15379@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 14, 2012 at 08:50:02AM -0400, Ted Ts'o wrote:
> On Wed, Mar 14, 2012 at 09:12:02AM +0100, Lukas Czerner wrote:
> > I kind of like the idea about having the separate btree with inode
> > numbers for the directory reading, just because it does not affect
> > allocation policy nor the write performance which is a good thing. Also
> > it has been done before in btrfs and it works very well for them. The
> > only downside (aside from format change) is the extra step when removing
> > the directory entry, but the positives outperform the negatives.
> 
> Well, there will be extra (journaled!) block reads and writes involved
> when adding or removing directory entries.  So the performance on
> workloads that do a large number of directory adds and removed will
> have to be impacted.  By how much is not obvious, but it will be
> something which is measurable.

Most of the difference in btrfs rm times comes from our double indexing.
We store the directory name 3 times, once for each dir index and once
in the inode backref.  But the inode backref doesn't generate seeks the
same way the extra directory index does, so it is probably only 10% of
the cost.

We also delete file data crcs during rm, so if you're benchmarking
things to see how much it will hurt, benchmark btrfs on zero length
files.

In terms of other costs, most users of readdir will eventually wander
off and stat or open the files in the dir.  With your current indexes, the stat
reads the same directory blocks that readdir used.

With the double index, the stat reads the name index instead of the
readdir index.  For the common case of normal directories, today's ext4
will have the directory blocks in cache when stat is called.  Btrfs has
to do extra reads to pull in the name index.

Josef worked around this by prefilling a dentry during readdir with
details on where to find the inode.

Either way, I'd definitely recommend sitting down with the xfs directory
indexes and look at how they manage locality without the double
indexing.  It's faster than btrfs and without the penalty.

It's also worth mentioning that on an SSD, there is no benefit at all to
the extra index.  So when the industry finally floods the markets with
hybrid PCM shingled drives, this might all be moot.

-chris
