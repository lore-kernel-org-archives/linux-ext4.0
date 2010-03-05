From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/3] ext4: Fix insertion point of extent in mext_insert_across_blocks()
Date: Fri, 05 Mar 2010 17:19:53 +0900
Message-ID: <4B90BEA9.9020208@rs.jp.nec.com>
References: <4B8E0679.8060706@rs.jp.nec.com> <20100304012508.GD3530@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50328 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0CEIUQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Mar 2010 03:20:16 -0500
In-Reply-To: <20100304012508.GD3530@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(2010/03/04 10:25), tytso@mit.edu wrote:
> On Wed, Mar 03, 2010 at 03:49:29PM +0900, Akira Fujita wrote:
>> ext4: Fix insertion point of extent in mext_insert_across_blocks()
>>
>> From: Akira Fujita<a-fujita@rs.jp.nec.com>
>>
>> If the leaf node has 2 extent space or fewer and
>> EXT4_IOC_MOVE_EXT ioctl is called
>> with the file offset where after the 2nd extent covers,
>> mext_insert_across_blocks() always tries to insert extent into the first extent.
>> As a result, the file gets corrupted because of
>> wrong extent order.  The patch fixes this problem.
>
> Do you have test cases that we can use as part of a regression test
> suite to test the EXT4_IOC_MOVE_EXT ioctl?  I'm very glad you found
> these problems (although timing --- right before the merge window is
> about to close --- wasn't exactly ideal), but what's more important to
> me is how we get better regression testing.
>
> The other two two patches are obviously correct, but this one is going
> to require me to spend a long time staring at the verious corner cases
> in order for me to convince myself that it is totally safe.  If we had
> a set of test cases where we could easily verify the "before" and
> "after" file system images as being correct, and then combined it with
> a code coverage tool, it would make it a lot easier to validate future
> patches in fs/ext4/move_extent.c.

Yes, I have small regression test cases,
but they need to be arranged to release.
I'll send them to you later, please wait for a few days.

> It would be useful for other parts of the kernel as well, but at least
> for the standard extents function we have some fairly aggressive
> generic file system tests, combined with the fact that
> fs/ext4/extents.c gets exercised much more frequently than
> fs/ext4/move_extents.c.
>
> So the question is how can get we get to the point where we can
> comfortable tell people that e2defrag is totally safe, and has no
> chance of corrupting their data?

e4defrag just do the following 3 actions.
1. Create donor file
2. Allocate blocks to donor with fallocate
3. Exchange blocks between orig and donor with EXT4_IOC_MOVE_EXT

So if we can say EXT4_IOC_MOVE_EXT is safe, e4defrag is safe as well
(This presumes that fallocate is already secure quality, though).
Slightly anxious is if the crash occurs during e4defrag,
surely we have to remove donor file by hand.  This is unmanageable, I think.

To improve e4defrag quality, it is necessary to have more
people (courageous users) use it.
For that purpose, at least, the open mode fix patch I have released
(http://marc.info/?l=linux-ext4&m=126387585515465&w=2) needs to be merged into e2fsprogs.
Currently user can not do e4defrag because
there is a file open mode mismatch between user-space and kernel-space.

>
> P.S.  Here's another random idea for how we might aggressively test
> the EXT4_IOC_MOVE_EXT ioctl: (1) create an empty filesystem, (2)
> create a tool which randomly sets 50% of the bits in the block
> allocation bitmap, marking them as in use, and making the free space
> look very badly fragmented.  (3) write a large number of files into
> the filesystem.  (4) calculate the checksums for all of the files.
> (5) run e2fsck on the filesystem to fix up the block allocation
> bitmap.  (6) defrag all of the files on the filesystem.  (7) use
> e2fsck to make sure the filesystem is still consistent.  (8) calculate
> the checksums for all of the files to make sure they still contain
> their original data.

Sounds interesting.
It seems to be able to try easily except (2).
I think that we can mark block bitmap as in use with debugfs (do_setb).
Do you have another better idea for the tool you mentioned at (2)?

Regards,
Akira Fujita
