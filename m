From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.28 19/24] ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc
Date: Tue, 17 Feb 2009 10:32:37 -0500
Message-ID: <1234884762-13580-20-git-send-email-tytso@mit.edu>
References: <1234884762-13580-1-git-send-email-tytso@mit.edu>
 <1234884762-13580-2-git-send-email-tytso@mit.edu>
 <1234884762-13580-3-git-send-email-tytso@mit.edu>
 <1234884762-13580-4-git-send-email-tytso@mit.edu>
 <1234884762-13580-5-git-send-email-tytso@mit.edu>
 <1234884762-13580-6-git-send-email-tytso@mit.edu>
 <1234884762-13580-7-git-send-email-tytso@mit.edu>
 <1234884762-13580-8-git-send-email-tytso@mit.edu>
 <1234884762-13580-9-git-send-email-tytso@mit.edu>
 <1234884762-13580-10-git-send-email-tytso@mit.edu>
 <1234884762-13580-11-git-send-email-tytso@mit.edu>
 <1234884762-13580-12-git-send-email-tytso@mit.edu>
 <1234884762-13580-13-git-send-email-tytso@mit.edu>
 <1234884762-13580-14-git-send-email-tytso@mit.edu>
 <1234884762-13580-15-git-send-email-tytso@mit.edu>
 <1234884762-13580-16-git-send-email-tytso@mit.edu>
 <1234884762-13580-17-git-send-email-tytso@mit.edu>
 <1234884762-13580-18-git-send-email-tytso@mit.edu>
 <1234884762-13580-19-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33271 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbZBQQLY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:11:24 -0500
In-Reply-To: <1234884762-13580-19-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

With nodelalloc option we need to update the dirty block counter on
block allocation failure. This is needed because we increment the
dirty block counter early in the block allocation phase. Without
the patch s_dirty_blocks_counter goes wrong so that filesystem's
free blocks decreases incorrectly.

Tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
(cherry picked from commit 0087d9fb3f29f59e8d42c8b058376d80e5adde4c)
---
 fs/ext4/mballoc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8d7f8a1..775ef32 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4538,7 +4538,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	}
 	if (ar->len == 0) {
 		*errp = -EDQUOT;
-		return 0;
+		goto out3;
 	}
 	inquota = ar->len;
 
@@ -4611,6 +4611,13 @@ out2:
 out1:
 	if (ar->len < inquota)
 		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
+out3:
+	if (!ar->len) {
+		if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
+			/* release all the reserved blocks if non delalloc */
+			percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+						reserv_blks);
+	}
 
 	return block;
 }
-- 
1.5.6.3

