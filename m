From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4 1/2] Fix sub-block zeroing for buffered writes into unwritten extents
Date: Wed, 29 Apr 2009 10:17:20 +0530
Message-ID: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59123 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZD2Er1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 00:47:27 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3T4lMe3030526
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 14:47:22 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3T4lQRJ1544298
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 14:47:26 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3T4lPhw024733
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 14:47:26 +1000
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
 fs/ext4/inode.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e91f978..12dcfab 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2323,6 +2323,16 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
+		/*
+		 * With sub-block writes into unwritten extents
+		 * we also need to mark the buffer as new so that
+		 * the unwritten parts of the buffer gets correctly zeroed.
+		 */
+		if (buffer_unwritten(bh_result)) {
+			bh_result->b_bdev = inode->i_sb->s_bdev;
+			set_buffer_new(bh_result);
+			bh_result->b_blocknr = -1;
+		}
 		ret = 0;
 	}
 
-- 
tg: (56a50ad..) preallocate_corruption_quickfix (depends on: master)
