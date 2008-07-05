From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 20/52] ext4: Fix ext4_ext_journal_restart() to reflect errors up to the caller
Date: Sat,  5 Jul 2008 13:35:46 -0400
Message-ID: <1215279378-30504-21-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
Cc: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33102 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755990AbYGERgd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:33 -0400
In-Reply-To: <1215279378-30504-20-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Shen Feng <shen@cn.fujitsu.com>

Fix ext4_ext_journal_restart() so it returns any errors reported by
ext4_journal_extend() and ext4_journal_restart().

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3e966da..17ea8bb 100644
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
@@ -1888,11 +1887,9 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
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
1.5.6.rc3.1.g36b7.dirty

