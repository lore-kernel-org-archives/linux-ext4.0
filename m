From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] libext2fs: reset handle after inserting new extent
Date: Tue, 07 Jul 2009 14:30:32 -0500
Message-ID: <4A53A258.20105@redhat.com>
References: <4A52776B.8000203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35607 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbZGGTae (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jul 2009 15:30:34 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n67JUYKe010140
	for <linux-ext4@vger.kernel.org>; Tue, 7 Jul 2009 15:30:34 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n67JUXad011583
	for <linux-ext4@vger.kernel.org>; Tue, 7 Jul 2009 15:30:33 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n67JUW6C008406
	for <linux-ext4@vger.kernel.org>; Tue, 7 Jul 2009 15:30:33 -0400
In-Reply-To: <4A52776B.8000203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 53422e8a5644e22ea3f6e0efba82a765b72e4308 moved
the new extent insertion in ext2fs_extent_set_bmap prior
to the modification of the original extent, but the
insert function left the handle pointing a the new
extent; this left us modifying the -new- extent not
the original one, and winding up with a corrupt extent
tree something like:

BLOCKS:
(0-1):588791-588792, (0):588791

We need to move back to the previous extent prior
to modification, if we inserted a new one.

V2: Use extent_goto vs. extent_get.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 35b080e..4a4fd2c 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1257,6 +1257,10 @@ again:
 					EXT2_EXTENT_INSERT_AFTER, &newextent);
 			if (retval)
 				goto done;
+			/* Now pointing at inserted extent; move back to prev */
+			retval = ext2fs_extent_goto(handle, logical - 1);
+			if (retval)
+				goto done;
 		}
 		extent.e_len--;
 		retval = ext2fs_extent_replace(handle, 0, &extent);

