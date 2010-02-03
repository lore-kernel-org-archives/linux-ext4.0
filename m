From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4: fix delalloc retry loop logic v2
Date: Wed, 03 Feb 2010 22:07:03 +0300
Message-ID: <87sk9irve0.fsf@openvz.org>
References: <87zl3qrwnx.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:57302 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab0BCTHH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Feb 2010 14:07:07 -0500
Received: by fxm7 with SMTP id 7so1943393fxm.28
        for <linux-ext4@vger.kernel.org>; Wed, 03 Feb 2010 11:07:05 -0800 (PST)
In-Reply-To: <87zl3qrwnx.fsf@openvz.org> (Dmitry Monakhov's message of "Wed,
	03 Feb 2010 21:39:30 +0300")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> Theodore please review this patch ASAP, currently ext4+quota is 
> fatally broken due to your patch. Christmas holidays when you
> submit your patch is not good time for good review, IMHO
> i was too lazy to review it carefully.
> Testcase is trivial it is enough just hit a quota barrier.
> dmon$ set-quota-limit /mnt id=dmon --bsoft=1000 --bsoft=1000
> dmon$ dd if=/dev/zefo of=/mnt/file 
>
> kernel BUG at fs/jbd2/transaction.c:1027!
OOps, i'm sorry. seems that i've send wrong patch version
the only difference is follows:
-	dqretry = (ret == -EDQUOT) || EXT4_I(inode)->i_reserved_meta_blocks;
+	dqretry = (ret == -EDQUOT) && EXT4_I(inode)->i_reserved_meta_blocks;
Correct version attached.

--=-=-=
Content-Disposition: inline;
 filename=0002-ext4-fix-delalloc-retry-loop-logic-v2.patch

>From 3dd53f88470fdc4ec3f06da34cfc760fa8359be8 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Wed, 3 Feb 2010 22:03:17 +0300
Subject: [PATCH 2/2] ext4: fix delalloc retry loop logic -v2

Current delalloc write path is broken:
ext4_da_write_begin()
  ext4_journal_start(inode, 1);  -> current->journal != NULL
  block_write_begin
    ext4_da_get_block_prep()
      ext4_da_reserve_space()
        ext4_should_retry_alloc() -> deadlock
	write_inode_now() -> BUG_ON due to lack of journal credits

Bug was partly introduced by following commit:
  0637c6f4135f592f094207c7c21e7c0fc5557834
  ext4: Patch up how we claim metadata blocks for quota purposes
In order to preserve retry logic and eliminate bugs we have to
move retry loop to ext4_da_write_begin()

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |   41 ++++++++++++++++++-----------------------
 1 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2d3fe4d..bd9e573 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1815,7 +1815,6 @@ static int ext4_journalled_write_end(struct file *file,
  */
 static int ext4_da_reserve_space(struct inode *inode, sector_t lblock)
 {
-	int retries = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned long md_needed, md_reserved;
@@ -1825,7 +1824,6 @@ static int ext4_da_reserve_space(struct inode *inode, sector_t lblock)
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
-repeat:
 	spin_lock(&ei->i_block_reservation_lock);
 	md_reserved = ei->i_reserved_meta_blocks;
 	md_needed = ext4_calc_metadata_amount(inode, lblock);
@@ -1836,27 +1834,11 @@ repeat:
 	 * later. Real quota accounting is done at pages writeout
 	 * time.
 	 */
-	if (vfs_dq_reserve_block(inode, md_needed + 1)) {
-		/* 
-		 * We tend to badly over-estimate the amount of
-		 * metadata blocks which are needed, so if we have
-		 * reserved any metadata blocks, try to force out the
-		 * inode and see if we have any better luck.
-		 */
-		if (md_reserved && retries++ <= 3)
-			goto retry;
+	if (vfs_dq_reserve_block(inode, md_needed + 1))
 		return -EDQUOT;
-	}
 
 	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
 		vfs_dq_release_reservation_block(inode, md_needed + 1);
-		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-		retry:
-			if (md_reserved)
-				write_inode_now(inode, (retries == 3));
-			yield();
-			goto repeat;
-		}
 		return -ENOSPC;
 	}
 	spin_lock(&ei->i_block_reservation_lock);
@@ -3033,7 +3015,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
 {
-	int ret, retries = 0;
+	int ret, dqretry, retries = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
@@ -3090,9 +3072,22 @@ retry:
 			ext4_truncate_failed_write(inode);
 	}
 
-	if (!(flags & EXT4_AOP_FLAG_NORETRY) &&
-		ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-		goto retry;
+	dqretry = (ret == -EDQUOT) && EXT4_I(inode)->i_reserved_meta_blocks;
+	if ( !(flags & EXT4_AOP_FLAG_NORETRY) &&
+		(ret == -ENOSPC || dqretry) &&
+		ext4_should_retry_alloc(inode->i_sb, &retries)) {
+		if (dqretry) {
+			/*
+			 * We tend to badly over-estimate the amount of
+			 * metadata blocks which are needed, so if we have
+			 * reserved any metadata blocks, try to force out the
+			 * inode and see if we have any better luck.
+			 */
+			write_inode_now(inode, (retries == 3));
+		}
+		yield();
+ 		goto retry;
+	}
 out:
 	return ret;
 }
-- 
1.6.3.3


--=-=-=--
