From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH] ext4: Ensure writecache to disk in no journal mode
Date: Fri, 26 Mar 2010 13:16:19 -0400
Message-ID: <4BACEBE3.50108@redhat.com>
References: <1269620462-25906-1-git-send-email-surbhi.palande@canonical.com> <87pr2rhwe0.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Surbhi Palande <surbhi.palande@canonical.com>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab0CZRPy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 13:15:54 -0400
In-Reply-To: <87pr2rhwe0.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/26/2010 12:37 PM, Dmitry Monakhov wrote:
> Surbhi Palande<surbhi.palande@canonical.com>  writes:
>
>    
>> Ensure that in the no journal mode the write cache is flushed to the disk by
>> calling a blkdev_issue_flush() which issues a WRITE_BARRIER if necessary.
>>      
> As soon as i understand, nojournal mode is assumed to be used for
> fail-free block devices(raid + UPS). So we don't have to worry about
> blkdev's wcache vs persistent storage correctness.
>    

I don't think that is a safe assumption. If users want that behavior, 
they can mount with fs without barriers...

ric

>> Signed-off-by: Surbhi Palande<surbhi.palande@canonical.com>
>> ---
>>   fs/ext4/fsync.c |    8 ++++++--
>>   1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
>> index d6049e4..1d73a50 100644
>> --- a/fs/ext4/fsync.c
>> +++ b/fs/ext4/fsync.c
>> @@ -67,8 +67,12 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
>>   	if (ret<  0)
>>   		return ret;
>>
>> -	if (!journal)
>> -		return simple_fsync(file, dentry, datasync);
>> +	if (!journal) {
>> +		ret = simple_fsync(file, dentry, datasync);
>> +		if (test_opt(inode->i_sb, BARRIER))
>> +			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
>> +		return ret;
>> +	}
>>
>>   	/*
>>   	 * data=writeback,ordered:
>>      
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

