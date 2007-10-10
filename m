From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: max file size for ext3
Date: Wed, 10 Oct 2007 11:05:59 +0530
Message-ID: <470C64BF.509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:42243 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbXJJFgi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2007 01:36:38 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9A5aaWW021335
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 15:36:36 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9A5aQGM3342350
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 15:36:26 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9A5XXNN023132
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 15:33:33 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I am looking at ext4_max_size and was confused how the
number upper_limit = 0x1ff7fffd000LL is arrived. 
The comment says the value is arrived looking at 4K.
So i tried the below program. 

main()
{
	unsigned long long upper_limit, meta_blocks;
	int bits = 12;

	/* total blocks in 512 bytes */
	upper_limit = (1LL << 32) - 1;
	/* total blocks in file system block size */
	upper_limit >>= (bits - 9);


	meta_blocks = 1;
	/* double indirect blocks */
	meta_blocks += 1 + 1LL << (bits-2);
	/* tripple indirect blocks */
	meta_blocks += 1 + 1LL << (bits-2) + 1LL << (2*(bits-2));

	upper_limit -= meta_blocks;
	upper_limit <<= bits;

	printf("%x\n", upper_limit);
}

Can somebody help me to find out what is missing in the above ?



I also think hardcoding 4k block size is not correct. I have the below
patch pending with large file size.

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2083c19..9f39cfb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1511,6 +1511,7 @@ static void ext4_orphan_cleanup (struct super_block * sb,
 static loff_t ext4_max_size(int bits, struct super_block *sb)
 {
 	loff_t res = EXT4_NDIR_BLOCKS;
+	loff_t total_meta_blocks;
 	/* This constant is calculated to be the largest file size for a
 	 * dense, 4k-blocksize file such that the total number of
 	 * sectors in the file, including data and all indirect blocks,
@@ -1518,11 +1519,34 @@ static loff_t ext4_max_size(int bits, struct super_block *sb)
 	loff_t upper_limit;
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_LARGE_BLOCK)) {
-		/* FIXME!! */
-		upper_limit = (1LL << (bits + 32)) - 1;
+		/*
+		 * With __u32 i_blocks representing the total number of blocks
+		 * of the file in file system block size, the max file size
+		 * would be  2**(32) - 1 - blocks taken by the meta data
+		 * blocks multiplied by block size.
+		 */
+		/* total blocks in file system block size*/
+		upper_limit = (1LL << 32) - 1;
+
 	} else {
-		upper_limit = 0x1ff7fffd000LL;
+		/* total blocks in 512 bytes */
+		upper_limit = (1LL << 32) - 1;
+		/* total blocks in file system block size */
+		upper_limit >>= (bits - 9);
+
+		//upper_limit = 0x1ff7fffd000LL;
 	}
+
+	/* indirect blocks */
+	meta_blocks = 1;
+	/* double indirect blocks */
+	meta_blocks += 1 + 1LL << (bits-2);
+	/* tripple indirect blocks */
+	meta_blocks += 1 + 1LL << (bits-2) + 1LL << (2*(bits-2));
+
+	upper_limit -= meta_blocks;
+	upper_limit <<= bits;
+
 	res += 1LL << (bits-2);
 	res += 1LL << (2*(bits-2));
 	res += 1LL << (3*(bits-2));
