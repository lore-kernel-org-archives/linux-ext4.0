From: Shen Feng <shen@cn.fujitsu.com>
Subject: [Fwd: [PATCH 2/5] ext4: Change the return value of ext4_ext_journal_restart]
Date: Wed, 11 Jun 2008 13:56:29 +0800
Message-ID: <484F690D.9090004@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Theodore Tso <tytso@MIT.EDU>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51814 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYFKF74 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 01:59:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


ext4_ext_journal_restart does not return the return value
of ext4_journal_extend and ext4_journal_restart.
Fix it.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/extents.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index fa8a578..d4f76d7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -92,17 +92,16 @@ static void ext4_idx_store_pblock(struct ext4_extent_idx *ix, ext4_fsblk_t pb)
 	ix->ei_leaf_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }
 
-static handle_t *ext4_ext_journal_restart(handle_t *handle, int needed)
+static int ext4_ext_journal_restart(handle_t *handle, int needed)
 {
 	int err;
 
 	if (handle->h_buffer_credits > needed)
-		return handle;
-	if (!ext4_journal_extend(handle, needed))
-		return handle;
-	err = ext4_journal_restart(handle, needed);
-
-	return handle;
+		return 0;
+	err = ext4_journal_extend(handle, needed);
+	if (err)
+		return err;
+	return ext4_journal_restart(handle, needed);
 }
 
 /*
@@ -1885,11 +1884,9 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		credits += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
 #endif
 
-		handle = ext4_ext_journal_restart(handle, credits);
-		if (IS_ERR(handle)) {
-			err = PTR_ERR(handle);
+		err = ext4_ext_journal_restart(handle, credits);
+		if (err)
 			goto out;
-		}
 
 		err = ext4_ext_get_access(handle, inode, path + depth);
 		if (err)
-- 
1.5.4.5


