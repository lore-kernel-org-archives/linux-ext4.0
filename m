From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/6 v7] ext4: Lock i_mutex for punch hole
Date: Wed, 31 Aug 2011 11:49:08 -0700
Message-ID: <4E5E8224.3040607@linux.vnet.ibm.com>
References: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com> <1314750513-10045-5-git-send-email-achender@linux.vnet.ibm.com> <7607E9C9-650E-4C7F-B5EA-1DD76E564C05@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33539 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab1HaStQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 14:49:16 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7VIPrK5020211
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 14:25:53 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7VInF1q131478
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 14:49:15 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VInDha029079
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 15:49:14 -0300
In-Reply-To: <7607E9C9-650E-4C7F-B5EA-1DD76E564C05@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/30/2011 05:31 PM, Andreas Dilger wrote:
> On 2011-08-30, at 6:28 PM, Allison Henderson wrote:
>> This patch modifies the fallocate routine to lock i_mutex during
>> the punch hole operation.
>>
>> Yongqiang noticed that the vfs layer locks i_mutex for truncate,
>> but not fallocate, so the fallocate routine will need to take
>> care of locking i_mutex.  Otherwise a page may be mapped after
>> punch hole has released the pages, but before i_data_sem is
>> locked to release the blocks in the extent tree.
>
> If the VFS is locking i_mutex for truncate, shouldn't the locking for
> fallocate() also be done in the VFS?

Alrighty, I will do some poking around with this idea first.  I dont 
know if other files systems are already locking i_mutex during 
fallocate, and it may be the case that not all filesystems need i_mutex 
locked for fallocate.  So I'll do a little research first, but I will 
post back with what I find.  Thx!

Allison Henderson

>
>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
>> ---
>> :100644 100644 9124cd2... 007fb08... M	fs/ext4/extents.c
>> fs/ext4/extents.c |   10 +++++++---
>> 1 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 9124cd2..007fb08 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3774,8 +3774,13 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>> 	if (mode&  ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>> 		return -EOPNOTSUPP;
>>
>> -	if (mode&  FALLOC_FL_PUNCH_HOLE)
>> -		return ext4_punch_hole(file, offset, len);
>> +	mutex_lock(&inode->i_mutex);
>> +
>> +	if (mode&  FALLOC_FL_PUNCH_HOLE) {
>> +		ret = ext4_punch_hole(file, offset, len);
>> +		mutex_unlock(&inode->i_mutex);
>> +		return ret;	
>> +	}
>>
>> 	trace_ext4_fallocate_enter(inode, offset, len, mode);
>> 	map.m_lblk = offset>>  blkbits;
>> @@ -3789,7 +3794,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>> 	 * credits to insert 1 extent into extent tree
>> 	 */
>> 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
>> -	mutex_lock(&inode->i_mutex);
>> 	ret = inode_newsize_ok(inode, (len + offset));
>> 	if (ret) {
>> 		mutex_unlock(&inode->i_mutex);
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Cheers, Andreas
>
>
>
>
>

