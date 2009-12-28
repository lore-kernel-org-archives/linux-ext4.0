From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
Date: Sun, 27 Dec 2009 17:24:05 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0912271707240.3483@bogon.housecafe.de>
References: <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org> <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de> <20091225161453.GD32757@thunk.org> <20091225162238.GB19303@bitmover.com> <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
 <4B36333B.3030600@hp.com> <4B365EBE.5050804@nerdbynature.de> <4B37BA76.7050403@hp.com> <alpine.DEB.2.01.0912271346240.3483@bogon.housecafe.de> <20091227223307.GA4429@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jim owens <jowens@hp.com>, Larry McVoy <lm@bitmover.com>,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58655 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZL1BYn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Dec 2009 20:24:43 -0500
In-Reply-To: <20091227223307.GA4429@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 27 Dec 2009 at 17:33, tytso@mit.edu wrote:
> Yes, but given many of the file systems have almost *exactly* the same

"Almost" indeed - but curiously enough some filesystem are *not* the same, 
although they should. Again: we have 8GB RAM, I'm copying ~3GB of data, so 
why _are_ there differences? (Answer: because filesystems are different). 
That's the only point of this test. Also note the disclaimer[0] I added to 
the results page a few days ago.

> measurement is 5 times the disk bandwidith as measured by hdparm, it
> makes me suspect that you are doing this:
> /bin/time /bin/cp -r /source/tree /filesystem-under-test
> sync

No, I'm not - see the test script[1] - I'm taking the time for cp/rm/tar 
*and* sync. But even if I would only take the time *only* for say "cp", 
not the sync part. Still, it would be a valid comparison across 
filesystems (the same operation for every filesystem) also a not very 
realistic one - because in the real world I *want* to make sure my data is 
on the disk. But that's as far as I go in these tests, I'm not even 
messing around with disk caches or HBA caches - that's not the scope of 
these tests.

> You might notice it if you include the "sync" in the timing, i.e.:
> /bin/time /bin/sh -c "/bin/cp -r /source/tree /filesystem-under-test;/bin/sync"

Yes, that's exactly what the tests do.

> "/bin/cp" returns, then sure, do whatever you want.  But if you want
> the tests to have meaning if, for example, you have 2GB of memory and
> you are copying 8GB of data, 

For the bonnie++ tests I chose a filesize (16GB) so that disk performance 
will matter here. As the generic tests shuffle around much more smaller 
data, no disk performance, but filesystem performance is measured (and 
compared to other filesystems) - well aware of the fact that caches *Are* 
being used. Why would I want to discard caches? My daily usage pattern 
(opening webrowsers, terminal windows, spreadcheats deal with much smaller 
datasets and I'm happy that Linux is so hungry for cache - yet some 
filesystems do not seem to utilize this opportunity as good as others do. 
That's the whole point of this particular test. But constantly explaining 
my point over and over again I see what I have to do: I shall run the 
generic tests again with much bigger datasets, so that disk-performance is 
also reflected, as people do seem to care about this (I don't - I can 
switch filesystems more easily than disks).

> The bottom line is that it's very hard to do good comparisons that are
> useful in the general case.

And it's difficult to find out what's a "useful comparison" for the 
general public :-)

Christian.

[0] http://nerdbynature.de/benchmarks/v40z/2009-12-22/
[1] http://nerdbynature.de/benchmarks/v40z/2009-12-22/env/fs-bench.sh.txt
-- 
BOFH excuse #292:

We ran out of dial tone and we're and waiting for the phone company to deliver another bottle.
