From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v2] ext4: save goal group and offset in struct ext4_allocation_context.ac_g_ex
Date: Mon, 4 Aug 2014 18:39:33 +0800
Message-ID: <1407148773-14886-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <53DF2F76.7060307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <adilger@dilger.ca>, <lczerner@redhat.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24735 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752150AbaHDKks (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 06:40:48 -0400
In-Reply-To: <53DF2F76.7060307@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_mb_normalize_request(), if ac_g_ex.fe_logical is adjacent to the closest logical
allocated block to the left or (ac_g_ex.fe_logical+len) adjacent to the closest logical
allocated block to the right, we'll attach EXT4_MB_HINT_TRY_GOAL flag taking the physical
block (ext4_allocation_request.lleft+1) or (ext4_allocation_request.pright-len) as a goal,
and put this information in ext4_allocation_context.ac_f_ex.

But look at the ext4_mb_find_by_goal(), indeed it uses ac_g_ex to look up, so this is wrong,
we should save goal group and offset in struct ext4_allocation_context.ac_g_ex.

Meanwhile if the group number is invalid(not be between 0 and s_groups_count), we ignore
the EXT4_MB_HINT_TRY_GOAL flag. If we still attach this flag wrongly, we will trigger a
BUG_ON:
----ext4_mb_find_by_goal
--------ext4_get_group_info(BUG_ON(group >= EXT4_SB(sb)->s_groups_count);)

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 fs/ext4/mballoc.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2dcb936..829c12b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3166,18 +3166,27 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 
 	/* define goal start in order to merge */
 	if (ar->pright && (ar->lright == (start + size))) {
-		/* merge to the right */
-		ext4_get_group_no_and_offset(ac->ac_sb, ar->pright - size,
-						&ac->ac_f_ex.fe_group,
-						&ac->ac_f_ex.fe_start);
-		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
+		/* merge to the right, we need to make sure
+		 * 'ar->pright - size' is valid and in a valid group */
+		if (likely(ar->pright >=
+		    (size + le32_to_cpu(sbi->s_es->s_first_data_block)))) {
+			ext4_get_group_no_and_offset(ac->ac_sb,
+						     ar->pright - size,
+						     &ac->ac_g_ex.fe_group,
+						     &ac->ac_g_ex.fe_start);
+			ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
+		}
 	}
 	if (ar->pleft && (ar->lleft + 1 == start)) {
-		/* merge to the left */
-		ext4_get_group_no_and_offset(ac->ac_sb, ar->pleft + 1,
-						&ac->ac_f_ex.fe_group,
-						&ac->ac_f_ex.fe_start);
-		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
+		/* merge to the left, we also need to make sure 'ar->pleft + 1'
+		 * is valid and in a valid group */
+		if (likely((ar->pleft + 1) < ext4_group_first_block_no(
+		    ac->ac_sb, sbi->s_groups_count))) {
+			ext4_get_group_no_and_offset(ac->ac_sb, ar->pleft + 1,
+						&ac->ac_g_ex.fe_group,
+						&ac->ac_g_ex.fe_start);
+			ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
+		}
 	}
 
 	mb_debug(1, "goal: %u(was %u) blocks at %u\n", (unsigned) size,
-- 
1.8.2.1

