From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap and mark_diskspace_used
Date: Fri, 21 Nov 2008 22:14:33 +0530
Message-ID: <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:50661 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564AbYKUQou (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 11:44:50 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id mALGii53006227
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 22:14:44 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mALGihZH4350068
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 22:14:44 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id mALGigwE015337
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 03:44:42 +1100
In-Reply-To: <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to make sure we update the block bitmap and clear
EXT4_BG_BLOCK_UNINIT flag with sb_bgl_lock held. We look
at EXT4_BG_BLOCK_UNINIT and reinit the block bitmap each
time in ext4_read_block_bitmap (introduced by
c806e68f5647109350ec546fee5b526962970fd2 )

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c5dcdf0..1ed949c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1065,6 +1065,8 @@ static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
 	__u32 *addr;
 
 	len = cur + len;
+	if (lock)
+		spin_lock(lock);			\
 	while (cur < len) {
 		if ((cur & 31) == 0 && (len - cur) >= 32) {
 			/* fast path: clear whole word at once */
@@ -1073,9 +1075,11 @@ static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		mb_clear_bit_atomic(lock, cur, bm);
+		mb_clear_bit(cur, bm);
 		cur++;
 	}
+	if (lock)
+		spin_unlock(lock);			\
 }
 
 static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
@@ -1083,6 +1087,8 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 	__u32 *addr;
 
 	len = cur + len;
+	if (lock)
+		spin_lock(lock);			\
 	while (cur < len) {
 		if ((cur & 31) == 0 && (len - cur) >= 32) {
 			/* fast path: set whole word at once */
@@ -1091,9 +1097,11 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 			cur += 32;
 			continue;
 		}
-		mb_set_bit_atomic(lock, cur, bm);
+		mb_set_bit(cur, bm);
 		cur++;
 	}
+	if (lock)
+		spin_unlock(lock);			\
 }
 
 static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
@@ -3004,10 +3012,9 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		}
 	}
 #endif
-	mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
-				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
