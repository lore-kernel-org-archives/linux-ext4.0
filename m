From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] ext4: flex_bg ialloc, don't pick "best_flex" with 0
 inodes
Date: Fri, 15 Aug 2008 17:01:10 -0500
Message-ID: <48A5FCA6.5070902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jose R. Santos" <jrs@us.ibm.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbYHOWBM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Aug 2008 18:01:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've got a case where I have a 99G fs with 17G free, as well
as 400k free inodes, and yet I cannot create a new inode.

The find_group_flex() function starts with best_flex as
the parent_fbg_group, which happens to have 0 inodes free.

Some of the flex groups searched have free blocks and free 
inodes, but the flex_freeb_ratio is < 10, so they're skipped.

Then when a group is compared to the current "best" flex group,
it does not have more free blocks than "best", so it is skipped
as well.

This continues until no flex group with free inodes is found
which has a proper ratio or which has more free blocks than
the "best" group, and we're left with a "best" group that has
0 inodes free, and we return -ENOSPC.

It seems like adjusting the following test is a better plan;
for starters I do not see that best_flex can ever be < 0, so
that test is replaced, and if the current "best" flex group
has no inodes free, and the current one does have room,
it is promoted to the next "best."

Comments?

Signed-of-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/ialloc.c	2008-08-04 15:30:30.000000000 -0500
+++ linux-2.6/fs/ext4/ialloc.c	2008-08-15 16:12:47.366515679 -0500
@@ -351,7 +351,7 @@ find_close_to_parent:
 			goto found_flexbg;
 		}
 
-		if (best_flex < 0 ||
+		if (flex_group[best_flex].free_inodes == 0 ||
 		    (flex_group[i].free_blocks >
 		     flex_group[best_flex].free_blocks &&
 		     flex_group[i].free_inodes))

