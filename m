From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use the correct block number when reading the super block.
Date: Mon, 31 Dec 2007 13:22:12 +0530
Message-ID: <1199087532-9906-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:37488 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbXLaHwr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Dec 2007 02:52:47 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id lBV7rPI4013860
	for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2007 18:53:25 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBV7qjhl3493952
	for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2007 18:52:46 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBV7qTPq014482
	for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2007 18:52:29 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the block device hard sector size is larger than EXT4_MIN_BLOCK_SIZE we
end up with wrong block number when reading super block.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1ca0f54..832e1ad 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1629,8 +1629,8 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	 * block sizes.  We need to calculate the offset from buffer start.
 	 */
 	if (blocksize != EXT4_MIN_BLOCK_SIZE) {
-		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = do_div(logical_sb_block, blocksize);
+		logical_sb_block = (sb_block * EXT4_MIN_BLOCK_SIZE) / blocksize;
+		offset = do_div((sb_block * EXT4_MIN_BLOCK_SIZE), blocksize);
 	} else {
 		logical_sb_block = sb_block;
 	}
-- 
1.5.4.rc2-dirty
