From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: e2fsck readahead speedup performance report
Date: Fri, 8 Aug 2014 20:18:45 -0700
Message-ID: <20140809031845.GJ11191@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42886 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaHIDSw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 23:18:52 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Since I this email last week, I rewrote the prefetch algorithms for pass 1 and
2 and separated thread support into a separate patch.  Upon discovering that
issuing a POSIX_FADV_DONTNEED call caused a noticeable increase (of about 2-5%
points) on fsck runtime, I dropped that part out.

In pass 1, we now walk the group descriptors looking for inode table blocks to
read until we have found enough to issue a $readahead_kb size readahead
command.  The patch also computes the number of the first inode of the last
inode buffer block of the last group of the readahead group and schedules the
next readahead to occur when we reach that inode.  This keeps the readahead
running at closer to full speed and eliminates conflicting IOs between the
checker thread and the readahead.

For pass 2, readahead is broken up into $readahead_kb sized chunks instead of
issuing all of them at once.  This should increase the likelihood that a block
is not evicted before pass2 tries to read it.

Pass 4's readahead remains unchanged.

The raw numbers from my performance evaluation of the new code live here:
https://docs.google.com/spreadsheets/d/1hTCfr30TebXcUV8HnSatNkm4OXSyP9ezbhtMbB_UuLU

This time, I repeatedly ran e2fsck -Fnfvtt with various sizes of readahead
buffer to see how that affected fsck runtime.  The run times are listed in the
table at row 22, and I've created a table at row 46 to show % reduction in
e2fsck runtime.  I tried (mostly) power-of-two buffer sizes from 1MB to 1GB; as
you can see, even a small amount of readahead can speed things up quite a lot,
though the returns diminish as the buffer sizes get exponentially larger.  USB
disks suffer across the board, probably due to their slow single-issue nature.
Hopefully UAS will eliminate that gap, though currently it just crashes my
machines.

Note that all of these filesystems are formatted ext4 with an per-group inode
table size of 2MB, which is probably why readahead=2MB seems to win most often.
I think 2MB is a small enough amount that we needn't worry about thrashing
memory in the case of parallel e2fsck, particularly because with a small
readahead amount, e2fsck is most likely going to demand the blocks fairly soon
anyway.  The design of the new pass1 RA code won't issue RA for a fraction of a
block group's inode table blocks, so I propose setting RA to blocksize *
inode_blocks_per_group.

On a lark I fired up an old ext3 filesystem to see what would happen, and the
results generally follow the ext4 results.  I haven't done much digging into
ext3 though.  Potentially, one could prefetch the block map blocks when reading
in another inode_buffer_block's worth of inode tables.

Will send patches soon.

--D
