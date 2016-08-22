From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH RESEND] ext4: reinforce check of i_dtime when clearing high
 fields of uid and gid
Date: Mon, 22 Aug 2016 14:51:25 +0900
Message-ID: <1471845085-9590-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>,
        Hobin Woo <hobin.woo@samsung.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:60589 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750867AbcHVFuq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Aug 2016 01:50:46 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0OCA00N9LQWKAO30@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Mon, 22 Aug 2016 14:50:44 +0900 (KST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now, ext4_do_update_inode() clears high 16-bit fields of uid/gid
of deleted and evicted inode to fix up interoperability with old
kernels. However, it checks only i_dtime of an inode to determine
whether the inode was deleted and evicted, and this is very risky,
because i_dtime can be used for the pointer maintaining orphan inode
list, too. We need to further check whether the i_dtime is being
used for the orphan inode list even if the i_dtime is not NULL.

We found that high 16-bit fields of uid/gid of inode are unintentionally
and permanently cleared when the inode truncation is just triggered,
but not finished, and the inode metadata, whose high uid/gid bits are
cleared, is written on disk, and the sudden power-off follows that
in order.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
---
 fs/ext4/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f7140ca..bb5aede 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4785,14 +4785,14 @@ static int ext4_do_update_inode(handle_t *handle,
  * Fix up interoperability with old kernels. Otherwise, old inodes get
  * re-used with the upper 16 bits of the uid/gid intact
  */
-		if (!ei->i_dtime) {
+		if (ei->i_dtime && list_empty(&ei->i_orphan)) {
+			raw_inode->i_uid_high = 0;
+			raw_inode->i_gid_high = 0;
+		} else {
 			raw_inode->i_uid_high =
 				cpu_to_le16(high_16_bits(i_uid));
 			raw_inode->i_gid_high =
 				cpu_to_le16(high_16_bits(i_gid));
-		} else {
-			raw_inode->i_uid_high = 0;
-			raw_inode->i_gid_high = 0;
 		}
 	} else {
 		raw_inode->i_uid_low = cpu_to_le16(fs_high2lowuid(i_uid));
-- 
1.7.9.5

