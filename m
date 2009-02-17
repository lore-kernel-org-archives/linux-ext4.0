From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.27 13/24] ext4: Fix race between read_block_bitmap() and mark_diskspace_used()
Date: Tue, 17 Feb 2009 10:58:33 -0500
Message-ID: <1234886324-15105-14-git-send-email-tytso@mit.edu>
References: <1234886324-15105-1-git-send-email-tytso@mit.edu>
 <1234886324-15105-2-git-send-email-tytso@mit.edu>
 <1234886324-15105-3-git-send-email-tytso@mit.edu>
 <1234886324-15105-4-git-send-email-tytso@mit.edu>
 <1234886324-15105-5-git-send-email-tytso@mit.edu>
 <1234886324-15105-6-git-send-email-tytso@mit.edu>
 <1234886324-15105-7-git-send-email-tytso@mit.edu>
 <1234886324-15105-8-git-send-email-tytso@mit.edu>
 <1234886324-15105-9-git-send-email-tytso@mit.edu>
 <1234886324-15105-10-git-send-email-tytso@mit.edu>
 <1234886324-15105-11-git-send-email-tytso@mit.edu>
 <1234886324-15105-12-git-send-email-tytso@mit.edu>
 <1234886324-15105-13-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33293 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZBQQNG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:13:06 -0500
In-Reply-To: <1234886324-15105-13-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We need to make sure we update the block bitmap and clear
EXT4_BG_BLOCK_UNINIT flag with sb_bgl_lock held, since
ext4_read_block_bitmap() looks at EXT4_BG_BLOCK_UNINIT to decide
whether to initialize the block bitmap each time it is called
(introduced by commit c806e68f), and this can race with block
allocations in ext4_mb_mark_diskspace_used().

ext4_read_block_bitmap does:

spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
	ext4_init_block_bitmap(sb, bh, block_group, desc);

Now on the block allocation side we do

mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
			ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
....
spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
	gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);

ie on allocation we update the bitmap then we take the sb_bgl_lock
and clear the EXT4_BG_BLOCK_UNINIT flag. What can happen is a
parallel ext4_read_block_bitmap can zero out the bitmap in between
the above mb_set_bits and spin_lock(sb_bg_lock..)

The race results in below user visible errors
EXT4-fs error (device sdb1): ext4_mb_release_inode_pa: free 100, pa_free 105
EXT4-fs error (device sdb1): mb_free_blocks: double-free of inode 0's block ..

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
(cherry picked from commit e8134b27e351e813414da3b95aa8eac6d3908088)
---
 fs/ext4/mballoc.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d82b86e..f96b18e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1070,7 +1070,10 @@ static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		mb_clear_bit_atomic(lock, cur, bm);
+		if (lock)
+			mb_clear_bit_atomic(lock, cur, bm);
+		else
+			mb_clear_bit(cur, bm);
 		cur++;
 	}
 }
@@ -1088,7 +1091,10 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		mb_set_bit_atomic(lock, cur, bm);
+		if (lock)
+			mb_set_bit_atomic(lock, cur, bm);
+		else
+			mb_set_bit(cur, bm);
 		cur++;
 	}
 }
@@ -3143,10 +3149,9 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		}
 	}
 #endif
-	mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
-				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
