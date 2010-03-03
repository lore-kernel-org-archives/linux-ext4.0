From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 2/3] ext4: Fix the NULL reference in double_down_write_data_sem()
Date: Wed, 03 Mar 2010 15:49:37 +0900
Message-ID: <4B8E0681.10102@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57247 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0CCGu4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Mar 2010 01:50:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix the NULL reference in double_down_write_data_sem()

From: Akira Fujita <a-fujita@rs.jp.nec.com>

If EXT4_IOC_MOVE_EXT ioctl is called with NULL donor_fd,
fget() in ext4_ioctl() gets inappropriate file structure for donor.
Therefore the NULL reference occurs in double_down_write_data_sem().

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
  fs/ext4/move_extent.c |   16 ++++++++--------
  1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 9eca1c0..7e99f4e 100644
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
