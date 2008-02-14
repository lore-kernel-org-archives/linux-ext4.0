From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC/PATCH] ext4: Request for journal write access early.
Date: Thu, 14 Feb 2008 16:00:52 +0530
Message-ID: <1202985052-15694-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1202985052-15694-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:51226 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbYBNKbx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2008 05:31:53 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1EAW6L8002502
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 21:32:06 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1EAZTuo235920
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 21:35:29 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1EAVpQ7006255
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 21:31:51 +1100
In-Reply-To: <1202985052-15694-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_ext_convert_to_initialized before we need to request for journal
write access before we even modify the extent length.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 995ac16..c4d6f19 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2168,6 +2168,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	newblock = iblock - ee_block + ext_pblock(ex);
 	ex2 = ex;
 
+	err = ext4_ext_get_access(handle, inode, path + depth);
+	if (err)
+		goto out;
+
 	/* ex1: ee_block to iblock - 1 : uninitialized */
 	if (iblock > ee_block) {
 		ex1 = ex;
@@ -2210,6 +2214,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ex = path[depth].p_ext;
 			if (ex2 != &newex)
 				ex2 = ex;
+
+			err = ext4_ext_get_access(handle, inode, path + depth);
+			if (err)
+				goto out;
 		}
 		allocated = max_blocks;
 	}
@@ -2230,9 +2238,6 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	ex2->ee_len = cpu_to_le16(allocated);
 	if (ex2 != ex)
 		goto insert;
-	err = ext4_ext_get_access(handle, inode, path + depth);
-	if (err)
-		goto out;
 	/*
 	 * New (initialized) extent starts from the first block
 	 * in the current extent. i.e., ex2 == ex
-- 
1.5.4.1.97.g40aab-dirty
