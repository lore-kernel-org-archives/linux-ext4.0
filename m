From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: remove nr_to_write writeback windup.
Date: Tue, 25 May 2010 20:54:11 +1000
Message-ID: <1274784852-30502-6-git-send-email-david@fromorbit.com>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tytso@mit.edu, jens.axboe@oracle.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:48406 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756477Ab0EYKyy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 06:54:54 -0400
In-Reply-To: <1274784852-30502-1-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dave Chinner <dchinner@redhat.com>

Now that the background flush code has been fixed, we shouldn't need to
silently multiply the wbc->nr_to_write to get good writeback. Remove
that code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 089eaca..4c89db3 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1366,14 +1366,6 @@ xfs_vm_writepage(
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
 
-
-	/*
-	 *  VM calculation for nr_to_write seems off.  Bump it way
-	 *  up, this gets simple streaming writes zippy again.
-	 *  To be reviewed again after Jens' writeback changes.
-	 */
-	wbc->nr_to_write *= 4;
