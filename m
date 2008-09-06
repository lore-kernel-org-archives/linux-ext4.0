From: Andreas Dilger <adilger@sun.com>
Subject: Re: odd allocation patterns
Date: Sat, 06 Sep 2008 00:39:39 -0600
Message-ID: <20080906063939.GJ3086@webber.adilger.int>
References: <48C17940.5040406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56872 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYIFGjr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Sep 2008 02:39:47 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m866dgxY000569
	for <linux-ext4@vger.kernel.org>; Fri, 5 Sep 2008 23:39:42 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6R00I01GVSA600@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 05 Sep 2008 23:39:41 -0700 (PDT)
In-reply-to: <48C17940.5040406@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 05, 2008  13:24 -0500, Eric Sandeen wrote:
> If I write even, then odd, blocks, in the end it comes  out to one
> extent - even with an unmount in between:
> 
> # for I in `seq 0 2 1024`; do dd if=/dev/zero of=testfile bs=4k count=1
> conv=notrunc seek=$I 2>/dev/null; done
> 
> (unmount, remount)
> 
> # for I in `seq 1 2 1024`; do dd if=/dev/zero of=testfile bs=4k count=1
> conv=notrunc seek=$I 2>/dev/null; done
> # filefrag testfile
> File is stored in extents format
> testfile: 1 extent found

Interesting.  I'd asked Alex to tune the allocator to locate blocks
with a position relative to the end of the previously-allocated blocks.
I didn't think it would actually work so well :-).

> However, sequential, synchronous writes are doing weird things:
> 
> # for I in `seq 1 1024`; do dd if=/dev/zero of=testfile bs=4k count=1
> conv=notrunc seek=$I oflag=sync 2>/dev/null; done
> 
> # filefrag -v testfile
> Checking testfile
> Filesystem type is: ef53
> Filesystem cylinder groups is approximately 235
> File is stored in extents format
> Blocksize of file testfile2 is 4096
> File size of testfile2 is 4198400 (1025 blocks)
> First block: 0
> Last block: 45312
> Discontinuity: Block 2 is at 44032 (was 43520)
> Discontinuity: Block 11 is at 43521 (was 44040)
> Discontinuity: Block 15 is at 43066 (was 43524)
> Discontinuity: Block 256 is at 44544 (was 43306)
> testfile: 5 extents found
> 
> not only is it non-contiguous, it's out of order.

I agree this is completely strange.  The only thing I can think of is
that this is being treated as a "small file" and the blocks are being
packed into the small file preallocation group, and if this is an SMP
system then it is possible there are 2 or more preallocation spaces.
Since you have 3 processes running (bash, seq, dd) and dd is being run
in a different process (CPU?) for each block.

Can you try running this with a single process?  Even if you run
"dd if=/dev/zero of=testfile bs=4k count=1024 oflag=sync" should
still produce single-block sync writes without forking each time.

I agree the allocator probably shouldn't do this, but it isn't exactly
a normal workload.  It seems possible that the goal block (the last
block allocated) isn't being taken into account properly?  It also
seems possible that if the dd process is moving between CPUs each time
the preallocation group is blocking the allocation of the "next" block?

> Interestingly, a backwards synchronous write comes out exactly the same:

Are you sure you unlinked the file in between? :-)

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

