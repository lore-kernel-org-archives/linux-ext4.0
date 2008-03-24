From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext3: Return EIO if new block is allocated from system zone.
Date: Mon, 24 Mar 2008 22:34:55 +0530
Message-ID: <1206378298-10341-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.vnet.ibm.com>
To: cmm@us.ibm.com, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:60643 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbYCXRFK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 13:05:10 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2OH5s51014110
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 04:05:54 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2OH52TT4255982
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 04:05:02 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2OH515L001772
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 04:05:02 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the block allocator gets blocks out of system zone ext3 calls
ext3_error. But if the file system is mounted with errors=continue
return with -EIO.

System zone is the block range mapping block bitmap, inode bitmap and inode
table.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.vnet.ibm.com>
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
1.5.5.rc0.16.g02b00.dirty

