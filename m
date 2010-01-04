From: Michael Rubin <mrubin@google.com>
Subject: Re: [Jfs-discussion] benchmark results
Date: Mon, 4 Jan 2010 10:57:49 -0800
Message-ID: <532480951001041057w3ad8d1dfy361ced0346ebaaa4__35393.752976279$1262631524$gmane$org@mail.gmail.com>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org>
	<20091224234631.GA1028@ioremap.net> <20091225161146.GC32757@thunk.org>
	<20100104162748.GA11932@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, tytso@mit.edu,
	Evgeniy Polyakov <zbr@ioremap.net>,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.uk>, xfs@oss.sgi.com,
	reiserfs-devel@vger.kernel.org, lin
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:40718 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0ADS6N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jan 2010 13:58:13 -0500
In-Reply-To: <20100104162748.GA11932@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Google is currently in the middle of upgrading from ext2 to a more up
to date file system. We ended up choosing ext4. This thread touches
upon many of the issues we wrestled with, so I thought it would be
interesting to share. We should be sending out more details soon.

The driving performance reason to upgrade is that while ext2 had been "good
enough" for a very long time the metadata arrangement on a stale file
system was leading to what we call "read inflation". This is where we
end up doing many seeks to read one block of data. In general latency
from poor block allocation was causing performance hiccups.

We spent a lot of time with unix standard benchmarks (dbench, compile
bench, et al) on xfs, ext4, jfs to try to see which one was going to
perform the best. In the end we mostly ended up using the benchmarks
to validate our assumptions and do functional testing. Larry is
completely right IMHO. These benchmarks were instrumental in helping
us understand how the file systems worked in controlled situations and
gain confidence from our customers.

For our workloads we saw ext4 and xfs as "close enough" in performance
in the areas we cared about. The fact that we had a much smoother
upgrade path with ext4 clinched the deal. The only upgrade option we
have is online. ext4 is already moving the bottleneck away from the
storage stack for some of our most intensive applications.

It was not until we moved from benchmarks to customer workload that we
were able to make detailed performance comparisons and find bugs in
our implementation.

"Iterate often" seems to be the winning strategy for SW dev. But when
it involves rebooting a cloud of systems and making a one way
conversion of their data it can get messy. That said I see benchmarks
as tools to build confidence before running traffic on redundant live
systems.

mrubin

PS for some reason "dbench" holds mythical power over many folks I
have met. They just believe it's the most trusted and standard
benchmark for file systems. In my experience it often acts as a random
number generator. It has found some bugs in our code as it exercises
the VFS layer very well.
