From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: bug in inode allocator?
Date: Mon, 22 Mar 2010 17:21:23 -0700
Message-ID: <20100323002123.GQ29604@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:41384 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab0CWAVY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2010 20:21:24 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o2N0Gohl012673
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 18:16:50 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2N0LOSc138396
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 18:21:24 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2N0LNqf002210
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 18:21:24 -0600
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm trying to understand how ext4_allocate_inode selects a blockgroup when
creating a top level directory, and I've noticed a couple of odd behaviors with
the algorithm (2.6.34-rc2 if anyone cares):

First, the allocator will pick a random blockgroup from which to begin a linear
scan of all the blockgroups to find the least heavily loaded one.  However, if
there are ties for the least heavily loaded bg, the allocator picks the first
one it scanned, not necessarily the one with the lowest bg number.  This seems
to be a strategy to scatter top level directories all over the disk in an
attempt to try to keep top level directories from ending up in the same bg and
fragmenting each other.  However, if the tie is between empty blockgroups and
the media is a rotating disk, this can result in top level directories being
created far away from the high-bandwidth beginning of the disk.  If one creates
only a handful of directories which all end up hashing to higher number
blockgroups, then the filesystem won't use the high performance areas of the
disk until there's enough data to wrap around to the blockgroups at the
beginning.

An "easy" fix seems to be: If there is a tie in comparing blockgroups, then the
one with the lowest bg number wins, though that heavily biases blockgroup
creation towards the beginning of the disk, so further study on my part is
needed.  In performing _that_ analysis, I came across a second problem:

The get_orlov_stat() function returns three metrics for a given block group;
these metrics (used_dirs, free_inodes, and free_blocks) are used to figure out
if one blockgroup is less heavily loaded than another.  If I create a bunch of
1-byte files, the free_inodes and free_blocks counts decrease by 1 every time,
as you'd expect.  However, when I create directories, only the free_blocks
count decreases--used_dirs and free_inodes remain the same!  This seemed very
suspicious to me, so I umounted and mounted the filesystem and reran my test.
free_blocks and used_dirs suddenly decreased by the number of directories that
I had created before the umount, but after the first mkdir, the free_inodes and
used_dirs counts did not change, just like before.

I then ran a loop wherein I create a directory and then a small file.  For
each dir/file creation, the free_inodes count decreased by 1, the used_dirs
count remained unchanged, and the free_blocks count decreased by 2.  Weird,
since I was pretty sure that even directories require an inode and a block.

I interpret this behavior to mean that free_inodes/used_dirs only get updated
at mount time and at file creation time, and furthermore are not being updated
when directories get created.  The fact that the counts _do_ suddenly decrease
across a umount/mount cycle confirms that directories do use inodes, which is
what I expect.  I wondered if this was a behavior of delalloc or something, but
-o nodelalloc did not change the behavior.  Nor did adding copious calls to
sync.

Unfortunately, this second behavior means that the "find the least full
blockgroup" code can use stale data in its comparisons.  Am I correct that
something is wrong here, or have I misinterpreted the code?  Is it /supposed/
to be the case that used_dirs reflects the number of directories in the
blockgroup at *mount time* and not at the current time?

--D
