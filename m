From: Eric Sandeen <sandeen@redhat.com>
Subject: odd allocation patterns
Date: Fri, 05 Sep 2008 13:24:00 -0500
Message-ID: <48C17940.5040406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47845 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYIESYs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Sep 2008 14:24:48 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m85IODZT030257
	for <linux-ext4@vger.kernel.org>; Fri, 5 Sep 2008 14:24:33 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m85IO1NP017856
	for <linux-ext4@vger.kernel.org>; Fri, 5 Sep 2008 14:24:02 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m85IO0Tt014042
	for <linux-ext4@vger.kernel.org>; Fri, 5 Sep 2008 14:24:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was trying some various IO patterns to see what the ext4 allocator
might do (as I tend  to do every few months ....)  :)

On the one hand there are some very interesting, and nice (at least for
some workloads) results:

If I write even, then odd, blocks, in the end it comes  out to one
extent - even with an unmount in between:

# for I in `seq 0 2 1024`; do dd if=/dev/zero of=testfile bs=4k count=1
conv=notrunc seek=$I 2>/dev/null; done

(unmount, remount)

# for I in `seq 1 2 1024`; do dd if=/dev/zero of=testfile bs=4k count=1
conv=notrunc seek=$I 2>/dev/null; done
# filefrag testfile
File is stored in extents format
testfile: 1 extent found

as long as the holes eventually get filled in, this is a pretty nice
behavior to end up with contiguous allocation (if they're not ever
filled in, it's a little odd)

However, sequential, synchronous writes are doing weird things:

# for I in `seq 1 1024`; do dd if=/dev/zero of=testfile bs=4k count=1
conv=notrunc seek=$I oflag=sync 2>/dev/null; done

# filefrag -v testfile
Checking testfile
Filesystem type is: ef53
Filesystem cylinder groups is approximately 235
File is stored in extents format
Blocksize of file testfile2 is 4096
File size of testfile2 is 4198400 (1025 blocks)
First block: 0
Last block: 45312
Discontinuity: Block 2 is at 44032 (was 43520)
Discontinuity: Block 11 is at 43521 (was 44040)
Discontinuity: Block 15 is at 43066 (was 43524)
Discontinuity: Block 256 is at 44544 (was 43306)
testfile: 5 extents found

not only is it non-contiguous, it's out of order.

Ditto for direct IO:

# for I in `seq 1 1024`; do dd if=/dev/zero of=testfile bs=4k count=1
conv=notrunc seek=$I oflag=direct 2>/dev/null; done

[root@inode test2]# filefrag -v testfile
Checking testfile
Filesystem type is: ef53
Filesystem cylinder groups is approximately 235
File is stored in extents format
Blocksize of file testfile is 4096
File size of testfile is 4198400 (1025 blocks)
First block: 0
Last block: 45312
Discontinuity: Block 2 is at 43525 (was 44041)
Discontinuity: Block 4 is at 44042 (was 43526)
Discontinuity: Block 5 is at 43527 (was 44042)
Discontinuity: Block 15 is at 43306 (was 43536)
Discontinuity: Block 16 is at 43312 (was 43306)
Discontinuity: Block 128 is at 43136 (was 43423)
Discontinuity: Block 256 is at 44544 (was 43263)
testfile: 8 extents found

Interestingly, a backwards synchronous write comes out exactly the same:

[root@inode test2]# for I in `seq 1024 -1 0`; do dd if=/dev/zero
of=testfile2 bs=4k count=1 conv=notrunc seek=$I oflag=sync 2>/dev/null; done
[root@inode test2]# filefrag -v testfileChecking testfile
Filesystem type is: ef53
Filesystem cylinder groups is approximately 235
File is stored in extents format
Blocksize of file testfile is 4096
File size of testfile is 4198400 (1025 blocks)
First block: 0
Last block: 45312
Discontinuity: Block 2 is at 43525 (was 44041)
Discontinuity: Block 4 is at 44042 (was 43526)
Discontinuity: Block 5 is at 43527 (was 44042)
Discontinuity: Block 15 is at 43306 (was 43536)
Discontinuity: Block 16 is at 43312 (was 43306)
Discontinuity: Block 128 is at 43136 (was 43423)
Discontinuity: Block 256 is at 44544 (was 43263)
testfile: 8 extents found

It's not an artifact of filefrag; debugfs shows it as well:

BLOCKS:
(IND):43066, (1):44041, (2-3):43525-43526, (4):44042,
(5-14):43527-43536, (15):43306, (16-127):43312-43423,
 (128-255):43136-43263, (256-1024):44544-45312

not sure what's going  on here, have not started digging yet, but it's
.... odd.  With delallloc and buffered (non-synchronous IO), these all
come out pretty sanely.

-Eric
