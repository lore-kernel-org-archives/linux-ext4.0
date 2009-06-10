From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Properly mark the extent uninitialized during truncate
Date: Wed, 10 Jun 2009 18:25:57 +0530
Message-ID: <1244638557-13492-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38198 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbZFJM4D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2009 08:56:03 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp09.au.ibm.com (8.13.1/8.13.1) with ESMTP id n5AMpWwE028064
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2009 08:51:32 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5ACu4lY729094
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 22:56:04 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5ACu39H004927
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 22:56:04 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should make sure we don't mark the non uninit extent as
uninit during truncate

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f2a2591..764c394 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2083,12 +2083,16 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	ex = EXT_LAST_EXTENT(eh);
 
 	ex_ee_block = le32_to_cpu(ex->ee_block);
-	if (ext4_ext_is_uninitialized(ex))
-		uninitialized = 1;
 	ex_ee_len = ext4_ext_get_actual_len(ex);
 
 	while (ex >= EXT_FIRST_EXTENT(eh) &&
 			ex_ee_block + ex_ee_len > start) {
+
+		if (ext4_ext_is_uninitialized(ex))
+			uninitialized = 1;
+		else
+			uninitialized = 0;
+
 		ext_debug("remove ext %lu:%u\n", ex_ee_block, ex_ee_len);
 		path[depth].p_ext = ex;
 
-- 
1.6.3.2.214.gf4f78

