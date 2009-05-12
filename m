From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V5] ext4: Use -1 as the fake block number for delayed new
	buffer_head
Date: Tue, 12 May 2009 20:47:54 +0530
Message-ID: <20090512151754.GC23862@skywalker>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240980441-8105-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:53674 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZELPSG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 11:18:06 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id n4CFI59o009955
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 20:48:05 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4CFI45V585950
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 20:48:04 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id n4CFI4NY024737
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2009 01:18:04 +1000
Content-Disposition: inline
In-Reply-To: <1240980441-8105-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


ext4: Use a fake block number for delayed new buffer_head

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Use a very large unsigned number (~0xffff) as as the fake block number
for the delayed new buffer. The VFS should never try to write out this
number, but if it does, this will make it obvious.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 498cf8b..4b1478c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2297,6 +2297,10 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 				  struct buffer_head *bh_result, int create)
 {
 	int ret = 0;
+	sector_t invalid_block = ~((sector_t) 0xffff);
+
+	if (invalid_block < ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es))
+		invalid_block = ~0;
 
 	BUG_ON(create == 0);
 	BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
@@ -2318,7 +2322,7 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 			/* not enough space to reserve */
 			return ret;
 
-		map_bh(bh_result, inode->i_sb, 0);
+		map_bh(bh_result, inode->i_sb, invalid_block);
 		set_buffer_new(bh_result);
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
