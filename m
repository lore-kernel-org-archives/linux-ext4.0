From: alex@clusterfs.com
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Sun, 08 Oct 2006 00:09:44 +0400
Message-ID: <m3ac47nb07.fsf@bzzz.home.net>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005205526.7fe744f5.akpm@osdl.org>
	<20061005215442.310b7792.rdunlap@xenotime.net>
	<20061006055305.GG22010@schatzie.adilger.int>
	<20061005230401.0159e31b.akpm@osdl.org>
	<20061006064103.GJ22010@schatzie.adilger.int>
	<20061005235017.cbc4fdab.akpm@osdl.org> <m3k63divkw.fsf@bzzz.home.net>
	<20061006065735.1b51cc18.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:40081 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S932789AbWJGUIN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Oct 2006 16:08:13 -0400
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: Alex Tomas's message of "(unknown date)"
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi

>>>>> Alex Tomas (AT) writes:

 >>> it depends on underlaying storage and workload. mballoc uses buddy
 >>> internally. it's much simpler and cheaper to find free 2^N blocks
 >>> compared to bitmap.

 AM> So mballoc's application is to save CPU cycles?

AFAIU, we don't implement complex scanning for given size in balloc.c
because bitmap isn't very comfortable structure for this and that would
require many cycles. with mballoc it becomes possible. for example,
to find 1MB free chunk one has to choose group (mballoc tracks number
of free chunks in every buddy) and then scan just few bits). thus we
can produce better layout and improve performance.

 >>> this is especially important for arrays like
 >>> DDN and raid5/6 because they require stripe-aligned/-sized requests
 >>> for good throughput.

 AM> Does this not imply that there needs to be new linkage between the
 AM> filesystem and the lower layers?  So that raid/etc can inform the
 AM> filesystem driver about its alignment and striping requirements?

currently, we pass preferred I/O size with mount option (stripe=N).
I'd like that sort of communication between block driver and fs.
something like f_bsize.

 >>> also, last mballoc takes logical block into
 >>> account and can preallocate few chunks at different logical offsets
 >>> for a file. imagine torrent downloading different pieces from few peers.

 AM> hm.  You don't need anything as exotic as bittorrent to show up problems in
 AM> that area:

 AM> box:/usr/src/25> sudo bmap vmlinux | wc -l
 AM> 1152

well, this can be (and will be, I very hope :) solved
by delayed allocation. I mentioned torrent because it's
often used to get really large files. so large that they
don't fit cache and delayed allocation won't help much.
preallocation can help, but then few preallocations per
file is required.

thanks, Alex
