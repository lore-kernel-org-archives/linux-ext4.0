From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] NULL pointer when make_indexed_dir returns -ENOSPC
Date: Wed, 18 May 2011 08:23:42 -0700
Message-ID: <4DD3E47E.1020804@linux.vnet.ibm.com>
References: <4DCC1FF8.6040103@linux.vnet.ibm.com> <20110517174449.GB30519@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34410 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab1ERPXt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 11:23:49 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4IExa9S022092
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 10:59:36 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4IFNkOY115756
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 11:23:46 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4IFNjQg025448
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 11:23:46 -0400
In-Reply-To: <20110517174449.GB30519@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/17/2011 10:44 AM, Jan Kara wrote:
>    Hello,
>
> On Thu 12-05-11 10:59:20, Allison Henderson wrote:
>> I wasnt sure if people were expecting a v2 for this one, but I
>> noticed the modified version of v1 was removed from the tree, so I
>> am assuming we needed v2?  This one handles marking the buffer dirty
>> before calling do split to avoid the null pointer.  It introduces a
>> little overhead, but the only other option would be to introduce a
>> new flag set to do_split.  But if there's any one that would prefer
>> the flags to this solution, please let me know.  Thx! :)
>    The patch looks OK. Just please CC me next time - a) because ext3 needs a
> similar fix (added now) and b) because I was involved with the previous
> patch version. Thanks!
>
> 								Honza

Sure, I just thought I would save people from the extra spam since it 
was already seen, but I will keep you cc'd next time. Thx!

Allison Henderson

>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>>
>> ---
>> :100644 100644 3c7a06e... b754b77... M	fs/ext4/namei.c
>>   fs/ext4/namei.c |    6 ++++--
>>   1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index 3c7a06e..b754b77 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -1413,6 +1413,10 @@ static int make_indexed_dir(handle_t *handle,
>> struct dentry *dentry,
>>   	frame->at = entries;
>>   	frame->bh = bh;
>>   	bh = bh2;
>> +
>> +	ext4_handle_dirty_metadata(handle, dir, frame->bh);
>> +	ext4_handle_dirty_metadata(handle, dir, bh);
>> +
>>   	de = do_split(handle,dir,&bh, frame,&hinfo,&retval);
>>   	if (!de) {
>>   		/*
>> @@ -1421,8 +1425,6 @@ static int make_indexed_dir(handle_t *handle,
>> struct dentry *dentry,
>>   		 * with corrupted filesystem.
>>   		 */
>>   		ext4_mark_inode_dirty(handle, dir);
>> -		ext4_handle_dirty_metadata(handle, dir, frame->bh);
>> -		ext4_handle_dirty_metadata(handle, dir, bh);
>>   		dx_release(frames);
>>   		return retval;
>>   	}
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

