From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3] ext4: Fix race between read_block_bitmap() and mark_diskspace_used()
Date: Tue, 25 Nov 2008 22:02:18 +0530
Message-ID: <1227630738-17572-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44390 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYKYQiz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 11:38:55 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAPGbvsD017244
	for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 03:37:57 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAPGWV2I197300
	for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 03:32:31 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAPGWVJA013121
	for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 03:32:31 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to make sure we update the block bitmap and clear
EXT4_BG_BLOCK_UNINIT flag with sb_bgl_lock held.  We look at
EXT4_BG_BLOCK_UNINIT and reinit the block bitmap each time in
ext4_read_block_bitmap (introduced by commit c806e68f), and this can
race with block allocations in ext4_mb_mark_diskspace_used().

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

FILENAME: fix-race-between-read_block_bitmap-and-mark_diskspace_used

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7b5e968..aa03716 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1073,7 +1073,10 @@ static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
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
@@ -1091,7 +1094,10 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
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
@@ -2991,10 +2997,9 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		}
 	}
 #endif
-	mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
-				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
