From: Sean Fu <fxinrong@gmail.com>
Subject: [PATCH] ext4: Remove repeated test in ext4_file_read_iter.
Date: Wed, 27 Dec 2017 16:19:58 +0800
Message-ID: <1514362798-5850-1-git-send-email-fxinrong@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sean Fu <fxinrong@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:40241 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbdL0IUF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Dec 2017 03:20:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

generic_file_read_iter has done the count test.
So ext4_file_read_iter don't need to test the count repeatedly.

Signed-off-by: Sean Fu <fxinrong@gmail.com>
---
 fs/ext4/file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index a0ae27b..87ca13e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -67,9 +67,6 @@ static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(file_inode(iocb->ki_filp)->i_sb))))
 		return -EIO;
 
-	if (!iov_iter_count(to))
-		return 0; /* skip atime */
