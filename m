From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] resize2fs: sanity check the free blocks and inode counts
Date: Sun, 23 Jul 2017 00:50:35 -0400
Message-ID: <20170723045035.26019-5-tytso@mit.edu>
References: <20170723045035.26019-1-tytso@mit.edu>
Cc: abuchbinder@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51418 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750815AbdGWEup (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 00:50:45 -0400
In-Reply-To: <20170723045035.26019-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the free block or free inodes count are larger than the number of
blocks or inodes in the system, request that the file system be
checked.  Otherwise it's possible for calcuate_minimum_resize_size()
to hang in an infinite loop.

This problem was found using American Fuzzy Lop.

Reported-by: Adam Buchbinder <abuchbinder@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 resize/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/resize/main.c b/resize/main.c
index 396391b68..ab7375c17 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -440,6 +440,10 @@ int main (int argc, char ** argv)
 		    !print_min_size)
 			checkit = 1;
 
+		if ((fs->super->s_free_blocks_count > fs->super->s_blocks_count) ||
+		    (fs->super->s_free_inodes_count > fs->super->s_inodes_count))
+			checkit = 1;
+
 		if (checkit) {
 			fprintf(stderr,
 				_("Please run 'e2fsck -f %s' first.\n\n"),
-- 
2.11.0.rc0.7.gbe5a750
