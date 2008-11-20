From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] ext4: unlock group before ext4_error
Date: Fri, 21 Nov 2008 00:17:46 +0530
Message-ID: <20081120184746.GC11212@skywalker>
References: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4925ADDF.10103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Peter Staubach <staubach@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59838 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbYKTStP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Nov 2008 13:49:15 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAKImPfi008217
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:48:25 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAKImDjT3825856
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:48:13 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAKIlv3P026717
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:47:58 +1100
Content-Disposition: inline
In-Reply-To: <4925ADDF.10103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 20, 2008 at 01:35:11PM -0500, Peter Staubach wrote:
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 772e05b..039a5a6 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -460,10 +460,12 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
>>  			blocknr +=
>>  			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
>>  +			ext4_unlock_group(sb, e4b->bd_group);
>>  			ext4_error(sb, __func__, "double-free of inode"
>>  				   " %lu's block %llu(bit %u in group %u)\n",
>>  				   inode ? inode->i_ino : 0, blocknr,
>>  				   first + i, e4b->bd_group);
>> +			ext4_unlock_group(sb, e4b->bd_group);
>>   
>
> This should be ext4_lock_group(sb, e4b->bd_group); shouldn't it?

Yes, I need to update at two place

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 039a5a6..728221e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -465,7 +465,7 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 				   " %lu's block %llu(bit %u in group %u)\n",
 				   inode ? inode->i_ino : 0, blocknr,
 				   first + i, e4b->bd_group);
-			ext4_unlock_group(sb, e4b->bd_group);
+			ext4_lock_group(sb, e4b->bd_group);
 		}
 		mb_clear_bit(first + i, e4b->bd_info->bb_bitmap);
 	}
@@ -4621,7 +4621,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 			ext4_error(sb, __func__,
 			    "Double free of blocks %d (%d %d)\n",
 			    block, entry->start_blk, entry->count);
-			ext4_unlock_group(sb, e4b->bd_group);
+			ext4_lock_group(sb, e4b->bd_group);
 			return 0;
 		}
 	}
