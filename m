From: tytso@mit.edu
Subject: Re: [Jfs-discussion] benchmark results
Date: Thu, 24 Dec 2009 16:27:56 -0500
Message-ID: <20091224212756.GM21594@thunk.org>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
 <19251.26403.762180.228181@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ext-users <ext3-users@redhat.com>, linux-nilfs@vger.kernel.org
To: Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19251.26403.762180.228181@tree.ty.sabi.co.uk>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 24, 2009 at 01:05:39PM +0000, Peter Grandi wrote:
> > I've had the chance to use a testsystem here and couldn't
> > resist
> 
> Unfortunately there seems to be an overproduction of rather
> meaningless file system "benchmarks"...

One of the problems is that very few people are interested in writing
or maintaining file system benchmarks, except for file system
developers --- but many of them are more interested in developing (and
unfortunately, in some cases, promoting) their file systems than they
are in doing a good job maintaining a good set of benchmarks.  Sad but
true...

> * In the "generic" test the 'tar' test bandwidth is exactly the
>   same ("276.68 MB/s") for nearly all filesystems.
> 
> * There are read transfer rates higher than the one reported by
>   'hdparm' which is "66.23 MB/sec" (comically enough *all* the
>   read transfer rates your "benchmarks" report are higher).

If you don't do a "sync" after the tar, then in most cases you will be
measuring the memory bandwidth, because data won't have been written
to disk.  Worse yet, it tends to skew the results of the what happens
afterwards (*especially* if you aren't running the steps of the
benchmark in a script).

> BTW the use of Bonnie++ is also usually a symptom of a poor
> misunderstanding of file system benchmarking.

Dbench is also a really nasty benchmark.  If it's tuned correctly, you
are measuring memory bandwidth and the hard drive light will never go
on.  :-) The main reason why it was interesting was that it and tbench
was used to model a really bad industry benchmark, netbench, which at
one point a number of years ago I/T managers used to decide which CIFS
server they would buy[1].  So it was useful for Samba developers who were
trying to do competitive benchmkars, but it's not a very accurate
benchmark for measuring real-life file system workloads.

[1] http://samba.org/ftp/tridge/dbench/README

> On the plus side, test setup context is provided in the "env"
> directory, which is rare enough to be commendable.

Absolutely.  :-)

Another good example of well done file system benchmarks can be found
at http://btrfs.boxacle.net; it's done by someone who does performance
benchmarks for a living.  Note that JFS and XFS come off much better
on a number of the tests --- and that there is a *large* number amount
of variation when you look at different simulated workloads and with a
varying number of threads writing to the file system at the same time.

Regards,

	       	  	  	     	 - Ted
