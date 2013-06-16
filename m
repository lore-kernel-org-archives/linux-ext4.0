From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2image: fix crash when using e2image -I with a 64-bit file system
Date: Sat, 15 Jun 2013 21:00:27 -0400
Message-ID: <1371344427-18466-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58265 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab3FPBAa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Jun 2013 21:00:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Debian-Bug: #703067

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2image.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index 369c946..885a794 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1171,7 +1171,7 @@ static void install_image(char *device, char *image_fn, int type)
 {
 	errcode_t retval;
 	ext2_filsys fs;
-	int open_flag = EXT2_FLAG_IMAGE_FILE;
+	int open_flag = EXT2_FLAG_IMAGE_FILE | EXT2_FLAG_64BITS;
 	int fd = 0;
 	io_manager	io_ptr;
 	io_channel	io;
-- 
1.7.12.rc0.22.gcdd159b

