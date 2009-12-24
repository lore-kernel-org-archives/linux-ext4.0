From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [Jfs-discussion] benchmark results
Date: Fri, 25 Dec 2009 02:46:31 +0300
Message-ID: <20091224234631.GA1028@ioremap.net>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, xfs@oss.sgi.com,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	ext-users <ext3-users@redhat.com>, linux-nilfs@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cet.com.ru ([195.178.208.66]:38971 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZLXXqh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Dec 2009 18:46:37 -0500
Content-Disposition: inline
In-Reply-To: <20091224212756.GM21594@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted.

On Thu, Dec 24, 2009 at 04:27:56PM -0500, tytso@mit.edu (tytso@mit.edu) wrote:
> > Unfortunately there seems to be an overproduction of rather
> > meaningless file system "benchmarks"...
> 
> One of the problems is that very few people are interested in writing
> or maintaining file system benchmarks, except for file system
> developers --- but many of them are more interested in developing (and
> unfortunately, in some cases, promoting) their file systems than they
> are in doing a good job maintaining a good set of benchmarks.  Sad but
> true...

Hmmmm.... I suppose here should be a link to such set? :)
No link? Than I suppose benchmark results are pretty much in sync with
what they are supposed to show.

> > * In the "generic" test the 'tar' test bandwidth is exactly the
> >   same ("276.68 MB/s") for nearly all filesystems.
> > 
> > * There are read transfer rates higher than the one reported by
> >   'hdparm' which is "66.23 MB/sec" (comically enough *all* the
> >   read transfer rates your "benchmarks" report are higher).
> 
> If you don't do a "sync" after the tar, then in most cases you will be
> measuring the memory bandwidth, because data won't have been written
> to disk.  Worse yet, it tends to skew the results of the what happens
> afterwards (*especially* if you aren't running the steps of the
> benchmark in a script).

It depends on the size of untarred object, for linux kernel tarball and
common several gigs of RAM it is very valid not to run a sync after the
tar, since writeback will take care about it.

> > BTW the use of Bonnie++ is also usually a symptom of a poor
> > misunderstanding of file system benchmarking.
> 
> Dbench is also a really nasty benchmark.  If it's tuned correctly, you
> are measuring memory bandwidth and the hard drive light will never go
> on.  :-) The main reason why it was interesting was that it and tbench
> was used to model a really bad industry benchmark, netbench, which at
> one point a number of years ago I/T managers used to decide which CIFS
> server they would buy[1].  So it was useful for Samba developers who were
> trying to do competitive benchmkars, but it's not a very accurate
> benchmark for measuring real-life file system workloads.
> 
> [1] http://samba.org/ftp/tridge/dbench/README

Was not able to resist to write a small notice, what no matter what, but
whatever benchmark is running, it _does_ show system behaviour in one
or another condition. And when system behaves rather badly, it is quite
a common comment, that benchmark was useless. But it did show that
system has a problem, even if rarely triggered one :)

Not an ext4 nitpick of course.

-- 
	Evgeniy Polyakov
