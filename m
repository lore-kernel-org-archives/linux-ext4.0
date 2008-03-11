From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext3: Return EIO if new block allocation returns block from system zone.
Date: Tue, 11 Mar 2008 14:57:19 +0530
Message-ID: <1205227639-14706-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37441 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYCKJ20 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2008 05:28:26 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2B9S8I9002077
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 20:28:08 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2B9W3pr289212
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 20:32:03 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2B9S85C020541
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 20:28:26 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the block allocator gets blocks out of system zone ext3 calls
ext3_error. But if the file system is mounted with errors=continue
return with -EIO.

System zone is the block range mapping block bitmap, inode bitmap and inode
table.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext3/balloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index da0cb2c..6ce7f7d 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1642,7 +1642,7 @@ allocated:
 			    "Allocating block in system zone - "
 			    "blocks from "E3FSBLK", length %lu",
 			     ret_block, num);
-		goto out;
+		goto io_error;
 	}
 
 	performed_allocation = 1;
-- 
1.5.4.4.481.g5075.dirty

