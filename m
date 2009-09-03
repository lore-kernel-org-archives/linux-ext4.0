From: Dave Chinner <david@fromorbit.com>
Subject: Re: ext4 writepages is making tiny bios?
Date: Thu, 3 Sep 2009 15:52:01 +1000
Message-ID: <20090903055201.GA7146@discord.disaster>
References: <20090901184450.GB7885@think> <20090901205744.GE6996@mit.edu> <20090901212740.GA9930@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090901212740.GA9930@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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

Careful:

-	tloff = min(tlast, startpage->index + 64);
+	tloff = min(tlast, startpage->index + 8192);

That will cause 64k page machines to try to write back 512MB at a
time. This will re-introduce similar to the behaviour in sles9 where
writeback would only terminate at the end of an extent (because the
mapping end wasn't capped like above).

This has two nasty side effects:

	1. horrible fsync latency when streaming writes are
	   occuring (e.g. NFS writes) which limit throughput
	2. a single large streaming write could delay the writeback
	   of thousands of small files indefinitely.

#1 is still an issue, but #2 might not be so bad compared to sles9
given the way inodes are cycled during writeback now...

> when that code was last benchamrked extensively (on SLES9) it
> worked nicely to saturate extremly large machines using buffered
> I/O, since then VM tuning basically destroyed it.

It was removed because it caused all sorts of problems and buffered
writes on sles9 were limited by lock contention in XFS, not the VM.
On 2.6.15, pdflush and the code the above patch removes was capable
of pushing more than 6GB/s of buffered writes to a single block
device. VM writeback has gone steadily down hill since then...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
