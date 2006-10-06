From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Fri, 06 Oct 2006 14:31:59 +0400
Message-ID: <m3k63divkw.fsf@bzzz.home.net>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005205526.7fe744f5.akpm@osdl.org>
	<20061005215442.310b7792.rdunlap@xenotime.net>
	<20061006055305.GG22010@schatzie.adilger.int>
	<20061005230401.0159e31b.akpm@osdl.org>
	<20061006064103.GJ22010@schatzie.adilger.int>
	<20061005235017.cbc4fdab.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:10157 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1751422AbWJFKay (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 06:30:54 -0400
To: Andrew Morton <akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Andrew Morton (AM) writes:

 AM> On Fri, 6 Oct 2006 00:41:03 -0600
 AM> Andreas Dilger <adilger@clusterfs.com> wrote:

 >> The big performance win will come with mballoc and delalloc.  CFS has
 >> been using mballoc for a few years already with Lustre, and IBM + Bull
 >> did a lot of benchmarking on it.  The reason it isn't in the first set of
 >> patches is partly a manageability issue, and partly because it doesn't
 >> directly affect the on-disk format (outside of much better allocation)
 >> so it isn't critical to get into the first round of changes.  I believe
 >> Alex is working on a new set of patches right now.

 AM> Are you sure that these things will improve allocation much?  Reservations
 AM> made a big improvement there.

it depends on underlaying storage and workload. mballoc uses buddy
internally. it's much simpler and cheaper to find free 2^N blocks
compared to bitmap. this is especially important for arrays like
DDN and raid5/6 because they require stripe-aligned/-sized requests
for good throughput. also, last mballoc takes logical block into
account and can preallocate few chunks at different logical offsets
for a file. imagine torrent downloading different pieces from few peers.

thanks, Alex
