From: Andreas Dilger <adilger@sun.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Tue, 25 Aug 2009 11:52:47 -0600
Message-ID: <20090825175247.GX5931@webber.adilger.int>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com>
 <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int>
 <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com>
 <20090824220738.GG17684@mit.edu> <4A93103B.2000909@redhat.com>
 <20090824232804.GJ17684@mit.edu> <20090824234336.GU5931@webber.adilger.int>
 <20090825001554.GN17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57186 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbZHYRwl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 13:52:41 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7PHqgf7020433
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 10:52:43 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KOY00E001EVYT00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 25 Aug 2009 10:52:42 -0700 (PDT)
In-reply-to: <20090825001554.GN17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 24, 2009  20:15 -0400, Theodore Ts'o wrote:
> On Mon, Aug 24, 2009 at 05:43:36PM -0600, Andreas Dilger wrote:
> > Without transaction checksums waiting on all of the blocks together
> > is NOT safe.  If the commit record is on disk, but the rest of the
> > transaction's blocks are not then during replay it may cause garbage
> > to be written from the journal into the filesystem metadata.
> 
> That's the one optimization we using journal checksums buys us.
> Unfortunately it does not allow us to omit the barrier
> operation.... and have real-world testing experience that without the
> barrier, a power drop can cause significant filesystem corruption and
> potential data loss.
> 
> Try using Chris Mason's torture-test workload with async-checksums
> without this patch; you will get data corruption if you try dropping
> power while his torture-test is running.  I know you really don't like
> the barrier, but I'm afraid it's not safe to run without it, even with
> journal checksums.

In our performance testing of barriers (not with Chris' program), it
was FAR better to disable the disk cache and wait for IO completion
(i.e. barriers disabled) on just the journal blocks than to enable the
cache and cause a cache flush for each "barrier".  The problem is that at
high IO rates there is much more data in the cache vs. the actual journal
blocks, and forcing the whole cache to be flushed each transaction commit
hurt our performance noticably.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

