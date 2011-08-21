From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/6 v5] ext4: fix 1k block bugs
Date: Sat, 20 Aug 2011 19:29:41 -0700
Message-ID: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54118 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab1HUC0k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Aug 2011 22:26:40 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7L1ulXM021088
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 21:56:47 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7L2QdG7206676
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:39 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7L2QdFP008768
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set corrects serveral bugs that occur
when blocksize = 1k.

The first bug appears in xfstests 75, 112, 127 and occurs
because the partial pages appearing at the head and tail
of a hole are not properly zeroed and unmapped

A second bug in test 127 occurs when i_size and the end of
the hole appear in the same page.  Because punch hole needs
to flush the pages in the hole, it will need to properly
unmap the partial page appearing after i_size.

Another bug occurred during extra fsx testing for the
first two patches.  This bug happens because truncate also
does not zero and unmap the partial page at the end of the
file.

Similar bugs also occurred when a write operation begins or
ends in a hole or extends EOF.  The partial page of the write
operation needs to be zeroed and unmapped.

These bugs are corrected using a new ext4_discard_partial_page_buffers
routine that zeros a specified region of a page, and unmaps buffer
heads for any block aligned region of the page that was completely
zeroed.

Lastly this set also contains a fix for bug reported by Lukas while
working on a new patch to add discard support to loop devices using
punch hole.  This bug occurs when calculating the byte offset for
very large holes because the block number needs to be cast to a wider
data type before cacluating the offset.
 
This patch set has passed the following tests
(for both 1k and 4k blocksizes):
xfstests 75, 112, 127, 252 and 256
fsx stress test (12 hours)

v1 -> v2
Added EXT4_BLOCK_ZERO_DISCARD_BUFFER flag

v2 -> v3
Moved code out of ext4_zero_block_page_range and in
to new ext4_unmap_page_range function

v3 -> v4
Renamed ext4_unmap_page_range to ext4_unmap_partial_page_buffers
Moved ext4_unmap_partial_page_buffers from inode.c to extents.c
Corrected comments for non block/page aligned handling
Added checks to avoid unnecessary page unmaps
Removed unneeded journaling and mapping from new routine

v4 -> v5
Renamed ext4_unmap_partial_page_buffers to
ext4_discard_partial_page_buffers_no_lock and added
new ext4_discard_partial_page_buffers wrapper function

Modified ext4_discard_partial_page_buffers_no_lock to
zero the page as well as unmap buffers

Moved ext4_discard_partial_page_buffers functions
back to inode.c, and also put in a seperate patch.

Added extra patches for write bugs and truncate bugs

Added extra patch for large hole calculation

Allison Henderson (6):
  ext4: Add new ext4_discard_partial_page_buffers routines
  ext4: fix xfstests 75, 112, 127 punch hole failure
  ext4: fix 2nd xfstests 127 punch hole failure
  ext4: Correct large hole offset calcuation
  ext4: fix fsx truncate failure
  ext4: fix partial page writes

 fs/ext4/ext4.h    |   11 ++++
 fs/ext4/extents.c |  103 +++++++++++++++++++++++--------
 fs/ext4/inode.c   |  174 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 262 insertions(+), 26 deletions(-)

