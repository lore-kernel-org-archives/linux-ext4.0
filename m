From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/6 v7] ext4: fix 1k block bugs
Date: Tue, 30 Aug 2011 17:28:27 -0700
Message-ID: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35758 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab1HaAZZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Aug 2011 20:25:25 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Tue, 30 Aug 2011 20:25:24 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7V0PLh51429730
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 20:25:21 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7V0PKYN001392
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 21:25:21 -0300
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set corrects several bugs that occur
when blocksize = 1k.

The first bug appears in xfstests 75, 112, 127 and occurs
because the partial pages appearing at the head and tail
of a hole are not properly zeroed and unmapped

A second bug in test 127 occurs when i_size and the end of
the hole appear in the same page.  Because punch hole needs
to flush the pages in the hole, it will need to properly
unmap the partial page appearing after i_size.

A similar bug occurred during extra fsx testing for the
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

This set also contains a fix for a bug reported by Lukas while
working on a new patch to add discard support to loop devices using
punch hole.  This bug occurs when calculating the byte block offset for
very large holes.  Since the code now needs the byte offset of the
pages instead of the blocks, the problem code is simply removed.

Lastly the set contains a patch to lock i_mutex for punch hole.
Yongquiang noticed that the vfs locks i_mutex for truncate,
but not for fallocate, so fallocate will need to take i_mutex
before calling punch hole.
 
This patch set has passed the following tests
(for both 1k and 4k blocksizes):
xfstests 75, 112, 127, 130, 252 and 256
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
back to inode.c, and also put in a separate patch.

Added extra patches for write bugs and truncate bugs

Added extra patch for large hole calculation

v5 -> v6
Merged patch 4 into patch 2 since block offsets are
no longer needed

Removed uneeded ClearPageUptodate when unmapping
buffer heads

Patch set now passes test 130.  The
ext4_discard_partial_page_buffers_no_lock routine
was modified to map buffer heads for unblock aligned
regions of the page (if needed) so that they can be
updated with the contents of the block before being
partially zeroed

v6 -> v7
Added feedback to simplify ext4_discard_partial_page_buffers_no_lock

Remove journaling for buffer heads that are block aligned

Do not mark unmapped buffers dirty (causes a warning)

Added patch to lock i_mutex for punch hole

Allison Henderson (6):
  ext4: Add new ext4_discard_partial_page_buffers routines
  ext4: fix xfstests 75, 112, 127 punch hole failure
  ext4: fix 2nd xfstests 127 punch hole failure
  ext4: Lock i_mutex for punch hole
  ext4: fix fsx truncate failure
  ext4: fix partial page writes

 fs/ext4/ext4.h     |   11 +++
 fs/ext4/extents.c  |  126 ++++++++++++++++++++-------
 fs/ext4/indirect.c |   16 +++-
 fs/ext4/inode.c    |  243 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 363 insertions(+), 33 deletions(-)

