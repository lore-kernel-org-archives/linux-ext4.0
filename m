From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix discard of inode prealloc space with delayed allocation.
Date: Wed, 25 Feb 2009 21:52:02 +0530
Message-ID: <1235578922-7790-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55881 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbZBYQWQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 11:22:16 -0500
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1PGMBEL028612
	for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2009 03:22:11 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n1PGMSJ4422118
	for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2009 03:22:28 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1PGMA30022286
	for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2009 03:22:11 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With delayed allocation we should not/cannot discard inode prealloc space
during file close. We would still have dirty pages for which we haven't allocated
blocks yet. With this fix after each get_blocks request we check whether we have
zero reserved blocks and if yes and we don't have any writers on the file we
discard inode prealloc space.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/file.c  |    9 ++++++++-
 fs/ext4/inode.c |    6 ++++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f731cb5..4e468e2 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -33,9 +33,16 @@
  */
 static int ext4_release_file(struct inode *inode, struct file *filp)
 {
+	int rsv_data_blocks;
+
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+	rsv_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
-			(atomic_read(&inode->i_writecount) == 1))
+			(atomic_read(&inode->i_writecount) == 1) &&
+		        !rsv_data_blocks)
 	{
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_preallocations(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 51cdd13..26dcec4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1038,6 +1038,12 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 	EXT4_I(inode)->i_reserved_data_blocks -= used;
 
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	/*
+	 * If have done all the pending block allocation and if the
+	 * we don't have any writer on the inode
+	 */
+	if (!total && (atomic_read(&inode->i_writecount) == 0))
+		ext4_discard_preallocations(inode);
 }
 
 /*
-- 
tg: (694593e..) fix_prealloc_discard (depends on: master)
