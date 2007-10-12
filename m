From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ext4: Support large files
Date: Fri, 12 Oct 2007 12:42:41 +0530
Message-ID: <470F1E69.8000508@linux.vnet.ibm.com>
References: <1192163815-8721-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1192163815-8721-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20071012070129.GD8122@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:57682 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbXJLHN0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Oct 2007 03:13:26 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9C7D7p5032221
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 17:13:07 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9C7D7WW4853870
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 17:13:07 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9C7AFk8003572
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 17:10:15 +1000
In-Reply-To: <20071012070129.GD8122@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Oct 12, 2007  10:06 +0530, Aneesh Kumar K.V wrote:
>> We add a RO_COMPAT feature to the super
>> block to indicate that some of the inode have i_blocks
>> represented as file system block size units. Super block
>> with this feature set cannot be mounted read write on a kernel
>> with CONFIG_LSF disabled.
>>
>> Super block flag EXT4_FEATURE_RO_COMPAT_HUGE_FILE
>> inode flag  EXT4_HUGE_FILE_FL
> 
> I was wondering where this part of the patch went...


I fogot to update the commit message properly. right now it reads as below 

ext4: Support large files
    
    This patch converts ext4_inode i_blocks to represent total
    blocks occupied by the inode in file system block size.
    Earlier the variable used to represent this in 512 byte
    block size. This actually limited the total size of the file.
    
    The feature is enabled transparently when we write an inode
    whose i_blocks cannot be represnted as 512 byte units in a
    48 bit variable.
    
    inode flag  EXT4_HUGE_FILE_FL



EXT4_FEATURE_RO_COMPAT_HUGE_FILE is set when we start using the higher order 16 bit
it is done in the previous patch. To enable that we need the CONFIG_LSF support.
With CONFIG_LSF support enabled and if the inode have EXT4_HUGE_FILE_FL set that means
i_blocks is represented in terms of file system block size.

> 
>> @@ -2905,10 +2912,32 @@ static int ext4_inode_blocks_set(handle_t *handle,
>>  		/* i_block is stored in the split  48 bit fields */
>>  		raw_inode->i_blocks_lo   = cpu_to_le32((u32)i_blocks);
>>  		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
> 
> I don't think we need to cast (u32) here, since cpu_to_le32() should do
> that already?
> 

yes. will remove the same

>> +	} else {
>> +		/*
>> +		 * i_blocks should be represented in a 48 bit variable
>> +		 * as multiple of  file system block size
>> +		 */
>> +		if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> +					EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
>> +
>> +			err = ext4_journal_get_write_access(handle,
>> +					EXT4_SB(sb)->s_sbh);
>> +			if (err)
>> +				goto err_out;
>> +			ext4_update_dynamic_rev(sb);
>> +			EXT4_SET_RO_COMPAT_FEATURE(sb,
>> +					EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
>> +			sb->s_dirt = 1;
>> +			handle->h_sync = 1;
>> +			err = ext4_journal_dirty_metadata(handle,
>> +					EXT4_SB(sb)->s_sbh);
>> +		}
>> +		ei->i_flags |= EXT4_HUGE_FILE_FL;
>> +		/* i_block is stored in file system block size */
>> +		i_blocks = i_blocks >> (inode->i_blkbits - 9);
>> +		raw_inode->i_blocks_lo   = cpu_to_le32((u32)i_blocks);
>> +		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
>>  	}
> 
> This "else" clause is a LOT like the previous case, maybe they can be
> merges?  Having the feature helper I suggested will reduce that a lot,
> but it still seems like most of it is the same except for the shift.
> 

Yes. ext4_update_feature will simplify the above.


Thanks a lot for all your reviews.

-aneesh
