From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: update uninitialized-block-groups.patch and mballoc-core.patch
Date: Thu, 04 Oct 2007 00:25:45 +0530
Message-ID: <4703E5B1.7090903@linux.vnet.ibm.com>
References: <47036832.7030107@linux.vnet.ibm.com> <20071003183718.GM5578@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:53776 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbXJCS4Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2007 14:56:16 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id l93IuOl2021688
	for <linux-ext4@vger.kernel.org>; Thu, 4 Oct 2007 04:56:24 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l93IxmGC280822
	for <linux-ext4@vger.kernel.org>; Thu, 4 Oct 2007 04:59:48 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l93ItvVo005095
	for <linux-ext4@vger.kernel.org>; Thu, 4 Oct 2007 04:55:57 +1000
In-Reply-To: <20071003183718.GM5578@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Oct 03, 2007  15:30 +0530, Aneesh Kumar K.V wrote:
>> +	if (block_group == sbi->s_gdb_count - 1) {
>> +		/*
>> +		 * Even though mke2fs always initialize first and last group
>> +		 * if some other tool enabled the EXT4_BG_BLOCK_UNINIT we 
>> need
>> +		 * to make sure we calculate the right free blocks
>> +		 */
>> +		free_blocks = ext4_blocks_count(sbi->s_es) -
>> +				le32_to_cpu(sbi->s_es->s_first_data_block) -
>> +				(EXT4_BLOCKS_PER_GROUP(sb) * 
>> sbi->s_groups_count) -
>> +				bit_max;
> 
> Did you verify that subtracting s_first_data_block is indeed the right
> thing to do.  I _think_ yes, but I didn't look at it very closely when
> I wrote it late last night.
> 

yes s_first_data_block is always decremented to find total number of blocks occupied by the 
reset of the group. But now looking at it again i guess i need to have 

EXT4_BLOCKS_PER_GROUP(sb) *  sbi->s_groups_count

as

EXT4_BLOCKS_PER_GROUP(sb) *  (sbi->s_groups_count -1 )


Also for the last group i need to mark_end_bitmap_end from a lower value. 

if ( last_group) {
group_block = ext4_blocks_count(sbi->s_es) - e32_to_cpu(sbi->s_es->s_first_data_block) -
              EXT4_BLOCKS_PER_GROUP(sb) * (sbi->s_groups_count - 1)

} else {
 group_block = EXT4_BLOCKS_PER_GROUP(sb)

}


free_blocks = group_block - bit_max


mark_bitmap_end(group_block, ...)


-aneesh
