From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/5 v6] ext4: fix 1k block bugs
Date: Wed, 24 Aug 2011 12:07:17 -0700
Message-ID: <1314212842-16741-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:51551 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1HXTEe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Aug 2011 15:04:34 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7OIw1d1009763
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 12:58:01 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7OJ4Lh0115960
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 13:04:23 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7OD3mn3024253
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 07:03:48 -0600
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

Lastly this set also contains a fix for a bug reported by Lukas while
working on a new patch to add discard support to loop devices using
punch hole.  This bug occurs when calculating the byte block offset for
very large holes.  Since the code now needs the byte offset of the
pages instead of the blocks, the problem code is simply removed.
 
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

Allison Henderson (5):
  ext4: Add new ext4_discard_partial_page_buffers routines
  ext4: fix xfstests 75, 112, 127 punch hole failure
  ext4: fix 2nd xfstests 127 punch hole failure
  ext4: fix fsx truncate failure
  ext4: fix partial page writes

 fs/ext4/ext4.h     |   11 +++
 fs/ext4/extents.c  |  116 +++++++++++++++++++------
 fs/ext4/indirect.c |   16 +++-
 fs/ext4/inode.c    |  242 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 355 insertions(+), 30 deletions(-)

