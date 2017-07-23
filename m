From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] debugfs: add sanity checking to the string_to_inode() utility function
Date: Sun, 23 Jul 2017 00:50:34 -0400
Message-ID: <20170723045035.26019-4-tytso@mit.edu>
References: <20170723045035.26019-1-tytso@mit.edu>
Cc: abuchbinder@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51414 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750758AbdGWEup (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 00:50:45 -0400
In-Reply-To: <20170723045035.26019-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Otherwise it's possible for a corrupt file system or bad user input to
cause debugfs to crash if the resulting inode number is insanely
large.

This problem was found using American Fuzzy Lop.

Reported-by: Adam Buchbinder <abuchbinder@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 debugfs/util.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/debugfs/util.c b/debugfs/util.c
index bd5de79e4..5f101f48d 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -119,7 +119,7 @@ ext2_ino_t string_to_inode(char *str)
 	 */
 	if ((len > 2) && (str[0] == '<') && (str[len-1] == '>')) {
 		ino = strtoul(str+1, &end, 0);
-		if (*end=='>')
+		if (*end=='>' && (ino <= current_fs->super->s_inodes_count))
 			return ino;
 	}
 
@@ -128,6 +128,11 @@ ext2_ino_t string_to_inode(char *str)
 		com_err(str, retval, 0);
 		return 0;
 	}
+	if (ino > current_fs->super->s_inodes_count) {
+		com_err(str, 0, "resolves to an illegal inode number: %u\n",
+			ino);
+		return 0;
+	}
 	return ino;
 }
 
-- 
2.11.0.rc0.7.gbe5a750
