From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/5] ext4: Fix the race between read_block_bitmap and mark_diskspace_used
Date: Thu, 20 Nov 2008 23:56:19 +0530
Message-ID: <1227205580-27596-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:54900 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYKTSbb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Nov 2008 13:31:31 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAKIUfhR020709
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:30:41 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAKIQUgM187996
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:26:30 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAKIQTfX015912
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:26:30 +1100
In-Reply-To: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
index 0a53d1b..6155c94 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1071,6 +1071,8 @@ static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
 	__u32 *addr;
 
 	len = cur + len;
+	if (lock)
+		spin_lock(lock);			\
 	while (cur < len) {
 		if ((cur & 31) == 0 && (len - cur) >= 32) {
 			/* fast path: clear whole word at once */
@@ -1079,9 +1081,11 @@ static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
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
@@ -1089,6 +1093,8 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 	__u32 *addr;
 
 	len = cur + len;
+	if (lock)
+		spin_lock(lock);			\
 	while (cur < len) {
 		if ((cur & 31) == 0 && (len - cur) >= 32) {
 			/* fast path: set whole word at once */
@@ -1097,9 +1103,11 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
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
@@ -3053,10 +3061,9 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		}
 	}
 #endif
-	mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
-				ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
