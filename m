From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH] ext4: Fix compile error at defrag.c in the current ext4 patch
 queue
Date: Tue, 30 Sep 2008 17:35:33 +0900
Message-ID: <48E1E4D5.7020706@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33039 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYI3IgD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2008 04:36:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

The following compile error occurs at defrag.c in the current ext4 patch queue (2.6.27-rc6),
because mballoc has become default and some functions related to
the block allocation have been renamed.  This patch fixes this inconsistency.

Note:
ext4_check_defrag() originally checks the length of extents
in the force defrag (-f), but "defrag-10-add-ioc-move-victim-ioctl"
in the ext4 patch queue is commented out, so that it just returns 0.
I'll update ext4_check_defrag() correctly in the next version.

  CC      fs/ext4/defrag.o
fs/ext4/defrag.c: In function ‘ext4_defrag_check’:
fs/ext4/defrag.c:1162: error: ‘EXT4_MOUNT_MBALLOC’ undeclared (first use in this function)
fs/ext4/defrag.c:1162: error: (Each undeclared identifier is reported only once
fs/ext4/defrag.c:1162: error: for each function it appears in.)
fs/ext4/defrag.c: In function ‘ext4_defrag’:
fs/ext4/defrag.c:1427: error: implicit declaration of function ‘ext4_mb_discard_inode_preallocations’

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/defrag.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)
diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index cb7d237..6364d10 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -1158,13 +1158,6 @@ static int
 ext4_defrag_check(struct inode *org_inode, ext4_lblk_t defrag_size,
 		ext4_fsblk_t *goal)
 {
-	/* ext4 online defrag needs mballoc mount option. */
-	if (!test_opt(org_inode->i_sb, MBALLOC)) {
-		printk(KERN_ERR "ext4 defrag: multiblock allocation "
-				"is disabled\n");
-		return -EOPNOTSUPP;
-	}
