From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] e2freefrag: use 64-bit rbtree bitmaps
Date: Thu,  4 Oct 2012 23:44:54 -0400
Message-ID: <1349408695-11661-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53926 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab2JEH3P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 03:29:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Enable the use of 64-bit bitmaps, so e2freefrag will work on file
systems with the 64-bit feature enabled.  In addition, enable the
rbtree-based bitmaps, which significantly saves the amount of memory
required (from 97 megs to 1.7 megs for an empty 3T file system) at the
cost of additional CPU overhead (but we will claw back some of the
additional CPU overhead in the next commit).

Addresses-Google-Bug: 7269948

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2freefrag.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index 30af43e..58f1ff5 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -249,13 +249,14 @@ static void collect_info(ext2_filsys fs, struct chunk_info *chunk_info, FILE *f)
 static void open_device(char *device_name, ext2_filsys *fs)
 {
 	int retval;
-	int flag = EXT2_FLAG_FORCE;
+	int flag = EXT2_FLAG_FORCE | EXT2_FLAG_64BITS;
 
 	retval = ext2fs_open(device_name, flag, 0, 0, unix_io_manager, fs);
 	if (retval) {
 		com_err(device_name, retval, "while opening filesystem");
 		exit(1);
 	}
+	(*fs)->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
 }
 #endif
 
-- 
1.7.12.rc0.22.gcdd159b

