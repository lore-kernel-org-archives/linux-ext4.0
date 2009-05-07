From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ext4: Clear the unwritten buffer_head flag properly
Date: Thu,  7 May 2009 16:09:29 +0530
Message-ID: <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53274 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZEGKjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 May 2009 06:39:41 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id n47AbhlP029211
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:37:43 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n47AdftT1450036
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:39:41 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n47AdedB008717
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:39:41 +1000
In-Reply-To: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_get_blocks_wrap does a block lookup requesting to
allocate new blocks. A lookup of blocks in prealloc area
result in setting the unwritten flag in buffer_head. So
a write to an unwritten extent will cause the buffer_head
to have unwritten and mapped flag set. Clear hte unwritten
buffer_head flag before requesting to allocate blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c3cd00f..f6d7e9b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1149,6 +1149,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 	int retval;
 
 	clear_buffer_mapped(bh);
+	clear_buffer_unwritten(bh);
 
 	/*
 	 * Try to see if we can get  the block without requesting
@@ -1179,6 +1180,12 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 		return retval;
 
 	/*
+	 * The above get_blocks can cause the buffer to be
+	 * marked unwritten. So clear the same.
+	 */
+	clear_buffer_unwritten(bh);
+
+	/*
 	 * New blocks allocate and/or writing to uninitialized extent
 	 * will possibly result in updating i_data, so we take
 	 * the write lock of i_data_sem, and call get_blocks()
-- 
1.6.3.rc4

