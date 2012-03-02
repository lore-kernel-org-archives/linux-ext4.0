From: Chris Mason <chris.mason@oracle.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 2 Mar 2012 14:50:45 -0500
Message-ID: <20120302195045.GA28296@shiny>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
 <20120301143859.GX5054@shiny>
 <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
 <20120302140038.GD5054@shiny>
 <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
 <20120302142651.GH5054@shiny>
 <20120302193215.GB22215@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:45056 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2CBTuu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2012 14:50:50 -0500
Content-Disposition: inline
In-Reply-To: <20120302193215.GB22215@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 02, 2012 at 02:32:15PM -0500, Ted Ts'o wrote:
> On Fri, Mar 02, 2012 at 09:26:51AM -0500, Chris Mason wrote:
> > 
> > filefrag will tell you how many extents each file has, any file with
> > more than one extent is interesting.  (The ext4 crowd may have better
> > suggestions on measuring fragmentation).
> 
> You can get a *huge* amount of information (probably more than you'll
> want to analyze) by doing this:
> 
>      e2fsck -nf -E fragcheck /dev/XXXX >& /tmp/fragcheck.out
> 
> I haven't had time to do this in a while, but a while back I used this
> to debug the writeback code with an eye towards reducing
> fragmentation.  At the time I was trying to optimize the case of
> reducing fragmentation in the easist case possible, where you start
> with an empty file system, and then copy all of the data from another
> file system onto it using rsync -avH.
> 
> It would be worth while to see what happens with files written by the
> compiler and linker.  Given that libelf tends to write .o files
> non-sequentially, and without telling us how big the space is in
> advance, I could well imagine that we're not doing the best job
> avoiding free space fragmentation, which eventually leads to extra
> file system aging.

I just realized that I confused things.  He's doing a read on the
results of a cp -a to a fresh FS, so there's no way the compiler/linker
are causing trouble.

> 
> It would be interesting to have a project where someone added
> fallocate() support into libelf, and then added some hueristics into
> ext4 so that if a file is fallocated to a precise size, or if the file
> is fully written and closed before writeback begins, that we use this
> to more efficiently pack the space used by the files by the block
> allocator.  This is a place where I would not be surprised that XFS
> has some better code to avoid accelerated file system aging, and where
> we could do better with ext4 with some development effort.

The part I don't think any of us have solved is writing back the files
in a good order after we've fallocated the blocks.

So this will probably be great for reads and not so good for writes.

> 
> Of course, it might also be possible to hack around this by simply
> using VPATH and dropping your build files in a separate place from
> your source files, and periodically reformatting the file system where
> your build tree lives.  (As a side note, something that works well for
> me is to use an SSD for my source files, and a separate 5400rpm HDD
> for my build tree.  That allows me to use a smaller and more
> affordable SSD, and since the object files can be written
> asynchronously by the writeback threads, but the compiler can't move
> forward until it gets file data from the .c or .h file, it gets me the
> best price/performance for a laptop build environment.)

mkfs for defrag ;)  It's the only way to be sure.

> 
> BTW, I suspect we could make acp even more efficient by teaching it to
> use FIEMAP ioctl to map out the data blocks for all of the files in
> the source file system, and then copied the files (or perhaps even
> parts of files) in a read order which reduced seeking on the source
> drive.

acp does have a -b mode where it fibmaps (I was either lazy or it is
older than fiemap, I forget) the first block in the file, and uses that
to sort.  It does help if the file blocks aren't ordered well wrt their
inode numbers, but not if the files are fragmented.

It's also worth mentioning that acp doesn't actually cp.  I never got
that far.  It was supposed to be the perfect example of why everything
should be done via aio, but it just ended up demonstrating that ordering
by inode number and leveraging kernel/hardware reada were more
important.

-chris
