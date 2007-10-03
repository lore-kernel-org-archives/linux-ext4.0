From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: update uninitialized-block-groups.patch and mballoc-core.patch
Date: Thu, 04 Oct 2007 00:34:16 +0530
Message-ID: <4703E7B0.7060900@linux.vnet.ibm.com>
References: <47036832.7030107@linux.vnet.ibm.com> <20071003183718.GM5578@schatzie.adilger.int> <4703E5B1.7090903@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:58574 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbXJCTEV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2007 15:04:21 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l93J4LYO001569
	for <linux-ext4@vger.kernel.org>; Thu, 4 Oct 2007 05:04:21 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l93J7rKv202472
	for <linux-ext4@vger.kernel.org>; Thu, 4 Oct 2007 05:07:53 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l93J4Jkh012418
	for <linux-ext4@vger.kernel.org>; Thu, 4 Oct 2007 05:04:19 +1000
In-Reply-To: <4703E5B1.7090903@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Aneesh Kumar K.V wrote:
> 
> 
> Andreas Dilger wrote:
>> On Oct 03, 2007  15:30 +0530, Aneesh Kumar K.V wrote:
>>> +    if (block_group == sbi->s_gdb_count - 1) {
>>> +        /*
>>> +         * Even though mke2fs always initialize first and last group
>>> +         * if some other tool enabled the EXT4_BG_BLOCK_UNINIT we need
>>> +         * to make sure we calculate the right free blocks
>>> +         */
>>> +        free_blocks = ext4_blocks_count(sbi->s_es) -
>>> +                le32_to_cpu(sbi->s_es->s_first_data_block) -
>>> +                (EXT4_BLOCKS_PER_GROUP(sb) * sbi->s_groups_count) -
>>> +                bit_max;
>>
>> Did you verify that subtracting s_first_data_block is indeed the right
>> thing to do.  I _think_ yes, but I didn't look at it very closely when
>> I wrote it late last night.
>>
> 
> yes s_first_data_block is always decremented to find total number of 
> blocks occupied by the reset of the group. But now looking at it again i 
> guess i need to have




diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 8613914..34b1e11 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -50,7 +50,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 {
 	unsigned long start;
 	int bit, bit_max;
-	unsigned free_blocks;
+	unsigned free_blocks, group_blocks;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	if (bh) {
@@ -96,14 +96,15 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		 * if some other tool enabled the EXT4_BG_BLOCK_UNINIT we need
 		 * to make sure we calculate the right free blocks
 		 */
-		free_blocks = ext4_blocks_count(sbi->s_es) -
-				le32_to_cpu(sbi->s_es->s_first_data_block) -
-				(EXT4_BLOCKS_PER_GROUP(sb) * sbi->s_groups_count) -
-				bit_max;
+		group_blocks = ext4_blocks_count(sbi->s_es) -
+			le32_to_cpu(sbi->s_es->s_first_data_block) -
+			(EXT4_BLOCKS_PER_GROUP(sb) * (sbi->s_groups_count -1));
 	} else {
-		free_blocks = EXT4_BLOCKS_PER_GROUP(sb) - bit_max;
+		group_blocks = EXT4_BLOCKS_PER_GROUP(sb);
 	}
 
+	free_blocks = group_blocks - bit_max;
+
 	if (bh) {
 		for (bit = 0; bit < bit_max; bit++)
 			ext4_set_bit(bit, bh->b_data);
@@ -123,8 +124,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		 * blocksize * 8 ( which is the size of bitmap ), set rest of the
 		 * block bitmap to 1
 		 */
-		mark_bitmap_end(EXT4_BLOCKS_PER_GROUP(sb),
-					sb->s_blocksize * 8, bh->b_data);
+		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
 	}
 
 	return free_blocks - sbi->s_itb_per_group - 2;
