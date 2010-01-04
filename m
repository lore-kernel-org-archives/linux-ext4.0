From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Jfs-discussion] benchmark results
Date: Mon, 4 Jan 2010 11:27:48 -0500
Message-ID: <20100104162748.GA11932@think>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
 <19251.26403.762180.228181@tree.ty.sabi.co.uk>
 <20091224212756.GM21594@thunk.org>
 <20091224234631.GA1028@ioremap.net>
 <20091225161146.GC32757@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, xfs@oss.sgi.com,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	ext-users <ext3-users@redhat.com>, linux-nilfs@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091225161146.GC32757@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 25, 2009 at 11:11:46AM -0500, tytso@mit.edu wrote:
> On Fri, Dec 25, 2009 at 02:46:31AM +0300, Evgeniy Polyakov wrote:
> > > [1] http://samba.org/ftp/tridge/dbench/README
> > 
> > Was not able to resist to write a small notice, what no matter what, but
> > whatever benchmark is running, it _does_ show system behaviour in one
> > or another condition. And when system behaves rather badly, it is quite
> > a common comment, that benchmark was useless. But it did show that
> > system has a problem, even if rarely triggered one :)
> 
> If people are using benchmarks to improve file system, and a benchmark
> shows a problem, then trying to remedy the performance issue is a good
> thing to do, of course.  Sometimes, though the case which is
> demonstrated by a poor benchmark is an extremely rare corner case that
> doesn't accurately reflect common real-life workloads --- and if
> addressing it results in a tradeoff which degrades much more common
> real-life situations, then that would be a bad thing.
> 
> In situations where benchmarks are used competitively, it's rare that
> it's actually a *problem*.  Instead it's much more common that a
> developer is trying to prove that their file system is *better* to
> gullible users who think that a single one-dimentional number is
> enough for them to chose file system X over file system Y.

[ Look at all this email from my vacation...sorry for the delay ]

It's important that people take benchmarks from filesystem developers
with a big grain of salt, which is one reason the boxacle.net results
are so nice.  Steve more than willing to take patches and experiment to
improve a given FS results, but his business is a fair representation of
performance and it shows.

> 
> For example, if I wanted to play that game and tell people that ext4
> is better, I'd might pick this graph:
> 
> http://btrfs.boxacle.net/repository/single-disk/2.6.29-rc2/2.6.29-rc2/2.6.29-rc2_Mail_server_simulation._num_threads=32.html
> 
> On the other hand, this one shows ext4 as the worst compared to all
> other file systems:
> 
> http://btrfs.boxacle.net/repository/single-disk/2.6.29-rc2/2.6.29-rc2/2.6.29-rc2_Large_file_random_writes_odirect._num_threads=8.html
> 
> Benchmarking, like statistics, can be extremely deceptive, and if
> people do things like carefully order a tar file so the files are
> optimal for a file system, it's fair to ask whether that's a common
> thing for people to be doing (either unpacking tarballs or unpacking
> tarballs whose files have been carefully ordered for a particular file
> systems).

I tend to use compilebench for testing the ability to create lots of
small files, which puts the file names into FS native order (by
unpacking and then readdiring the results) before it does any timings.

I'd agree with Larry that benchmarking is most useful to test a theory.
Here's a patch that is supposed to do xyz, is that actually true.  With
that said we should also be trying to write benchmarks that show the
worst case...we know some of our design weakness and should be able to
show numbers for how bad it really is (see the random write
btrfs.boxacle.net tests for that one).

-chris

