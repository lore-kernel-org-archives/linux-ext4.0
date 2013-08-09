From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: fix interior extent node corruption
Date: Fri, 09 Aug 2013 00:09:06 -0500
Message-ID: <52047972.5010307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab3HIFJH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Aug 2013 01:09:07 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r795973S029659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 9 Aug 2013 01:09:07 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r795962h004150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 9 Aug 2013 01:09:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have  an extent tree like this (from debuge2fs's "ex" command):

Level Entries       Logical            Physical Length Flags
...
 2/ 2  60/ 63 13096 - 13117 650024 - 650045     22
 2/ 2  61/ 63 13134 - 13142 650062 - 650070      9
 2/ 2  62/ 63 13193 - 13194 650121 - 650122      2
 2/ 2  63/ 63 13227 - 13227 650155 - 650155      1 A)
 1/ 2   4/ 14 13228 - 17108 655367            3881 B)
 2/ 2   1/117 13228 - 13251 650156 - 650179     24 C)
 2/ 2   2/117 13275 - 13287 650203 - 650215     13
 2/ 2   3/117 13348 - 13353 650276 - 650281      6
... 

and we resize the fs in such a way that all of those blocks must
be moved down, we do them one at a time.  Eventually we move 1-block
extent A) to a lower block, and then follow it with the other
blocks in the next logical offsets from extent C) in the next
interior node B).

The userspace extent code tries to merge, so when it finds that
logical 13228 can be merged with logical 13227 into a single extent,
it does.  And so on, all through extent C), up to block 13250 (why
not 13251?  [1]), and eventually move the node block as well.
So we end up with this when all the blocks are moved post-resize:

Level Entries       Logical            Physical Length Flags
...
 2/ 2 120/122 13193 - 13193  33220 -  33220      1
 2/ 2 121/122 13194 - 13194  33221 -  33221      1
 2/ 2 122/122 13227 - 13250  33222 -  33245     24 D)
 1/ 2   5/ 19 13228 - 17108  34676            3881 E) ***
 2/ 2   1/222 13251 - 13251  33246 -  33246      1 F)
 2/ 2   2/222 13275 - 13286  33247 -  33258     12
...

All those adjacent blocks got moved into extent D), which is nice - 
but the next interior node E) was never updated to reflect its new 
starting point - it says the leaf extents beneath it start at 13228, 
when in fact they start at 13251.

So as we move blocks one by one out of original extent C) above, we
need to keep updating C)'s parent node B) for a proper starting point.
fix_parents() does this.

Once the tree is corrupted like this, more corruption can 
ensue post-resize, because we traverse the tree by interior nodes, 
relying on their start block to know where we are in the tree.
If it gets off, we'll end up inserting blocks into the wrong part
of the tree, etc.

I have a testcase using fsx to create a complex extent tree which
is then moved during resize; it hit this corruption quite easily,
and with this fix, it succeeds.

Note the first hunk in the commit is for going the other way,
moving the last block of an extent to the extent after it; this
needs the same sort of fix-up, although I haven't seen it in
practice.

[1] We leave the last block because a single-block extent is its
own case, and there is no merging code in that case.  \o/

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index de54319..ed239f6 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1378,6 +1378,9 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 							       &next_extent);
 				if (retval)
 					goto done;
+				retval = ext2fs_extent_fix_parents(handle);
+				if (retval)
+					goto done;
 			} else
 				retval = ext2fs_extent_insert(handle,
 				      EXT2_EXTENT_INSERT_AFTER, &newextent);
@@ -1430,6 +1433,9 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 		retval = ext2fs_extent_replace(handle, 0, &extent);
 		if (retval)
 			goto done;
+		retval = ext2fs_extent_fix_parents(handle);
+		if (retval)
+			goto done;
 	} else {
 		__u32	orig_length;
 

