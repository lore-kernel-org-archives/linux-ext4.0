Return-Path: <SRS0=e1E2=SG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF034C4360F
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 12:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 820B0214AF
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 12:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfDDMrE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 Apr 2019 08:47:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5666 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727051AbfDDMrE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 Apr 2019 08:47:04 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 26CB4F276120C4E0B79E;
        Thu,  4 Apr 2019 20:47:02 +0800 (CST)
Received: from [127.0.0.1] (10.177.244.145) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.408.0; Thu, 4 Apr 2019
 20:46:56 +0800
Subject: Re: [PATCH] ext4: add inode to ordered data list when extending file
 without block allocation
To:     Jan Kara <jack@suse.cz>
References: <1554370192-113254-1-git-send-email-yi.zhang@huawei.com>
 <20190404101823.GA22313@quack2.suse.cz>
CC:     <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>
From:   "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <c37e682d-a5b3-c23d-0a2c-e09474b64426@huawei.com>
Date:   Thu, 4 Apr 2019 20:46:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20190404101823.GA22313@quack2.suse.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.244.145]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2019/4/4 18:18, Jan Kara Wrote:
> On Thu 04-04-19 17:29:52, zhangyi (F) wrote:
>> Currently we capture a NULL data exposure problem after a crash or
>> poweroff when append writing a file in the data=ordered mode. The
>> problem is that we were not add inode to the transaction's order data
>> list when updating i_disksize without new block allocation no matter
>> the delay allocated block feature is enabled or not.
>>
>> write                           jbd2                    writeback
>> append write in allocated block
>> mark buffer dirty
>> update i_disksize
>> mark inode dirty
>>                           commit transaction
>>                           write inode
>>                           (data exposure after a crash)
>>                                                     write dirty buffer
>>
>> It's fine in the case of new block allocation because we do this job in
>> ext4_map_blocks(). To fix this problem, this patch add inode to current
>> transaction's order data list after new data is copied and needing
>> update i_disksize in the case of no block allocation.
>>
>> Fixes: 06bd3c36a733ac ("ext4: fix data exposure after a crash")
>> Fixes: f3b59291a69d0b ("ext4: remove calls to ext4_jbd2_file_inode() from delalloc write path")
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> 
> Thanks for the patch. The current behavior is a deliberate decision.
> data=ordered mode does guarantee there is no stale data visible in case of
> crash. However it does not guarantee you cannot see zeros where data was
> written. 
> 

Hi Jan,
Thanks a lot for your explanation. I read the Documentation/admin-guide/ext4.rst,
which said about the ordered mode:

> ... When it's time to write the new metadata out to disk, the associated data
> blocks are written first...

So I reckon that the dirty data block should be written to disk before committing
i_disksize and we cannot see the zero data. Now, I don't find any offical docs to
record the behavior you mentioned, do you have some links talk about this behavior
or am I miss something ?

Thanks,
Yi.

>> ---
>>  fs/ext4/inode.c | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index b32a57b..5cfa066 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -1419,6 +1419,16 @@ static int ext4_write_end(struct file *file,
>>  	if (i_size_changed || inline_data)
>>  		ext4_mark_inode_dirty(handle, inode);
>>  
>> +	/*
>> +	 * Updating i_disksize when extending file without block
>> +	 * allocation, the newly written data where should be visible
>> +	 * after transaction commit must be on transaction's ordered
>> +	 * data list.
>> +	 */
>> +	if (copied && (i_size_changed & 0x2) &&
>> +	    ext4_should_order_data(inode))
>> +		ext4_jbd2_inode_add_write(handle, inode);
>> +
>>  	if (pos + len > inode->i_size && ext4_can_truncate(inode))
>>  		/* if we have allocated more blocks and copied
>>  		 * less. We will have blocks allocated outside
>> @@ -3185,6 +3195,15 @@ static int ext4_da_write_end(struct file *file,
>>  			 * bu greater than i_disksize.(hint delalloc)
>>  			 */
>>  			ext4_mark_inode_dirty(handle, inode);
>> +
>> +			/*
>> +			 * Updating i_disksize when extending file without
>> +			 * block allocation, the newly written data where
>> +			 * should be visible after transaction commit must
>> +			 * be on transaction's ordered data list.
>> +			 */
>> +			if (ext4_should_order_data(inode))
>> +				ext4_jbd2_inode_add_write(handle, inode);
>>  		}
>>  	}
>>  
>> -- 
>> 2.7.4
>>

