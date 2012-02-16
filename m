From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 1/2] e2image: truncate raw image file to correct size
Date: Thu, 16 Feb 2012 16:35:11 -0500
Message-ID: <1329428112-8911-1-git-send-email-psusi@ubuntu.com>
Cc: linux-ext4@vger.kernel.org, Phillip Susi <psusi@ubuntu.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:50779 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab2BPVm7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2012 16:42:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At the end of writing the raw image file, output_meta_data_blocks()
wrote a single zero byte.  Not only does this cause the last block
of the image file to be non sparse, but this was being skipped if
there were no leftover sparse bytes from the main loop.  This would
happen if the source fs happened to have an even multiple of 1MiB
of free blocks at the end, leaving the sparse image file shorter
than it should be.

Instead of writing a null byte, just truncate() the file instead,
whether or not there are any leftover sparse bytes.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 misc/e2image.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index d888e5a..722737c 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -511,8 +511,7 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
 			}
 		}
 	}
-	if (sparse)
-		write_block(fd, zero_buf, sparse-1, 1, -1);
+	ftruncate(fd, lseek(fd, sparse, SEEK_CUR));
 	ext2fs_free_mem(&zero_buf);
 	ext2fs_free_mem(&buf);
 }
-- 
1.7.5.4

