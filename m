From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: COLLAPSE_RANGE only works on extent-based files
Date: Sat, 12 Apr 2014 22:54:05 -0400
Message-ID: <1397357645-31511-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53387 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaDMCyO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 22:54:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Unfortunately, we weren't checking to make sure of this the inode was
extent-based before attempt operate on it.  Hilarity ensues.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/ext4/extents.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f24ef86..96e0a4b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4878,9 +4878,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return ext4_punch_hole(inode, offset, len);
 
-	if (mode & FALLOC_FL_COLLAPSE_RANGE)
-		return ext4_collapse_range(inode, offset, len);
