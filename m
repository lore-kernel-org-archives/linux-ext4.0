From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: When reading from fallocated blocks make sure we return zero.
Date: Fri, 15 Feb 2008 23:46:54 +0530
Message-ID: <1203099414-8815-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:52103 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbYBOSQ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2008 13:16:59 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1FIHCGB030925
	for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 05:17:12 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1FIGv8g3551364
	for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 05:16:57 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1FIGvK7021439
	for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 05:16:57 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fallocate blocks are considered as sparse area and read from them should
return zero. ext4_ext_get_blocks should return zero for read request.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3efbfd1..5b22f71 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2379,8 +2379,14 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			}
 			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
 				goto out;
-			if (!create)
+			if (!create) {
+				/*
+				 * read request should return zero blocks
+				 * allocated
+				 */
+				allocated = 0;
 				goto out2;
+			}
 
 			ret = ext4_ext_convert_to_initialized(handle, inode,
 								path, iblock,
-- 
1.5.4.1.97.g40aab-dirty
