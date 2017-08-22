From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: improve performance of region_allocate()
Date: Mon, 21 Aug 2017 22:29:48 -0400
Message-ID: <20170822022948.nyn6fessudjaj5xh@thunk.org>
References: <20170819011635.1815929-1-dsp@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Jaco Kroon <jaco@uls.co.za>
To: Doug Porter <dsp@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39208 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754381AbdHVC34 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Aug 2017 22:29:56 -0400
Content-Disposition: inline
In-Reply-To: <20170819011635.1815929-1-dsp@fb.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 18, 2017 at 06:16:35PM -0700, Doug Porter wrote:
> Use a red-black tree to track allocations instead of a linked list.
> This provides a substantial performance boost when the number of
> allocations in a region is large.  This change resulted in a reduction
> in runtime from 4821s to 6s on one filesystem.
> 
> Signed-off-by: Doug Porter <dsp@fb.com>

Hi Doug, as it turns out, Jaco Kroon and I had been debugging the same
problem as oen you were working on.  We came up with a different way
of solving this problem (see below).  It works by observing that
unless the extent tree is terribly corrupted, region_allocate() will
always be appending to the very end of the list.

However, it has since occurred to me that since we are doing an
breadth-first traversal of the extent tree, the starting lba for each
leaf node *must* always be monotonically increasing, and we already
check to make sure this is true within an extent tree block.  So I
think it might be possible to dispense with using any kind of data
structure, whether it's an rbtree or a linked list, and instead just
simply make sure we enforce the start+len of the last entry in an
extent tree block is < the starting lba of the first entry in the next
extent tree block.

We are already checking all of the necessary other conditions in
scan_extent_node, so with this additional check, I believe that using
the region tracking code in scan_extent_node (which was originally
written to make sure that extended attribute block did not have any
parts of a string shared between more than one EA key or value pair)
can be made entirely unnecessary for scan_extent_node().

I haven't had a chance to code this alternate fix, but I believe it
should be superior to either your patch or the one which I had drafted
below.  Does this make sense to you?

							- Ted

commit 8a48ce07a5923242fecc5dc04d6e30dd59a8f07d
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Aug 14 19:52:39 2017 -0400

    e2fsck: add optimization for large, fragmented sparse files
    
    The code which checks for overlapping logical blocks in an extent tree
    is O(h*e) in time, where h is the number of holes in the file, and e
    is the number of extents in the file.  So a file with a large number
    of holes can take e2fsck a long time process.  Optimize this taking
    advantage of the fact the vast majority of the time, region_allocate()
    is called with increasing logical block numbers, so we are almost
    always append onto the end of the region list.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/e2fsck/region.c b/e2fsck/region.c
index e32f89db0..95d23be4f 100644
--- a/e2fsck/region.c
+++ b/e2fsck/region.c
@@ -30,6 +30,7 @@ struct region_struct {
 	region_addr_t	min;
 	region_addr_t	max;
 	struct region_el *allocated;
+	struct region_el *last;
 };
 
 region_t region_create(region_addr_t min, region_addr_t max)
@@ -42,6 +43,7 @@ region_t region_create(region_addr_t min, region_addr_t max)
 	memset(region, 0, sizeof(struct region_struct));
 	region->min = min;
 	region->max = max;
+	region->last = NULL;
 	return region;
 }
 
@@ -68,6 +70,18 @@ int region_allocate(region_t region, region_addr_t start, int n)
 	if (n == 0)
 		return 1;
 
+	if (region->last && region->last->end == start &&
+	    !region->last->next) {
+		region->last->end = end;
+		return 0;
+	}
+	if (region->last && start > region->last->end &&
+	    !region->last->next) {
+		r = NULL;
+		prev = region->last;
+		goto append_to_list;
+	}
+
 	/*
 	 * Search through the linked list.  If we find that it
 	 * conflicts witih something that's already allocated, return
@@ -92,6 +106,8 @@ int region_allocate(region_t region, region_addr_t start, int n)
 					r->end = next->end;
 					r->next = next->next;
 					free(next);
+					if (!r->next)
+						region->last = r;
 					return 0;
 				}
 			}
@@ -104,12 +120,15 @@ int region_allocate(region_t region, region_addr_t start, int n)
 	/*
 	 * Insert a new region element structure into the linked list
 	 */
+append_to_list:
 	new_region = malloc(sizeof(struct region_el));
 	if (!new_region)
 		return -1;
 	new_region->start = start;
 	new_region->end = start + n;
 	new_region->next = r;
+	if (!new_region->next)
+		region->last = new_region;
 	if (prev)
 		prev->next = new_region;
 	else
