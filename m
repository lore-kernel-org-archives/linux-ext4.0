From: harshads <harshads@google.com>
Subject: [PATCH] ext4: Fix a race in the ext4 shutdown path.
Date: Tue,  9 Jan 2018 14:52:57 -0800
Message-ID: <20180109225257.93785-1-harshads@google.com>
Cc: tytso@mit.edu, harshads <harshads@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:40325 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752178AbeAIWx1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jan 2018 17:53:27 -0500
Received: by mail-pg0-f66.google.com with SMTP id q12so9043230pgt.7
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jan 2018 14:53:27 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixes a race between the shutdown path and bio completion
handling. In the ext4 direct io path with async io, after submitting a
bio to the block layer, if journal starting fails,
ext4_direct_IO_write() would bail out pretending that the IO
failed. The caller would have had no way of knowing whether or not the
IO was successfully submitted. So instead, we return -EIOCBQUEUED in
this case. Now, the caller knows that the IO was submitted.  The bio
completion handler takes care of the error.

Tested: Ran the shutdown xfstest test 461 in loop for over 2 hours across
4 machines resulting in over 400 runs. Verified that the race didn't
occur. Usually the race was seen in about 20-30 iterations.

Signed-off-by: Harshad Shirwadkar <harshads@google.com>
---
 fs/ext4/inode.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 534a9130f625..4c2f8b57bdc7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3767,10 +3767,18 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
 		/* Credits for sb + inode write */
 		handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
 		if (IS_ERR(handle)) {
-			/* This is really bad luck. We've written the data
-			 * but cannot extend i_size. Bail out and pretend
-			 * the write failed... */
-			ret = PTR_ERR(handle);
+			/*
+			 * We wrote the data but cannot extend
+			 * i_size. Bail out. In async io case, we do
+			 * not return error here because we have
+			 * already submmitted the corresponding
+			 * bio. Returning error here makes the caller
+			 * think that this IO is done and failed
+			 * resulting in race with bio's completion
+			 * handler.
+			 */
+			if (!ret)
+				ret = PTR_ERR(handle);
 			if (inode->i_nlink)
 				ext4_orphan_del(NULL, inode);
 
-- 
2.16.0.rc1.238.g530d649a79-goog
