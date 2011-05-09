From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 26/30] ext4: snapshot race conditions - tracked reads
Date: Mon,  9 May 2011 19:41:44 +0300
Message-ID: <1304959308-11122-27-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab1EIQo2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:44:28 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5955868wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:44:27 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Wait for pending read I/O requests to complete.
When a snapshot file readpage reads through to the block device,
the reading task increments the block tracked readers count.
Upon completion of the async read I/O request of the snapshot page,
the tracked readers count is decremented.
When a task is COWing a block with non-zero tracked readers count,
that task has to wait (in msleep(1) loop), until the block's tracked
readers count drops to zero, before the COW operation is completed.
After a pending COW operation has started, reader tasks have to wait
(again, in msleep(1) loop), until the pending COW operation is
completed, so the COWing task cannot be starved by reader tasks.
The sleep loop method was copied from LVM snapshot code, which does
the same thing to deal with these (rare) races without wait queues.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a7bb8ed..bf5aa4d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2249,12 +2249,18 @@ enum ext4_state_bits {
 			 * now used by snapshot to do mow
 			 */
 	BH_Partial_Write,	/* Buffer should be uptodate before write */
+	BH_Tracked_Read,	/* Buffer read I/O is being tracked,
+				 * to serialize write I/O to block device.
+				 * that is, don't write over this block
+				 * until I finished reading it.
+				 */
 };
 
 BUFFER_FNS(Uninit, uninit)
 TAS_BUFFER_FNS(Uninit, uninit)
 BUFFER_FNS(Remap, remap)
 BUFFER_FNS(Partial_Write, partial_write)
+BUFFER_FNS(Tracked_Read, tracked_read)
 
 /*
  * Add new method to test wether block and inode bitmaps are properly
-- 
1.7.0.4

