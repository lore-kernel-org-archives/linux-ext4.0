From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] libext2fs: fix inode cache overruns
Date: Sat, 17 Nov 2012 13:37:45 -0500
Message-ID: <20121117183745.GA8489@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64082 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2KQShu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Nov 2012 13:37:50 -0500
Received: by mail-qa0-f53.google.com with SMTP id k31so2514228qat.19
        for <linux-ext4@vger.kernel.org>; Sat, 17 Nov 2012 10:37:49 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


An inode cache slot will be overrun if a caller to ext2fs_read_inode_full()
or ext2fs_write_inode_full() attempts to read or write a full sized 156
byte inode when the target filesystem contains 128 byte inodes.  Limit the
copied inode to the smaller of the target filesystem's or the caller's
requested inode size.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 lib/ext2fs/inode.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 0ea210e..e47d664 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -582,7 +582,8 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	/* Check to see if it's in the inode cache */
 	for (i = 0; i < fs->icache->cache_size; i++) {
 		if (fs->icache->cache[i].ino == ino) {
-			memcpy(inode, fs->icache->cache[i].inode, bufsize);
+			memcpy(inode, fs->icache->cache[i].inode,
+			       (bufsize > length) ? length : bufsize);
 			return 0;
 		}
 	}
@@ -649,7 +650,7 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	/* Update the inode cache bookkeeping */
 	fs->icache->cache_last = cache_slot;
 	fs->icache->cache[cache_slot].ino = ino;
-	memcpy(inode, iptr, bufsize);
+	memcpy(inode, iptr, (bufsize > length) ? length : bufsize);
 
 	return 0;
 }
@@ -705,7 +706,7 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		for (i=0; i < fs->icache->cache_size; i++) {
 			if (fs->icache->cache[i].ino == ino) {
 				memcpy(fs->icache->cache[i].inode, inode,
-				       bufsize);
+				       (bufsize > length) ? length : bufsize);
 				break;
 			}
 		}
-- 
1.7.10.4

