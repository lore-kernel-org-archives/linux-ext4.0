From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2] ext4: Update i_disksize properly when allocating from fallocate area.
Date: Mon,  9 Jun 2008 15:33:04 +0530
Message-ID: <1213005784-10539-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1213005784-10539-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:60000 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758958AbYFIKDU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jun 2008 06:03:20 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m59A35os011676
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2008 15:33:05 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m59A2nht1339412
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2008 15:32:49 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m59A34rZ019705
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2008 15:33:04 +0530
In-Reply-To: <1213005784-10539-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When allocating blocks from an falloc area which was initialized with
FALLOC_FL_KEEP_SIZE we need to extent disksize.

These changes are for code correctness. We do update the i_disksize
in the write_end callback of filesystem properly.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 27cfd30..362211c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2885,7 +2885,10 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 					ext4_ext_get_actual_len(&newex), 0);
 		goto out2;
 	}
-
+	/* previous routine could use block we allocated */
+	newblock = ext_pblock(&newex);
+	allocated = ext4_ext_get_actual_len(&newex);
+outnew:
 	if (extend_disksize) {
 		disksize = ((loff_t) iblock + ar.len) << inode->i_blkbits;
 		if (disksize > i_size_read(inode))
@@ -2893,11 +2896,6 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		if (disksize > EXT4_I(inode)->i_disksize)
 			EXT4_I(inode)->i_disksize = disksize;
 	}
