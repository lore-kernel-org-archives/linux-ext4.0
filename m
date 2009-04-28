From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3] Fix sub-block zeroing for buffered writes into unwritten extents
Date: Wed, 29 Apr 2009 00:20:53 +0530
Message-ID: <1240944653-4328-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:37838 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbZD1SvE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 14:51:04 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3SIn45L013777
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 04:49:04 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3SIp0s9454970
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 04:51:00 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3SIoxVA019025
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 04:51:00 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to mark the  buffer_head mapping prealloc space
as new during write_begin. Otherwise we don't zero out the
page cache content properly for a partial write. This will
cause file corruption with preallocation.

Also use block number -1 as the fake block number so that
unmap_underlying_metadata doesn't drop wrong buffer_head

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/inode.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e91f978..0214389 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2318,11 +2318,20 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 			/* not enough space to reserve */
 			return ret;
 
-		map_bh(bh_result, inode->i_sb, 0);
+		map_bh(bh_result, inode->i_sb, -1);
 		set_buffer_new(bh_result);
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
+		bh_result->b_bdev = inode->i_sb->s_bdev;
+		bh->b_blocknr = -1;
+		/*
+		 * With sub-block writes into unwritten extents
+		 * we also need to mark the buffer as new so that
+		 * the unwritten parts of the buffer gets correctly zeroed.
+		 */
+		if (buffer_unwritten(bh_result))
+			set_buffer_new(bh_result);
 		ret = 0;
 	}
 
-- 
tg: (27b1833..) preallocate_corruption_quickfix (depends on: master)
