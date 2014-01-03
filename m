From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 1/2] inode.c: only update the icache for ext2_inode
Date: Fri, 3 Jan 2014 04:15:40 -0500
Message-ID: <1388740541-28123-2-git-send-email-liezhi.yang@windriver.com>
References: <1388740541-28123-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <sgh@sgh.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:35644 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaACJP5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jan 2014 04:15:57 -0500
In-Reply-To: <1388740541-28123-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We read the cache when:

bufsize == sizeof(struct ext2_inode)

so we should update the cache in the same rule, otherwise there would be
errors, for example:

cache[0]: cached ino 14 when bufsize = 128 by ext2fs_write_inode_full()
cache[1]: cached ino 14 when bufsize = 156 by ext2fs_read_inode_full()

Then update the cache:
cache[0]: cached ino 15 when bufsize = 156 by ext2fs_read_inode_full()

And the ino 14 would hit the cache[1] when bufsize = 128 (but it was
cached by bufsize = 156), so there would be errors.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 lib/ext2fs/inode.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 573a8fa..cd85b47 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -614,10 +614,12 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 #endif
 
 	/* Update the inode cache */
-	fs->icache->cache_last = (fs->icache->cache_last + 1) %
-		fs->icache->cache_size;
-	fs->icache->cache[fs->icache->cache_last].ino = ino;
-	fs->icache->cache[fs->icache->cache_last].inode = *inode;
+	if (bufsize == sizeof(struct ext2_inode)) {
+		fs->icache->cache_last = (fs->icache->cache_last + 1) %
+			fs->icache->cache_size;
+		fs->icache->cache[fs->icache->cache_last].ino = ino;
+		fs->icache->cache[fs->icache->cache_last].inode = *inode;
+	}
 
 	return 0;
 }
@@ -650,10 +652,12 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 
 	/* Check to see if the inode cache needs to be updated */
 	if (fs->icache) {
-		for (i=0; i < fs->icache->cache_size; i++) {
-			if (fs->icache->cache[i].ino == ino) {
-				fs->icache->cache[i].inode = *inode;
-				break;
+		if (bufsize == sizeof(struct ext2_inode)) {
+			for (i=0; i < fs->icache->cache_size; i++) {
+				if (fs->icache->cache[i].ino == ino) {
+					fs->icache->cache[i].inode = *inode;
+					break;
+				}
 			}
 		}
 	} else {
-- 
1.7.10.4

