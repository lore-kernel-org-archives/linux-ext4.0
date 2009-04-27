From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] mark buffer_head mapping preallocate area as new during write_begin with delayed allocation
Date: Tue, 28 Apr 2009 00:35:43 +0530
Message-ID: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:38277 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048AbZD0TFt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Apr 2009 15:05:49 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id n3RJ5l1L028751
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 00:35:47 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3RJ5kaa475336
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 00:35:46 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n3RJ5kKv008774
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 00:35:46 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to mark the  buffer_head mapping prealloc space
as new during write_begin. Otherwise we don't zero out the
page cache content properly for a partial write. This will
cause file corruption with preallocation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c6bd6ce..c7251ec 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2323,6 +2323,8 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
+		if (buffer_unwritten(bh_result))
+			set_buffer_new(bh_result);
 		ret = 0;
 	}
 
-- 
tg: (51bec03..) preallocate_corruption (depends on: ext4_lock_group_conversion)
