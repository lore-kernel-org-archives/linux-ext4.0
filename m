From: Lin Feng <linf@chinanetcenter.com>
Subject: [PATCH] ext4: mballoc.c: fix ac_g_ex and ac_f_ex misuse bug in EXT4_MB_HINT_TRY_GOAL path
Date: Thu,  2 Jun 2016 20:01:38 +0800
Message-ID: <1464868898-31336-1-git-send-email-linf@chinanetcenter.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lin Feng <linf@chinanetcenter.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Descriptions:
ext4 block allocation core stack:
ext4_mb_new_blocks
  ext4_mb_normalize_request
  ext4_mb_regular_allocator
    ext4_mb_find_by_goal
      mb_find_extent(e4b, ac->ac_g_ex.fe_start, ac->ac_g_ex.fe_len, &ex);

The start block searching hint for merging(use EXT4_MB_HINT_TRY_GOAL flag)
set in ext4_mb_normalize_request is stored in ac_f_ex, while in 
EXT4_MB_HINT_TRY_GOAL path which falls in ext4_mb_find_by_goal always use
ac_g_ex as a hint and the hint set in ext4_mb_normalize_request is never
use.

We could hit this bug by writing a sparse file from backward mode and the
file may get fragments even if the physical blocks in the hole is free,
which is expected to be merged into a single extent.

Signed-off-by: Lin Feng <linf@chinanetcenter.com>
---
 fs/ext4/mballoc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c1ab3ec..e31fc63 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3198,15 +3198,15 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	if (ar->pright && (ar->lright == (start + size))) {
 		/* merge to the right */
 		ext4_get_group_no_and_offset(ac->ac_sb, ar->pright - size,
-						&ac->ac_f_ex.fe_group,
-						&ac->ac_f_ex.fe_start);
+						&ac->ac_g_ex.fe_group,
+						&ac->ac_g_ex.fe_start);
 		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
 	}
 	if (ar->pleft && (ar->lleft + 1 == start)) {
 		/* merge to the left */
 		ext4_get_group_no_and_offset(ac->ac_sb, ar->pleft + 1,
-						&ac->ac_f_ex.fe_group,
-						&ac->ac_f_ex.fe_start);
+						&ac->ac_g_ex.fe_group,
+						&ac->ac_g_ex.fe_start);
 		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
 	}
 
-- 
1.9.3
