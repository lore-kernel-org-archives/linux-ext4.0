From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 10/40] ext4: Fix the NULL reference in double_down_write_data_sem()
Date: Tue,  1 Jun 2010 08:02:57 -0400
Message-ID: <1275393807-14369-10-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47262 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab0FAMDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:33 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akira Fujita <a-fujita@rs.jp.nec.com>

commit 7247c0caa23d94a1cb6b307edba9dc45fb0798d4 upstream (as of v2.6.33-git11)

If EXT4_IOC_MOVE_EXT ioctl is called with NULL donor_fd, fget() in
ext4_ioctl() gets inappropriate file structure for donor; so we need
to do this check earlier, before calling double_down_write_data_sem().

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/move_extent.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index b2b2e67..379c0c0 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -953,14 +953,6 @@ mext_check_arguments(struct inode *orig_inode,
 	unsigned int blkbits = orig_inode->i_blkbits;
 	unsigned int blocksize = 1 << blkbits;
 
-	/* Regular file check */
-	if (!S_ISREG(orig_inode->i_mode) || !S_ISREG(donor_inode->i_mode)) {
-		ext4_debug("ext4 move extent: The argument files should be "
-			"regular file [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
-		return -EINVAL;
-	}
