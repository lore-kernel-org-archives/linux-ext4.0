From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] e2image: fix resource leak when running e2image -n
Date: Fri,  3 Jan 2014 00:29:54 -0500
Message-ID: <1388726998-14349-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45542 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaACFaI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 00:30:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-ID: #1147783

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2image.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index ab6a4fa..253fad1 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -174,7 +174,7 @@ static void generic_write(int fd, void *buf, int blocksize, blk64_t block)
 		printf(_("Writing block %llu\n"), (unsigned long long) block);
 		if (fd != 1)
 			seek_relative(fd, blocksize);
-		return;
+		goto free_and_return;
 	}
 	count = write(fd, buf, blocksize);
 	if (count != blocksize) {
@@ -191,6 +191,7 @@ static void generic_write(int fd, void *buf, int blocksize, blk64_t block)
 
 		exit(1);
 	}
+free_and_return:
 	if (free_buf)
 		ext2fs_free_mem(&buf);
 }
-- 
1.8.5.rc3.362.gdf10213

