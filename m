From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 03/53] ext4: replace BUG() with return -EIO in ext4_ext_get_blocks
Date: Sun, 30 May 2010 22:49:16 -0400
Message-ID: <1275274206-3900-3-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Surbhi Palande <surbhi.palande@canonical.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44554 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab0EaCuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:14 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Surbhi Palande <surbhi.palande@canonical.com>

commit 034fb4c95fc0fed4ec4a50778127b92c6f2aec01 upstream (as of v2.6.33-rc3)

This patch fixes the Kernel BZ #14286.  When the address of an extent
corresponding to a valid block is corrupted, a -EIO should be reported
instead of a BUG().  This situation should not normally not occur
except in the case of a corrupted filesystem.  If however it does,
then the system should not panic directly but depending on the mount
time options appropriate action should be taken. If the mount options
so permit, the I/O should be gracefully aborted by returning a -EIO.

http://bugzilla.kernel.org/show_bug.cgi?id=14286

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9e21653..f2effe4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3196,7 +3196,13 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	 * this situation is possible, though, _during_ tree modification;
 	 * this is why assert can't be put in ext4_ext_find_extent()
 	 */
-	BUG_ON(path[depth].p_ext == NULL && depth != 0);
+	if (path[depth].p_ext == NULL && depth != 0) {
+		ext4_error(inode->i_sb, __func__, "bad extent address "
+			   "inode: %lu, iblock: %d, depth: %d",
+			   inode->i_ino, iblock, depth);
+		err = -EIO;
+		goto out2;
+	}
 	eh = path[depth].p_hdr;
 
 	ex = path[depth].p_ext;
-- 
1.6.6.1.1.g974db.dirty

