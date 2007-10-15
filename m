From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 5/5] ext3: Fix the max file size for ext3 file system.
Date: Mon, 15 Oct 2007 16:25:38 +0530
Message-ID: <1192445738-17591-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1192445738-17591-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1192445738-17591-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1192445738-17591-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1192445738-17591-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1192445738-17591-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:54341 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932AbXJOK4R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2007 06:56:17 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9FAuGvZ004986
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 20:56:16 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9FAuGRC946208
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 20:56:16 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9FAu0tx020950
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 20:56:00 +1000
In-Reply-To: <1192445738-17591-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The max file size for ext3 file system is now calculated
with hardcoded 4K block size. The patch fixes it to be
calculated with the right block size.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext3/super.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 9537316..4f0de11 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1362,11 +1362,31 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 static loff_t ext3_max_size(int bits)
 {
 	loff_t res = EXT3_NDIR_BLOCKS;
-	/* This constant is calculated to be the largest file size for a
-	 * dense, 4k-blocksize file such that the total number of
+	int meta_blocks;
+	loff_t upper_limit;
+
+	/* This is calculated to be the largest file size for a
+	 * dense, file such that the total number of
 	 * sectors in the file, including data and all indirect blocks,
-	 * does not exceed 2^32. */
-	const loff_t upper_limit = 0x1ff7fffd000LL;
+	 * does not exceed 2^32 -1
+	 * __u32 i_blocks representing the total number of
+	 * 512 bytes blocks of the file
+	 */
+	upper_limit = (1LL << 32) - 1;
+
+	/* total blocks in file system block size */
+	upper_limit >>= (bits - 9);
+
+
+	/* indirect blocks */
+	meta_blocks = 1;
+	/* double indirect blocks */
+	meta_blocks += 1 + (1LL << (bits-2));
+	/* tripple indirect blocks */
+	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));
+
+	upper_limit -= meta_blocks;
+	upper_limit <<= bits;
 
 	res += 1LL << (bits-2);
 	res += 1LL << (2*(bits-2));
@@ -1374,6 +1394,10 @@ static loff_t ext3_max_size(int bits)
 	res <<= bits;
 	if (res > upper_limit)
 		res = upper_limit;
+
+	if (res > MAX_LFS_FILESIZE)
+		res = MAX_LFS_FILESIZE;
+
 	return res;
 }
 
-- 
1.5.3.4.206.g58ba4-dirty
