From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] mke2fs: fix numeric progress meter for huge filesystem
Date: Sun,  8 Feb 2015 21:25:30 +0900
Message-ID: <1423398330-16342-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40317 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbbBHMZl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Feb 2015 07:25:41 -0500
Received: by mail-pa0-f53.google.com with SMTP id lf10so20011537pab.12
        for <linux-ext4@vger.kernel.org>; Sun, 08 Feb 2015 04:25:41 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When creating a huge filesystem like 16TB, numeric progress meter for
discarding device blocks doesn't work correctly.  Because it does not
correctly calculate the number of backspaces to flush the previous
number.

Fix argument type of int_log10() so that it can handle more than
UINT_MAX.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/ext2fs/progress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/progress.c b/lib/ext2fs/progress.c
index 83556b1..0c93591 100644
--- a/lib/ext2fs/progress.c
+++ b/lib/ext2fs/progress.c
@@ -25,7 +25,7 @@ struct ext2fs_progress_ops ext2fs_numeric_progress_ops = {
 	.close		= ext2fs_numeric_progress_close,
 };
 
-static int int_log10(unsigned int arg)
+static int int_log10(unsigned long long arg)
 {
 	int	l;
 
-- 
1.9.1

